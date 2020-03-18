//
//  SemobSystemInfo.h
//  SeMob
//
//  Created by taopeng on 14-9-5.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

typedef enum screenTyep{
    ScreenType_unknow,
    ScreenType_iphone4,
    ScreenType_iphone5,
    ScreenType_iphone6,
    ScreenType_iphone6P,
    ScreenType_iphoneX,
    ScreenType_iphoneXR,
    ScreenType_iphoneXS_MAX,
} ScreenType;

typedef enum deviceOrientationType{
    DeviceOrientation_Portrait,
    DeviceOrientation_LandscapeLeft,
    DeviceOrientation_LandscapeRight
}DeviceOrientationType;

@interface SemobSystemInfo : NSObject
{
    ScreenType screenType_;
}

@property (nonatomic, readonly) ScreenType screenType;

+ (SemobSystemInfo*) Instance;
- (BOOL) isIOS9;
- (BOOL) isIOS7;
- (BOOL) isIOS8;
- (NSString *)getDeviceModelName;
- (BOOL)isIPhoneEnlargeMode;
- (BOOL)isIPhone6EnlargeMode;
- (BOOL)isIPhonePlus;
- (BOOL)isIPhone6;
- (BOOL)isIPhone4;
- (BOOL)isIPhone5;
- (BOOL)isIPhoneX;
- (BOOL)isIPhoneXSeries;
- (BOOL)isIPhoneXR;
- (BOOL)isIPhoneXS_MAX;
- (BOOL)isIPhoneXrOrXsMax;
- (NSString *)identifier;
- (ScreenType) checkHardWare:(CGRect) frame;

- (BOOL) isLessVersion: (CGFloat) version;
- (BOOL) isLessAndEqual: (CGFloat) version;
- (BOOL) isGreateVersion: (CGFloat) version;
- (BOOL) isGreateAndEqual: (CGFloat) version;



@end
