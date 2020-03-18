//
//  HomeTopicDetailController.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/15.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "HomeTopicModel.h"
#import <DWKWebView.h>
#import "CommentDataTool.h"
//#import "TopicDetailHandler.h"
//NS_ASSUME_NONNULL_BEGIN

@interface HomeTopicDetailController : UIViewController

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) DWKWebView * pageWebView;
@property (nonatomic, strong) HomeTopicModel * dataModel;

- (instancetype)initWithModel:(HomeTopicModel *)model;
- (void)loadHttpPage:(NSString *)url;
- (void)loadLocalPage;

- (NSString * )getProjectCommentData;

@end

//NS_ASSUME_NONNULL_END
