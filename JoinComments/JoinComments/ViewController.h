//
//  ViewController.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/10.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeMobNewsCommentTextView.h"
#import "UIBarButtonItem+Custom.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView * pageView;
@property (weak, nonatomic) IBOutlet UITableView *pageTableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageNumber;
@end

