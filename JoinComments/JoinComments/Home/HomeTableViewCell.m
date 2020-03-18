//
//  HomeTableViewCell.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/11.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "CommentDataTool.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showTopLine:(BOOL)show {
    self.topLine.hidden = !show;
}
- (void)showBottomLine:(BOOL)show {
    self.bottomLine.hidden = !show;
}
- (void)refreshCellWithModel:(HomeTopicModel *)model {
    self.mainTLabel.text = model.topic_title;
    NSString * timeStr = [NSString stringWithFormat:@"%lld",model.create_time];
    self.subTLabel.text = [CommentDataTool dateWithString:timeStr Format:@"yyyy-MM-dd HH mm:ss"];
}
@end
