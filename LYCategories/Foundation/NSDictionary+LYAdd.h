//
//  NSDictionary+LYAdd.h
//  LYCategories
//
//  Created by Liu Y on 16/4/3.
//  Copyright © 2016年 DeveloperLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (LYAdd)

#pragma mark - 安全操作
///=============================================================================
/// @name safeAccess
///=============================================================================

/**
 *  判断字典对于给定Key是否有内容
 *
 *  @param key 给定的Key
 *
 *  @return YES 存在 NO 不存在
 */
- (BOOL)hasKey:(NSString *)key;

/**
 *  获取字符串
 *
 *  @param key 给定的key
 *
 *  @return 获得的字符串
 */
- (NSString *)stringForKey:(id)key;

/**
 *  获取number
 *
 *  @param key 给定的key
 *
 *  @return 获得的number
 */
- (NSNumber *)numberForKey:(id)key;

/**
 *  获取array
 *
 *  @param key 给定的key
 *
 *  @return 获得的array
 */
- (NSArray *)arrayForKey:(id)key;

/**
 *  获取dictionary
 *
 *  @param key 给定的key
 *
 *  @return 获得的dictionary
 */
- (NSDictionary *)dictionaryForKey:(id)key;

/**
 *  获取initeger
 *
 *  @param key 给定的key
 *
 *  @return 获得的integer
 */
- (NSInteger)integerForKey:(id)key;

/**
 *  获取unsignedInteger
 *
 *  @param key 给定的key
 *
 *  @return 获得的unsignedInteger
 */
- (NSUInteger)unsignedIntegerForKey:(id)key;

/**
 *  获取bool
 *
 *  @param key 给定的key
 *
 *  @return 获得的bool
 */
- (BOOL)boolForKey:(id)key;

/**
 *  获取int16
 *
 *  @param key 给定的key
 *
 *  @return 获得的int16
 */
- (int16_t)int16ForKey:(id)key;

/**
 *  获取int32
 *
 *  @param key 给定的key
 *
 *  @return 获得的int32
 */
- (int32_t)int32ForKey:(id)key;

/**
 *  获取int64
 *
 *  @param key 给定的key
 *
 *  @return 获得的int64
 */
- (int64_t)int64ForKey:(id)key;

/**
 *  获取char
 *
 *  @param key 给定的key
 *
 *  @return 获得的char
 */
- (char)charForKey:(id)key;

/**
 *  获取short
 *
 *  @param key 给定的key
 *
 *  @return 获得的short
 */
- (short)shortForKey:(id)key;

/**
 *  获取float
 *
 *  @param key 给定的key
 *
 *  @return 获得的float
 */
- (float)floatForKey:(id)key;

/**
 *  获取double
 *
 *  @param key 给定的key
 *
 *  @return 获得的double
 */
- (double)doubleForKey:(id)key;

/**
 *  获取longLong
 *
 *  @param key 给定的key
 *
 *  @return 获得的longLong
 */
- (long long)longLongForKey:(id)key;

/**
 *  获取unsignedLongLong
 *
 *  @param key 给定的key
 *
 *  @return 获得的unsignedLongLong
 */
- (unsigned long long)unsignedLongLongForKey:(id)key;

/**
 *  获取CGFloat
 *
 *  @param key 给定的key
 *
 *  @return 获得的CGFloat
 */
- (CGFloat)CGFloatForKey:(id)key;

/**
 *  获取point
 *
 *  @param key 给定的key
 *
 *  @return 获得的point
 */
- (CGPoint)pointForKey:(id)key;

/**
 *  获取size
 *
 *  @param key 给定的key
 *
 *  @return 获得的size
 */
- (CGSize)sizeForKey:(id)key;

/**
 *  获取rect
 *
 *  @param key 给定的key
 *
 *  @return 获得的rect
 */
- (CGRect)rectForKey:(id)key;

#pragma mark - 合并
///=============================================================================
/// @name 合并
///=============================================================================

/**
 *  合并两个字典
 *
 *  @param dict1 第一个字典
 *  @param dict2 第二个字典
 *
 *  @return 合并之后得到的字典
 */
+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;

/**
 *  与另一个字典合并
 *
 *  @param dict 将要合并过来的字典
 *
 *  @return 合并后的字典
 */
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict;

#pragma mark - JSON
///=============================================================================
/// @name JSON
///=============================================================================
- (NSString *)JSONString;

#pragma mark - URL
///=============================================================================
/// @name URL
///=============================================================================
/**
 *  @brief  将url参数转换成NSDictionary
 *
 *  @param query url参数
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)ly_dictionaryWithURLQuery:(NSString *)query;

/**
 *  @brief  将NSDictionary转换成url 参数字符串
 *
 *  @return url 参数字符串
 */
- (NSString *)ly_URLQueryString;

#pragma mark - XML
///=============================================================================
/// @name XML
///=============================================================================
/**
 *  @brief  将NSDictionary转换成XML字符串 不带XML声明 不带根节点
 *
 *  @return XML 字符串
 */
- (NSString *)ly_XMLString;
/**
 *  @brief  将NSDictionary转换成XML字符串, 默认 <?xml version=\"1.0\" encoding=\"utf-8\"?> 声明   自定义根节点
 *
 *  @param rootElement 根节点
 *
 *  @return XML 字符串
 */
- (NSString *)ly_XMLStringDefaultDeclarationWithRootElement:(NSString*)rootElement;
/**
 *  @brief  将NSDictionary转换成XML字符串, 自定义根节点  自定义xml声明
 *
 *  @param rootElement 根节点
 *
 *  @param declaration xml声明
 *
 *  @return 标准合法 XML 字符串
 */
- (NSString *)ly_XMLStringWithRootElement:(NSString*)rootElement declaration:(NSString*)declaration;
/**
 *  @brief  将NSDictionary转换成Plist字符串
 *
 *  @return Plist 字符串
 */
- (NSString *)ly_plistString;
/**
 *  @brief  将NSDictionary转换成Plist data
 *
 *  @return Plist data
 */
- (NSData *)ly_plistData;


@end
