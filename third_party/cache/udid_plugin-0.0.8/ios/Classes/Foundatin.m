//
//  Foundatin.m
//  UDIDDemo
//
//  Created by 飞鱼 on 2019/1/3.
//  Copyright © 2019 ud.udcredit.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (chinese)

- (NSString *)descriptionWithLocale:(id)locale;

@end

@interface NSDictionary (chinese)

- (NSString *)descriptionWithLocale:(id)locale;

@end

@implementation NSArray (chinese)

- (NSString *)descriptionWithLocale:(id)locale
{
    
    
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"(\n"];
    
    for (id obj in self) {
        [strM appendFormat:@"\t\t%@,\n", obj];
    }
    [strM appendString:@")"];
    
    return strM;
}



@end


@implementation NSDictionary (chinese)

- (NSString *)descriptionWithLocale:(id)locale
{
    
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"{\n"];
    
    for (id obj in [self allKeys]) {
        [strM appendFormat:@"\t\t%@,", obj];
        
        [strM appendFormat:@"%@\n", self[obj]];
    }
    
    [strM appendString:@"}"];
    
    return strM;
}


@end
