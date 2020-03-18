//
//  HomeUserController+request.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/16.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "HomeUserController.h"

//NS_ASSUME_NONNULL_BEGIN

@interface HomeUserController (request)

- (void)loadUserDetailData:(NSString *)userId;
- (void)logoutRequestCompletion: (void (^ __nullable)(void))completion;
@end

//NS_ASSUME_NONNULL_END
