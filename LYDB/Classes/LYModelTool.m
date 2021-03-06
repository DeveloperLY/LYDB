//
//  LYModelTool.m
//  LYDB
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYModelTool.h"
#import <objc/message.h>
#import "LYModelProtocol.h"

@implementation LYModelTool

+ (NSString *)tableName:(Class)cls {
    return NSStringFromClass(cls);
}

+ (NSString *)tmpTableName:(Class)cls {
    return [NSStringFromClass(cls) stringByAppendingString:@"_tmp"];
}

+ (NSDictionary *)classIvarNameTypeDic:(Class)cls {
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList(cls, &outCount);
    
    // 忽略字段
    NSArray *ignoreNames = nil;
    if ([cls respondsToSelector:@selector(ignoreColumnNames)]) {
        ignoreNames = [cls ignoreColumnNames];
    }
    
    NSMutableDictionary *nameTypeDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = varList[i];
        
        // 成员变量名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        if ([ignoreNames containsObject:ivarName]) {
            continue;
        }
        
        // 成员变量类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        [nameTypeDict setValue:type forKey:ivarName];
    }
    return nameTypeDict;
}

+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls {
    NSMutableDictionary *dict = [[self classIvarNameTypeDic:cls] mutableCopy];
    
    NSDictionary *typeMapDict = [self ocTypeToSqliteTypeDic];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        dict[key] = typeMapDict[obj];
    }];
    
    return dict;
}

+ (NSString *)columnNamesAndTypesStr:(Class)cls {
    NSDictionary *nameTypeDict = [self classIvarNameSqliteTypeDic:cls];
    
    NSMutableArray *result = [NSMutableArray array];
    [nameTypeDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        [result addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
    }];
    
    return [result componentsJoinedByString:@","];
}

+ (NSArray *)allTableSortedIvarNames:(Class)cls {
    NSDictionary *dict = [self classIvarNameTypeDic:cls];
    NSArray *keys = dict.allKeys;
    
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return keys;
}

#pragma mark - Private Method
+ (NSDictionary *)ocTypeToSqliteTypeDic {
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
    
}


@end
