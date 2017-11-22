//
//  LYModelTool.h
//  LYDB
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYModelTool : NSObject

/**
 * 根据类获取表名称
 */
+ (NSString *)tableName:(Class)cls;

/**
 * 根据类获取临时表名称
 */
+ (NSString *)tmpTableName:(Class)cls;

/**
 * 获取所有的成员变量, 以及成员变量对应的类型
 */
+ (NSDictionary *)classIvarNameTypeDic:(Class)cls;

/**
 * 获取所有的成员变量, 以及成员变量映射到数据库里对应的类型
 */
+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls;

/**
 * 列名和类型字符串
 */
+ (NSString *)columnNamesAndTypesStr:(Class)cls;

/**
 * 所有需要映射到表的字段
 */
+ (NSArray *)allTableSortedIvarNames:(Class)cls;

@end
