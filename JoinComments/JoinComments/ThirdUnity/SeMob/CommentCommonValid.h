//
//  CommentCommonValid.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#ifndef CommentCommonValid_h
#define CommentCommonValid_h

#pragma mark - NSString
/**
 校验字符串

 @param stringLike 需要进行校验的参数
 @return 是否是有效的字符串
 */
static inline BOOL isValidNSString(id stringLike) {
    if (stringLike && [stringLike isKindOfClass:[NSString class]]) {
        stringLike = [stringLike stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return ([stringLike isEqualToString:@""]  || [stringLike isEqualToString:@"(null)"]) ? NO :YES;
    }
    return NO;
}

/**
 强校验NSString

 @param stringLike 需要进行校验的参数，长度必须>0
 @return 是否是有效的字符串
 */
static inline BOOL isStrongValidNSString(id stringLike) {
    if(isValidNSString(stringLike) && [stringLike length] > 0) {
        return YES;
    }
    return NO;
}

/**
 获取有效的字符串，如果传入的有效，则直接返回，否则返回空串

 @param stringLike 传入字符串
 @return 有效的字符串
 */
static inline NSString* availableNSString(id stringLike) {
    if (isStrongValidNSString(stringLike)) {
        return stringLike;
    }
    return @"";
}
#pragma mark - NSArray

/**
 校验NSArray
 
 @param arrayLike 需要进行校验的数组，只要是NSArray即可
 @return 是否是NSArray
 */
static inline BOOL isValidNSArray(id arrayLike) {
    if (arrayLike && [arrayLike isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

//返回有效的数组
static inline NSArray* availableNSArray(id arraylike) {
    if (isValidNSArray(arraylike)) {
        return arraylike;
    }else{
        return [NSArray new];
    }
}

/**
 校验NSArray

 @param arrayLike 需要进行校验的参数，数组中的数据个数必须>0
 @return 是否是有效的数组
 */
static inline BOOL isStrongValidNSArray(id arrayLike) {
    if (arrayLike && [arrayLike isKindOfClass:[NSArray class]] && [arrayLike count] > 0) {
        return YES;
    }
    return NO;
}


/**
 校验NSSet

 @param setLike 需要进行校验的set，只要是set集合就可以
 @return 是否是NSSet
 */
static inline BOOL isValidSet(id setLike) {
    if (setLike && [setLike isKindOfClass:[NSSet class]]) {
        return YES;
    }
    return NO;
}

static inline BOOL isStrongValidNSSet(id setLike) {
    if (setLike && [setLike isKindOfClass:[NSSet class]] && [setLike count] > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - NSDictionary

/**
 校验NSDictionary
 
 @param dictLike 需要进行校验的字典，确保是字典即可
 @return 是否是NSDictionary
 */
static inline BOOL isValidNSDictionary(id dictLike) {
    if (dictLike && [dictLike isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

/**
 校验 NSDictionary

 @param dictLike 需要进行校验的参数，字典中的数据（key&&value）必须>0
 @return 是否是有效的字典
 */
static inline BOOL isStrongValidNSDictionary(id dictLike) {
    if (dictLike && [dictLike isKindOfClass:[NSDictionary class]] && [[dictLike allKeys] count] > 0 && [[dictLike allValues] count] > 0) {
        return YES;
    }
    return NO;
}


/**
 获取有效的字典

 @param dictlike 校验的dictionary
 @return dictionary
 */
static inline NSDictionary* availableNSDictionay(id dictlike) {
    if (isValidNSDictionary(dictlike)) {
        return dictlike;
    }else{
        return [NSDictionary new];
    }
}

#pragma mark - NSNumber

/**
 校验NSNumber
 
 @param numberLike 需要进行校验的number，只要是NSNumber即可
 @return 是否是NSNumber
 */
static inline BOOL isValidNSNumber(id numberLike) {
    if (numberLike && [numberLike isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    return NO;
}

#endif /* CommentCommonValid_h */
