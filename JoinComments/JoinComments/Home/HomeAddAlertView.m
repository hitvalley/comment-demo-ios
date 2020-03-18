//
//  HomeAddAlertView.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/14.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "HomeAddAlertView.h"

@interface HomeAddAlertView()<UITextViewDelegate>

@property (nonatomic,strong) UIView * backgroundView;
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIButton * confirmBtn;
@property (nonatomic,strong) UIButton * cancelBtn;

@end

@implementation HomeAddAlertView

+ (HomeAddAlertView * _Nullable)showAddAlerViewConfirm:(ConfirmAddBlock) addBlock cancel:(CancelAddBlock) cancelBlock {
    HomeAddAlertView * alerView = [[HomeAddAlertView alloc] init];
    alerView.confirmBlock = addBlock;
    alerView.cancelBlock = cancelBlock;
    [alerView displayAlertViewInView:nil annimated:YES];
    return alerView;
}

- (instancetype)init {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat maxValue = MAX(bounds.size.width, bounds.size.height);
    CGFloat minValue = MIN(bounds.size.width, bounds.size.height);
    self = [super initWithFrame:CGRectMake(0, 0, minValue, maxValue)];
    if (self) {
        self.backgroundColor  = [UIColor clearColor];
    }
    return self;
}

- (void)createSubviews {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat maxValue = MAX(bounds.size.width, bounds.size.height);
    CGFloat minValue = MIN(bounds.size.width, bounds.size.height);
    UIView * bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, minValue, maxValue)];
    bView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self addSubview:bView];
    self.backgroundView = bView;
    
//    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
//    [keyWindow addSubview:bView];
    UIView * cView = [[UIView alloc] init];
    cView.backgroundColor = [UIColor whiteColor];
    [bView addSubview:cView];
    cView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView = cView;
    NSLayoutConstraint * leftCons = [NSLayoutConstraint constraintWithItem:cView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:bView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    leftCons.active = YES;
    NSLayoutConstraint * rightCons = [NSLayoutConstraint constraintWithItem:cView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:bView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    rightCons.active = YES;
    NSLayoutConstraint * centerCons = [NSLayoutConstraint constraintWithItem:cView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    centerCons.active = YES;
    NSLayoutConstraint * centerYCons = [NSLayoutConstraint constraintWithItem:cView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    centerYCons.active = YES;
    NSLayoutConstraint * heightCons = [NSLayoutConstraint constraintWithItem:cView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:220];
    heightCons.active = YES;
    
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.text = @"添加话题";
    [cView addSubview:titleLabel];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    leftCons = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    leftCons.active = YES;
    rightCons = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    rightCons.active = YES;
    NSLayoutConstraint *topCons = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    topCons.active = YES;
    heightCons = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    heightCons.active = YES;
    
    
    SeMobNewsCommentTextView * topicTextView = [[SeMobNewsCommentTextView alloc] init];
    topicTextView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [topicTextView setFont:[UIFont boldSystemFontOfSize:16]];
    topicTextView.textAlignment = NSTextAlignmentLeft;
    topicTextView.textColor = [UIColor blackColor];
    topicTextView.placeholder = @"请输入话题";
    topicTextView.placeholderColor = [UIColor lightGrayColor];
    [cView addSubview:topicTextView];
    topicTextView.delegate = self;
    
    topicTextView.translatesAutoresizingMaskIntoConstraints = NO;
    leftCons = [NSLayoutConstraint constraintWithItem:topicTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    leftCons.active = YES;
    rightCons = [NSLayoutConstraint constraintWithItem:topicTextView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    rightCons.active = YES;
   topCons = [NSLayoutConstraint constraintWithItem:topicTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    topCons.active = YES;
    heightCons = [NSLayoutConstraint constraintWithItem:topicTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    heightCons.active = YES;
    self.inputTextView = topicTextView;
    
    UIButton * cancelBtn = [[UIButton alloc] init];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    
    UIButton * confirmBtn = [[UIButton alloc] init];
    confirmBtn.backgroundColor = [UIColor clearColor];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [cView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn = confirmBtn;
    
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    leftCons = [NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    leftCons.active = YES;
    rightCons = [NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:confirmBtn attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    rightCons.active = YES;
    topCons = [NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topicTextView attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    topCons.active = YES;
    NSLayoutConstraint *bottomCons = [NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    bottomCons.active = YES;
    
    confirmBtn.translatesAutoresizingMaskIntoConstraints = NO;
    leftCons = [NSLayoutConstraint constraintWithItem:confirmBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cancelBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    leftCons.active = YES;
    rightCons = [NSLayoutConstraint constraintWithItem:confirmBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    rightCons.active = YES;
    topCons = [NSLayoutConstraint constraintWithItem:confirmBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topicTextView attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    topCons.active = YES;
    NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:confirmBtn attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    widthCons.active = YES;
    bottomCons = [NSLayoutConstraint constraintWithItem:confirmBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    bottomCons.active = YES;
    
}

- (void)displayAlertViewInView:(UIView *)sView annimated:(BOOL) animated{
    if (sView) {
        [sView addSubview:self];
    }else {
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview:self];
    }
    [self createSubviews];
    self.hidden = YES;
    UIView * tempView = self.superview;
    [UIView performWithoutAnimation:^{
        [tempView layoutIfNeeded];
        [self layoutIfNeeded];
    }];
    if (animated) {
        self.backgroundView.alpha = 0;
        self.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        self.hidden = NO;
    }
}
- (void)layoutSubviews {
    if (self.contentView && self.confirmBtn) {
        NSString * text = self.inputTextView.text;
        if(text && [text length] > 0) {
            self.confirmBtn.enabled = true;
        }else {
            self.confirmBtn.enabled = false;
        }
    }else {
        self.confirmBtn.enabled = false;
    }
    [super layoutSubviews];
    
}


- (void)clickCancelBtn:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.cancelBlock) {
            self.cancelBlock(self);
        }
    }];
}

- (void)clickConfirmBtn:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        NSString * content = self.inputTextView.text;
        [self removeFromSuperview];
        if (self.confirmBlock) {
            self.confirmBlock(self, content);
        }
    }];
}


#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"输入变化");
    NSString * text = textView.text;
    if(text && [text length] > 0) {
        self.confirmBtn.enabled = true;
    }else {
        self.confirmBtn.enabled = false;
    }
}
@end
