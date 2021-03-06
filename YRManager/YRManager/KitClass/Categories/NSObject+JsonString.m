//
//  NSObject+JsonString.m
//  OCDemo
//
//  Created by xun on 16/6/15.
//  Copyright © 2016年 xun. All rights reserved.
//

#import "NSObject+JsonString.h"
#import <objc/runtime.h>
#import "NSObject+JSONToObject.h"

@implementation NSObject (JsonString)

- (NSString *)jsonString
{
    if ([self isKindOfClass:[NSArray class]])
    {
        return [self jsonStringFromArray:(id)self];
    }
    else if ([self isKindOfClass:[NSDictionary class]])
    {
        return [self jsonStringFromDictionary:(id)self];
    }
    else if([self isKindOfClass:[NSString class]])
    {
        return (NSString *)self;
    }
    else if ([self isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", self];
    }
    else if ([self isKindOfClass:[NSSet class]])
    {
        return [self jsonStringFromSet:(id)self];
    }
    else
    {
        return [self jsonStringFromModel:(id)self];
    }
}

#pragma mark 对象转JSON

- (NSString *)jsonStringFromDictionary:(NSDictionary *)dict
{
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    //
    //    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableString * jsonStr = [NSMutableString stringWithString:@"{"];
    
    for (NSString *key  in dict.allKeys)
    {
        NSMutableString *dictStr = [NSMutableString new];
        
        if ([dict[key] isKindOfClass:[NSNull class]])
        {
            continue;
        }
        else if ([dict[key] isKindOfClass:[NSDictionary class]])
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, [self jsonStringFromDictionary:dict[key]]];
        }
        else if([dict[key] isKindOfClass:[NSArray class]])
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, [self jsonStringFromArray:dict[key]]];
        }
        else if([dict[key] isKindOfClass:[NSSet class]])
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, [self jsonStringFromSet:dict[key]]];
        }
        else if ([dict[key] isKindOfClass:[NSString class]])
        {
            [dictStr appendFormat:@"\"%@\":\"%@\", ", key, dict[key]];
        }
        else if([dict[key] isKindOfClass:[NSNumber class]])
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, dict[key]];
        }
        else
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, [self jsonStringFromModel:dict[key]]];
        }
        
        [jsonStr appendString:dictStr.length?dictStr:@""];
    }
    
    NSRange range = [jsonStr rangeOfString:@"," options:NSBackwardsSearch];
    
    if (range.location != NSNotFound)
    {
        [jsonStr replaceCharactersInRange:range withString:@"}"];
    }
    else
    {
        [jsonStr appendString:@"}"];
    }
    
    return jsonStr;
}

- (NSString *)jsonStringFromArray:(NSArray *)array
{
    return [self jsonStringFromSet:(id)array];
}

- (NSString *)jsonStringFromSet:(NSSet *)set
{
    NSMutableString *str = [NSMutableString stringWithString:@"["];
    
    for (id obj in set)
    {
        
        NSString *tempStr = nil;
        
        if ([obj isKindOfClass:[NSNull class]])
        {
            continue;
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            tempStr = [NSString stringWithFormat:@"%@, ", [self jsonStringFromArray:obj]];
        }
        else if ([obj isKindOfClass:[NSDictionary class]])
        {
            tempStr = [NSString stringWithFormat:@"%@, ", [self jsonStringFromDictionary:obj]];
        }
        else if ([obj isKindOfClass:[NSSet class]])
        {
            tempStr = [NSString stringWithFormat:@"%@, ", [self jsonStringFromSet:obj]];
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            tempStr = [NSString stringWithFormat:@"\"%@\", ", obj];
        }
        else if ([obj isKindOfClass:[NSNumber class]])
        {
            tempStr = [NSString stringWithFormat:@"%@, ", obj];
        }
        else
        {
            tempStr = [NSString stringWithFormat:@"%@, ", [self jsonStringFromModel:obj]];
        }
        
        [str appendString:tempStr.length?tempStr:@""];
    }
    
    NSRange range = [str rangeOfString:@", " options:NSBackwardsSearch];
    
    [str replaceCharactersInRange:range withString:@"]"];
    
    return str;
}

- (NSString *)jsonStringFromModel:(id)model
{
    NSMutableString *str = [NSMutableString stringWithString:@"{"];
    
    for (NSString *property in [model propertyList])
    {
        NSString *keyValueStr = nil;
        
        id value = [model valueForKey:property];
        
        NSString *key = [[model class] getServerKeyFromProperty:property];
        
        if ([value isKindOfClass:[NSNull class]] || value == nil)
        {
            continue;
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            if ([value count] > 0)
            {
                keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, [self jsonStringFromArray:value]];
            }
        }
        else if ([value isKindOfClass:[NSDictionary class]])
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, [self jsonStringFromDictionary:value]];
        }
        else if ([value isKindOfClass:[NSSet class]])
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, [self jsonStringFromSet:value]];
        }
        else if ([value isKindOfClass:[NSString class]])
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":\"%@\", ", key, value];
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, value];
        }
        else
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, [self jsonStringFromModel:value]];
        }
        [str appendString:keyValueStr.length?keyValueStr:@""];
    }
    
    NSRange range = [str rangeOfString:@", " options:NSBackwardsSearch];
    
    if (range.location == NSNotFound)
    {
        [str appendString:@"}"];
    }
    else
    {
        [str replaceCharactersInRange:range withString:@"}"];
    }
    
    return str;
}

#pragma mark 获取对象属性列表

- (NSArray *)propertyList
{
    unsigned count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertyList = [NSMutableArray new];
    
    for (int i = 0; i < count; i++)
    {
        [propertyList addObject:[NSString stringWithUTF8String:property_getName(properties[i])]];
    }
    
    free(properties);
    
    return propertyList;
}

+ (NSString *)getServerKeyFromProperty:(NSString *)property
{
    NSDictionary *dict = [self replaceKeyDict];
    
    NSString *_property = nil;
    
    if ([dict.allValues containsObject:property])
    {
        for (NSString * key in dict.allKeys)
        {
            if ([[dict valueForKey:key] isEqualToString:property])
            {
                _property = key;
                break;
            }
        }
        return _property;
    }
    else
    {
        return property;
    }
}

@end
