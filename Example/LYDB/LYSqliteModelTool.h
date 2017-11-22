//
//  LYSqliteModelTool.h
//  LYDB
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYModelProtocol.h"

@interface LYSqliteModelTool : NSObject

/**
 * 根据类名创建表
 */
+ (BOOL)createTable:(Class)cls dbPath:(NSString *)dbPath;

/**
 * 否需要跟新数据库表结构
 */
+ (BOOL)isTableRequiredUpdate:(Class)cls dbPath:(NSString *)dbPath;

/**
 * 动态更新表结构
 */
+ (BOOL)updateTable:(Class)cls dbPath:(NSString *)dbPath;


/**
 * 保存或更新模型
 */
+ (BOOL)saveOrUpdateModel:(id)model dbPath:(NSString *)dbPath;

/**
 * 删除模型
 */
+ (BOOL)deleteModel:(id)model dbPath:(NSString *)dbPath;

/** 根据条件来删除
 * eg:
 * age > 19
 * score <= 10
 */
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr dbPath:(NSString *)dbPath;

@end
