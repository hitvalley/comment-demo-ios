//
//  SemobSystemInfo.m
//  SeMob
//
//  Created by taopeng on 14-9-5.
//
//

#import "SemobSystemInfo.h"
#import <sys/sysctl.h>

static SemobSystemInfo* instance = nil;

@implementation SemobSystemInfo

@synthesize screenType = screenType_;

+ (SemobSystemInfo*) Instance
{
    if (instance == nil) {
        instance = [[SemobSystemInfo alloc] init];
    }
    
    return instance;
}

- (id) init
{
    if (self = [super init]) {
        screenType_ = ScreenType_unknow;
    }
    return self;
}

- (BOOL) isIOS9
{
    if (([[[UIDevice currentDevice] systemVersion] intValue] >= 9)
        && ([[[UIDevice currentDevice] systemVersion] intValue] < 10)) {
        return YES;
    }
    return NO;

}

- (BOOL) isIOS7
{
    if (([[[UIDevice currentDevice] systemVersion] intValue] >= 7)
        && ([[[UIDevice currentDevice]systemVersion] intValue] < 8)) {
        return YES;
    }
    return NO;
}

- (BOOL) isIOS8
{
    if (([[[UIDevice currentDevice]systemVersion] intValue] >= 8)){
        return YES;
    }
    return NO;
}

- (BOOL) isLessVersion: (CGFloat) version
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < version) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) isLessAndEqual: (CGFloat) version
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= version) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) isGreateVersion: (CGFloat) version
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > version) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) isGreateAndEqual: (CGFloat) version
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= version) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isIPhone4
{
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (([UIScreen mainScreen].scale == 2 && screemMaxValue == 480.0))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isIPhone5 {
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (([UIScreen mainScreen].scale == 2 && screemMaxValue == 568.0)
        || [[self getDeviceModelName] isEqualToString:@"iPhone 5 (GSM)"]
        || [[self getDeviceModelName] isEqualToString:@"iPhone 5 (CDMA)"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isIPhone6
{
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (([UIScreen mainScreen].scale == 2 && screemMaxValue == 667.0)
        || [[self getDeviceModelName] isEqualToString:@"iPhone 6"]
        || [[self getDeviceModelName] isEqualToString:@"iPhone 6s"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isIPhone6EnlargeMode{
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (([UIScreen mainScreen].scale == 2 && screemMaxValue == 568.0) &&
        [[self getDeviceModelName] hasPrefix:@"iPhone 6"]){
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)isIPhoneEnlargeMode{
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (([UIScreen mainScreen].scale == 3 && screemMaxValue == 667.0)){
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)isIPhonePlus
{
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (([UIScreen mainScreen].scale == 3 && screemMaxValue == 736.0)
        || [[self getDeviceModelName] rangeOfString:@"Plus"].location != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isIPhoneX { //iphonexs 2436 * 1125 || pt: 812 * 375
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (screemMaxValue == 812.0) {
        return YES;
    } else {
        return NO;
    }
}


- (BOOL)isIPhoneXSeries {
    return [self isIPhoneX] || [self isIPhoneXrOrXsMax] || [self isIPhoneXR];
}

- (BOOL)isIPhoneXS_MAX { //分辨率：2688 * 1242 || pt: 896 * 414
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (([UIScreen mainScreen].scale == 3 && screemMaxValue == 896)
        || [[self getDeviceModelName] rangeOfString:@"iPhone XS Max"].location != NSNotFound) {
        if ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO) {
            return YES;
        }else {
            return NO;
        }
    } else {
        return NO;
    }
}
- (BOOL)isIPhoneXR { //1792 * 828 || pt: 896 * 414
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (([UIScreen mainScreen].scale == 2 && screemMaxValue == 896)
        || [[self getDeviceModelName] rangeOfString:@"iPhone XR"].location != NSNotFound) {
        if ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size): NO) {
            return YES;
        }else {
            return NO;
        }
    } else {
        return NO;
    }
}
- (BOOL)isIPhoneXrOrXsMax {
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger screemMaxValue = MAX(screenHeight, screenWidth);
    if (screemMaxValue == 896) {
        return YES;
    }else {
        return NO;
    }
}
- (NSString *)getDeviceModelName
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])  return @"iPhone 4S (GSM)";
    if ([platform isEqualToString:@"iPhone4,2"])  return @"iPhone 4S (CDMA)";
    if ([platform isEqualToString:@"iPhone5,1"])  return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])  return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 A1660";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus A1661";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 A1778";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus A1784";

    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])    return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    
    return platform;
}

- (NSString *)identifier{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform isEqualToString:@"x86_64"])     return @"Simulator";
    if ([platform isEqualToString:@"i386"])       return @"Simulator";
    if ([platform isEqualToString:@"iPhone1,1"])  return @"iPhone";
    if ([platform isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])  return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])  return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,3"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])  return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])  return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])  return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])  return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])  return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])  return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])  return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    return platform;
}



- (ScreenType) checkHardWare:(CGRect) frame
{
    if ([self isIPhoneXS_MAX]) {
        screenType_ = ScreenType_iphoneXS_MAX;
    } else if ([self isIPhoneXR]) {
        screenType_ = ScreenType_iphoneXR;
    } else if ([self isIPhoneX]) {
        screenType_ = ScreenType_iphoneX;
    }
    else if ((frame.size.width == 320) && (frame.size.height == 480)) {
        screenType_ = ScreenType_iphone4;
    }
    else if((frame.size.width == 480) && (frame.size.height == 320))
    {
        screenType_ = ScreenType_iphone4;
    }
    else if((frame.size.width == 320) && (frame.size.height == 568))
    {
        screenType_ = ScreenType_iphone5;
    }
    else if((frame.size.width == 568) && (frame.size.height == 320))
    {
        screenType_ = ScreenType_iphone5;
    }
    else if((frame.size.width == 568) && (frame.size.height == 320))
    {
        screenType_ = ScreenType_iphone5;
    }
    else if((frame.size.width == 375) && (frame.size.height == 667))
    {
        screenType_ = ScreenType_iphone6;
    }
    else if((frame.size.width == 667) && (frame.size.height == 375))
    {
        screenType_ = ScreenType_iphone6;
    }
    else if((frame.size.width == 414) && (frame.size.height == 736))
    {
        screenType_ = ScreenType_iphone6P;
    }
    else if((frame.size.width == 736) && (frame.size.height == 414))
    {
        screenType_ = ScreenType_iphone6P;
    }else if((frame.size.width == 896) && (frame.size.height == 414)){
        NSInteger scale = (NSInteger) [UIScreen mainScreen].scale;
        if (scale == 3) {
            screenType_ = ScreenType_iphoneXS_MAX;
        }else {
            screenType_ = ScreenType_iphoneXR;
        }
    }else if((frame.size.width == 414) && (frame.size.height == 896)){
        NSInteger scale = (NSInteger) [UIScreen mainScreen].scale;
        if (scale == 3) {
            screenType_ = ScreenType_iphoneXS_MAX;
        }else {
            screenType_ = ScreenType_iphoneXR;
        }
    }
    else
    {
        screenType_ = ScreenType_unknow;
    }
    
    
    return screenType_;
}
@end
