//
//  HomeTopicDetailController.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/15.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "HomeTopicDetailController.h"
#import "HomeTopicDetailController+request.h"
#import "HomeTopicDetailController+comment.h"
#import "CommentDataManager.h"
#import "TopicDetailHandler.h"

static NSString * const kCommentPageUrl = @"http://api.demo.valleyjs.cn/test?project_id=";
static NSString * const kCommentProjectId = @"P6c1382ba8c69cc1bd5abae19f62b75f5";
static NSString * const kCommentProjectVcode = @"Demo2020";


// WKWebView 内存不释放的问题解决
@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>

//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

@implementation WeakWebViewScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end

@interface HomeTopicDetailController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>
@property (nonatomic , strong) UIProgressView * progressView;
@end

@implementation HomeTopicDetailController


- (instancetype)initWithModel:(HomeTopicModel *)model {
    self = [super init];
    if (self) {
        self.dataModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"话题详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    [self addPageObserver];
    [self loadTopicDetailData:self.dataModel];
    NSString * url = [NSString stringWithFormat:@"%@%@",kCommentPageUrl,kCommentProjectId];
    [self loadHttpPage:url];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)dealloc {
    [self removePageObserver];
}

- (WKWebViewConfiguration *)createWebviewConfig {
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
     // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
     //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
     //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
     // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
     
     // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
     //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.requiresUserActionForMediaPlayback = YES;
     //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
     //设置请求的User-Agent信息中应用程序名称 iOS9后可用
//     config.applicationNameForUserAgent = @"JoinComments";
      //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
    WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
     //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
     //注册一个name为jsToOcNoPrams的js方法
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
    config.userContentController = wkUController;
    return config;
    
}
- (void)setupSubviews {
    UIView * cView = self.view;
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.text = self.dataModel.topic_title;
    [cView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * leftCons = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    leftCons.active = YES;
    NSLayoutConstraint *rightCons = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    rightCons.active = YES;
    NSLayoutConstraint *topCons = nil;
    if (@available(iOS 11.0, *)) {
        topCons = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cView.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        topCons.active = YES;
    }else {
        topCons = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        topCons.active = YES;
    }
    NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:36];
    heightCons.active = YES;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat minValue = MIN(bounds.size.height, bounds.size.width);
    WKWebViewConfiguration * config = [self createWebviewConfig];
    _pageWebView = [[DWKWebView alloc] initWithFrame:CGRectMake(0, 40, minValue, minValue) configuration:config];
    _pageWebView.backgroundColor = [UIColor whiteColor];
//    _pageWebView.UIDelegate = self;// UI代理
    _pageWebView.navigationDelegate = self; // 导航代理
    _pageWebView.scrollView.delegate = self;
     // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    // UI代理.allowsBackForwardNavigationGestures = YES;
     //可返回的页面列表, 存储已打开过的网页
//    WKBackForwardList * backForwardList =  [_pageWebView backForwardList];
    [cView addSubview:_pageWebView];
    _pageWebView.translatesAutoresizingMaskIntoConstraints = NO;
    
    leftCons = [NSLayoutConstraint constraintWithItem:_pageWebView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    leftCons.active = YES;
    rightCons = [NSLayoutConstraint constraintWithItem:_pageWebView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-0];
    rightCons.active = YES;
    topCons = [NSLayoutConstraint constraintWithItem:_pageWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    topCons.active = YES;
    
    NSLayoutConstraint *bottomCons = [NSLayoutConstraint constraintWithItem:_pageWebView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    bottomCons.active = YES;
    
//    TopicDetailHandler * hanlder = [TopicDetailHandler new];
//    hanlder.ctr = self;
//    [_pageWebView addJavascriptObject:hanlder namespace:nil];
    
    UIProgressView *progView = [[UIProgressView alloc] init];
    progView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    progView.progressViewStyle = UIProgressViewStyleDefault;
    progView.progressTintColor = [UIColor lightGrayColor];
    progView.translatesAutoresizingMaskIntoConstraints = NO;
    [cView addSubview:progView];
    leftCons = [NSLayoutConstraint constraintWithItem:progView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    leftCons.active = YES;
    rightCons = [NSLayoutConstraint constraintWithItem:progView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    rightCons.active = YES;
    topCons = [NSLayoutConstraint constraintWithItem:progView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    topCons.active = YES;
    heightCons = [NSLayoutConstraint constraintWithItem:progView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2];
    heightCons.active = YES;
    self.progressView = progView;
}
- (void)loadLocalPage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JStoOC.html" ofType:nil];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载本地html文件
    [_pageWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}
- (void)loadHttpPage:(NSString *)url {
    //TODO:load page
//    sha1(project_vcode + project_id + open_timestamp)
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString * open_timestamp = [self getSecondClassTimeStamp];
    NSString * togetherStr = [NSString stringWithFormat:@"%@%@%@",kCommentProjectVcode,kCommentProjectId,open_timestamp];
    NSString * project_verify = [CommentDataTool sha1WithString:togetherStr];
    
    [request addValue:open_timestamp forHTTPHeaderField:@"x-comment-project-timestamp"];
    [request addValue:project_verify forHTTPHeaderField:@"x-comment-project-verify"];
    
//    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.pageWebView loadRequest:request];
}

- (void)addPageObserver {
    //添加监测网页加载进度的观察者
     [self.pageWebView addObserver:self
                    forKeyPath:@"estimatedProgress"
                       options:0
                       context:nil];
    //添加监测网页标题title的观察者
     [self.pageWebView addObserver:self
                    forKeyPath:@"title"
                       options:NSKeyValueObservingOptionNew
                       context:nil];

}
- (void)removePageObserver {
    //移除观察者
    [_pageWebView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [_pageWebView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
}
#pragma mark - KVO
 //kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.pageWebView) {
       NSLog(@"网页加载进度 = %f",_pageWebView.estimatedProgress);
        self.progressView.progress = _pageWebView.estimatedProgress;
        if (_pageWebView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                self.progressView.progress = 1;
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.hidden = NO;
            });
        }
    }else if([keyPath isEqualToString:@"title"]
             && object == _pageWebView){
//        self.navigationItem.title = _pageWebView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"进度=%f,预估进度=%f",self.progressView.progress,self.pageWebView.estimatedProgress);
}
#pragma mark - WKUIDelegate
///主要处理JS脚本，确认框，警告框
///
//! Alert弹框
/**
     *  web界面中有弹出警告框时调用
     *
     *  @param webView           实现该代理的webview
     *  @param message           警告框中的内容
     *  @param completionHandler 警告框消失调用
     */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

//! Confirm弹框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];

    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

//! prompt弹框
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text ? : @"");
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
#pragma makr - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
    // 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    [self.progressView setProgress:0.0f animated:NO];
}
    // 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
    // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [self getCookie];
    NSString * dataTemp = [self getProjectCommentData];
//    [self.pageWebView callHandler:@"getData" arguments:@[dataTemp] completionHandler:^(id value){
//              NSLog(@"%@",value);
//       }];
   
}
    //提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    [self.progressView setProgress:0.0f animated:NO];
}
   // 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}
    // 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
    NSString *htmlHeadString = @"github://";
    if([urlStr hasPrefix:htmlHeadString]){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }])];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"github://callName_?" withString:@""]];
