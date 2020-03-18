//
//  CommentDataTool.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

//NS_ASSUME_NONNULL_BEGIN

@interface CommentDataTool : NSObject

+ (NSString *) md5:(NSString *) input;
+ (NSString *) createUUIDString;
+ (NSString *) encodeString:(NSString*)unencodedString;
+ (NSString *) decodeString:(NSString *)encodedString;

+ (NSString*)dateWithString:(NSString*)str Format:(NSString*)format;
+ (NSString *)dateMSWithString:(NSString*)str Format:(NSString*)format;
+ (NSString*)dateWithDate:(NSDate*)date Format:(NSString*)format;
+ (NSString*)currentDateWithFormat:(NSString*)format;

+ (UIImage*) createImageWithColor: (UIColor*) color;
+ (UIColor *)colorFromImage:(UIImage *)image;
+ (NSString*) sha1WithString:(NSString *)str;
+ (NSString*)convertToJsonString:(id)infoDict;
@end

//NS_ASSUME_NONNULL_END
