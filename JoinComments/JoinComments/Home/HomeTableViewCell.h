//
//  HomeTableViewCell.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/11.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTopicModel.h"

//NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * mainTLabel;
@property (weak, nonatomic) IBOutlet UILabel * subTLabel;
@property (weak, nonatomic) IBOutlet UIView * topLine;
@property (weak, nonatomic) IBOutlet UIView * bottomLine;

- (void)showTopLine:(BOOL)show;
- (void)showBottomLine:(BOOL)show;
- (void)refreshCellWithModel:(HomeTopicModel *)model;
@end

//NS_ASSUME_NONNULL_END
