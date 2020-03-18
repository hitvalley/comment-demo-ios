//
//  CommentDataTool.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "CommentDataTool.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation CommentDataTool


/**
 * MD5加密
 */
+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
+ (NSString *)createUUIDString {
    
    NSString *randomUuid = [[NSUUID UUID] UUIDString];
    NSString * lastUuid = [randomUuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return lastUuid;
}

+ (NSString *) encodeString:(NSString*)unencodedString {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    
    // CharactersToLeaveUnescaped = @"[].";
    
//    NSString*encodedString=(NSString*)
//
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//
//                                                              (CFStringRef)unencodedString,
//
//                                                              NULL,
//
//                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//
//                                                              kCFStringEncodingUTF8));
//
//    return encodedString;
    
    NSString * charaters = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:charaters] invertedSet];
    NSString * sourceStr = unencodedString;
    NSString * targetStr = [sourceStr stringByAddingPercentEncodingWithAllowedCharacters:set];
//    NSLog(@"targetStr ====== %@",targetStr);
    return targetStr;
}

//URLDEcode

+ (NSString *)decodeString:(NSString *)encodedString
{
//    NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *decodedString = [encodedString stringByRemovingPercentEncoding];
    
//    NSString *decodedString =(__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
//        (__bridge CFStringRef)encodedString, CFSTR(""),          CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

+ (NSString*)convertToJsonString:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    if (! jsonData) {
        NSLog(@"error: %@", error);
    }else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}
#pragma mark - time & date

/**1.时间戳转换成时间*/

+ (NSString*)dateWithString:(NSString*)str Format:(NSString*)format
{
    NSTimeInterval time = [str doubleValue];
    /** [[NSDate date] timeIntervalSince1970]*1000;*/
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormatter setDateFormat:format];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

/**2.时间戳转换时间-毫秒*/

+ (NSString *)dateMSWithString:(NSString*)str Format:(NSString*)format
{
    NSTimeInterval time = [str doubleValue]/1000;
    /** [[NSDate date] timeIntervalSince1970]*1000;*/
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormatter setDateFormat:format];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

/**3.转换成时间*/

+ (NSString*)dateWithDate:(NSDate*)date Format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormatter setDateFormat:format];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

/**4.当前时间戳转换成时间*/

+ (NSString*)currentDateWithFormat:(NSString*)format
{
    NSDate*detaildate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormatter setDateFormat:format];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

#pragma mark - image && color
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect= CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIColor *)colorFromImage:(UIImage *)image {
    //UIImage转UIColor
    return [UIColor colorWithPatternImage:image];
}

#pragma mark - Encrypt/Decrypt
+ (NSString*) sha1WithString:(NSString *)str
{
    if (!str || [str length] < 1) {
        return nil;
    }
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
@end