//            [[UIApplication sharedApplication] openURL:url];
//        }])];
//        [self presentViewController:alertController animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
    
    // 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
    //需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    //用户身份信息
    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
    //为 challenge 的发送方提供 credential
    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
}
    //进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}

#pragma mark - WKScriptMessageHandler

//被自定义的WKScriptMessageHandler在回调方法里通过代理回调回来，绕了一圈就是为了解决内存不释放的问题
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    //用message.body获得JS传出的参数体
//    NSDictionary * parameter = message.body;
//    //JS调用OC
//    if([message.name isEqualToString:@"jsToOcNoPrams"]){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"js调用到了oc" message:@"不带参数" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }])];
//        [self presentViewController:alertController animated:YES completion:nil];
//
//    }else if([message.name isEqualToString:@"jsToOcWithPrams"]){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"js调用到了oc" message:parameter[@"params"] preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }])];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
}
#pragma mark - 暗黑模式
                                           
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [super encodeWithCoder:coder];
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}
- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}
- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeMake(100, 50);
}
                                           
- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}
- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}
- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}
- (void)setNeedsFocusUpdate {
    
}
- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return YES;
}
- (void)updateFocusIfNeeded {
    
}

#pragma mark - JS interface
- (NSString * )getProjectCommentData {
//   window.project_comment_data={
//  "project_id":"P6c1382ba8c69cc1bd5abae19f62b75f5",
//  "user_info": {"user_id":"U7b72321c57896835a0422ee3ebcf12b9","user_token":"U7581dd154f60d2fc0a83365cd81a5344"},
//  "project_info":{"topic_id":"T08b96b1f677cc0a775d00204a39bfde9","topic_title":"怎样才能发评论呢？"}
//  }
    CommentDataManager * manager = [CommentDataManager shareCommentDataManager];
    NSDictionary * userInfo = @{
        @"user_id":manager.user_id?:@"",
        @"user_token":manager.token?:@"",
    };
    NSDictionary * projectInfo = @{
        @"topic_id":self.dataModel.topic_id?:@"",
        @"topic_title":self.dataModel.topic_title?:@"",
    };
    NSDictionary * dic = @{
        @"project_id": kCommentProjectId,
        @"user_info":userInfo,
        @"project_info":projectInfo,
    };
    NSString * jsonStr = [CommentDataTool convertToJsonString:dic];
    return jsonStr;
}
@end
