//
//  ViewController.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/10.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "ViewController.h"
#import "HomeTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <MJRefresh/MJRefreshConfig.h>
#import "SemobSystemInfo.h"
#import "CommentDataManager.h"
#import "ViewController+request.h"
#import "NotificationKeys.h"
#import "HomeTopicModel.h"
#import "HomeAddAlertView.h"
#import "HomeTopicDetailController.h"
#import "HomeUserController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton * addButton;

@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"话题";
    self.dataArray = [NSMutableArray new];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backButtonWithImage:@"yonghu" highlightedImage:@"yonghuPress" target:self selector:@selector(clickLeftButton:)];

    [self addTableHeaderAndFooter];
    [self insertAddCommentButton];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccessNotification:) name:kUserLoginSuccess object:nil];
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lognpressAction:)];
    [self.pageView addGestureRecognizer:longpress];
    [self showLoginControllerIfNeeded];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserLoginSuccess object:nil];
}

- (void)clickLeftButton:(UIButton *)sender {
    NSLog(@"用户头像");
    HomeUserController * userCtr = [[HomeUserController alloc] init];
    userCtr.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    userCtr.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:userCtr animated:NO completion:^{
        [userCtr showContentViewAnimated:YES];
    }];
}
- (void)showLoginControllerIfNeeded {
    BOOL logined = false;
    if (!logined) {
        //----------------------------------
//        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
//        UINavigationController * entrNavi = (UINavigationController *)keyWindow.rootViewController;
//        [CommentDataManager shareCommentDataManager].enterCtrl = entrNavi;
//        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController * loginNavi = [sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
//        keyWindow.rootViewController = loginNavi;
//        [keyWindow makeKeyAndVisible];
        //----------------------------------
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController * loginNavi = [sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            loginNavi.modalPresentationStyle = UIModalPresentationFullScreen;
            [CommentDataManager shareCommentDataManager].enterCtrl = self.navigationController;
            [self.navigationController presentViewController:loginNavi animated:YES completion:nil];
        });
        
        //----------------------------------
//        [self.navigationController addChildViewController:loginNavi];
//        [loginNavi didMoveToParentViewController:self.navigationController];
//        CGRect rect = [[UIScreen mainScreen] bounds];
//        CGFloat maxValue = MAX(rect.size.width, rect.size.height);
//        CGFloat minValue = MIN(rect.size.width, rect.size.height);
//        [loginNavi.view setFrame:CGRectMake(0,0, minValue, maxValue)];
//        [self.navigationController.view addSubview:loginNavi.view];
    }
}
- (void)addTableHeaderAndFooter {
    [MJRefreshConfig defaultConfig].languageCode = @"zh-Hans";
    __unsafe_unretained UITableView *tableView = self.pageTableView;
    NSInteger pagesize = 5;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [self loadTopicListWithPageNum:0 andPageSize:pagesize endRefresh:true];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([self.dataArray count] > 0) {
            [self loadMoreTopicListWithPageNum:self.pageNumber + 1 andPageSize:pagesize endRefresh:true];
        }else {
            self.pageNumber = 0;
             [self loadMoreTopicListWithPageNum:0 andPageSize:pagesize endRefresh:true];
        }
    }];
}
//添加评论按钮
- (void)insertAddCommentButton {
    UIButton * btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [btn setImage:[UIImage imageNamed:@"addTopic_normal"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"addTopic_press"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(clickAddTopicButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 25;
    btn.layer.masksToBounds = YES;
    self.addButton = btn;
    
    CGFloat widthTemp = 50;//sView.frame.size.width - leftOff*2;
    UIView *  sView = self.view;
    CGFloat startBottom = -10;
    CGFloat heightTemp = 50;
    if ([[SemobSystemInfo Instance] isIPhoneXSeries]) {
        startBottom = -44;
    }
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * rightConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:sView attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
    rightConstraint.active = YES;
    
    NSLayoutConstraint * bottomConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sView attribute:NSLayoutAttributeBottom multiplier:1 constant:startBottom];
    bottomConstraint.active = YES;
    
    NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:widthTemp];
    widthConstraint.active = YES;
    
    NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:heightTemp];
    heightConstraint.active = YES;
}

- (void)startFirstPathDataRequest {
    [self.pageTableView.mj_header beginRefreshing];
//    [self loadTopicListWithPageNum:0 andPageSize:20 endRefresh:false];
}
- (void)lognpressAction:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {//手势开始
        CGPoint point = [ges locationInView:self.pageTableView];
        NSIndexPath *currentIndexPath = [self.pageTableView indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
        NSLog(@"begin:%ld",currentIndexPath.section);
    }
    if (ges.state == UIGestureRecognizerStateEnded)//手势结束
    {
        CGPoint point = [ges locationInView:self.pageTableView];
        NSIndexPath *currentIndexPath = [self.pageTableView indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
        NSLog(@"end:%ld",currentIndexPath.section);
        [self showDeleteTopicAlert:currentIndexPath];
    }
}

- (void)showDeleteTopicAlert:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (!indexPath || row >= [self.dataArray count]) {
        return;
    }
    HomeTopicModel *model = [self.dataArray objectAtIndex:row];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认删除?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消删除:%ld",(long)indexPath.row);
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认删除删除:%ld",(long)indexPath.row);
        [self deleteTopicWithModel:model];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
#pragma mark - notification
- (void)userLoginSuccessNotification:(NSNotification *)noti {
    [self startFirstPathDataRequest];
}
#pragma mark - button methods
- (void)clickAddTopicButton:(UIButton *)sender {
    NSLog(@"添加话题");
    [HomeAddAlertView showAddAlerViewConfirm:^(HomeAddAlertView * _Nullable alert, NSString * _Nullable content) {
        NSLog(@"确定");
        if (content && [content length] >= 1) {
            [self addTopicWithTitle:content];
        }
    } cancel:^(HomeAddAlertView * _Nullable alert) {
        NSLog(@"取消");
    }];
}
#pragma mark - tableview datasource & delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
    
    cell.subTLabel.text = @"aaaaaa";
    if (indexPath.row == 0) {
        [cell showTopLine:NO];
        [cell showBottomLine:YES];
    }else  {
        [cell showTopLine:NO];
        [cell showBottomLine:YES];
    }
    HomeTopicModel * model = self.dataArray[indexPath.row];
    [cell refreshCellWithModel:model];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}
//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= [self.dataArray count]) {
        return ;
    }
    HomeTopicModel * model = [self.dataArray objectAtIndex:indexPath.row];
    HomeTopicDetailController * ctr = [[HomeTopicDetailController alloc] initWithModel:model];
    [self.navigationController pushViewController:ctr animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - ios13 模式

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [super encodeWithCoder:coder];
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
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
    return true;
}

- (void)updateFocusIfNeeded {
    [super updateFocusIfNeeded];
}

@end
