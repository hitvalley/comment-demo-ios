//
//  SeMobNewsCommentTextView.h
//  SeMob
//
//  Created by qingtaogao on 2017/5/19.
//
//

#import <UIKit/UIKit.h>

@interface SeMobNewsCommentTextView : UITextView
{
    NSString *placeholder;
    
    UIColor *placeholderColor;
@private
    UILabel *placeHolderLabel;
}
@property(nonatomic, strong) UILabel *placeHolderLabel;

@property(nonatomic, strong,setter=setPlaceholder:) NSString *placeholder;

@property(nonatomic, strong,setter=setPlaceholderColor:) UIColor *placeholderColor;
@property(nonatomic, assign) BOOL hasSetAttributeText;


- (void)textChanged:(NSNotification*)notification;
- (void)setPlaceholderColor:(UIColor*) color;
- (void)setPlaceholder:(NSString*)text;

@end
