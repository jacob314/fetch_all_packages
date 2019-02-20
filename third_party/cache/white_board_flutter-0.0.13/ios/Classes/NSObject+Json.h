//
//  NSObject+Json.h
//  MeetingGroup
//
//  Created by 陈凯 on 2017/4/10.
//  Copyright © 2017年 陈凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Json)

/**
 NSDictionary 转 JSON
 
 @param dict 字典
 @return 字符串
 */
+(NSString *)convertToJsonData:(id)dict;

/**
 json转对象
 
 @param jsonString json字符串
 @return 对象字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 json串转数组

 @param jsonStr json串
 @return 数组
 */
- (NSArray *)jsonStringToArray:(NSString *)jsonStr;

@end
