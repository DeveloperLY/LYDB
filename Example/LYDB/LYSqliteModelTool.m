//
//  LYSqliteModelTool.m
//  LYDB
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYSqliteModelTool.h"
#import "LYModelTool.h"
#import "LYSqliteTool.h"
#import "LYTableTool.h"

@implementation LYSqliteModelTool

+ (BOOL)createTable:(Class)cls dbPath:(NSString *)dbPath {
    // 获取表名
    NSString *tableName = [LYModelTool tableName:cls];
    
    // 判断是否配置主键
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"LYDBException" reason:@"如果需要操作这个模型，必须先实现协议方法+ (NSString *)primaryKey, 配置主键信息。" userInfo:nil];
        [excp raise];
    }
    
    NSString *primaryKey = [cls primaryKey];
    
    // 拼接Sql语句
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [LYModelTool columnNamesAndTypesStr:cls], primaryKey];
    
    // 执行语句
    return [LYSqliteTool dealSQL:createTableSql dbPath:dbPath];
}

+ (BOOL)isTableRequiredUpdate:(Class)cls dbPath:(NSString *)dbPath {
    NSArray *modelNames = [LYModelTool allTableSortedIvarNames:cls];
    NSArray *tableNames = [LYTableTool tableSortedColumnNames:cls dbPath:dbPath];
    return ![modelNames isEqualToArray:tableNames];
}

+ (BOOL)updateTable:(Class)cls dbPath:(NSString *)dbPath {
    // 临时表名
    NSString *tmpTableName = [LYModelTool tmpTableName:cls];
    
    // 表名
    NSString *tableName = [LYModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"LYDBException" reason:@"如果需要操作这个模型，必须先实现协议方法+ (NSString *)primaryKey, 配置主键信息。" userInfo:nil];
        [excp raise];
    }
    
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls primaryKey];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, [LYModelTool columnNamesAndTypesStr:cls], primaryKey];
    [execSqls addObject:createTableSql];
    
    // 根据主键, 插入数据
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [execSqls addObject:insertPrimaryKeyData];
    
    // 根据主键将所有的数据更新到新表里面
    NSArray *oldNames = [LYTableTool tableSortedColumnNames:cls dbPath:dbPath];
    NSArray *newNames = [LYModelTool allTableSortedIvarNames:cls];
    
    for (NSString *columnName in newNames) {
        if (![oldNames containsObject:columnName]) {
            continue;
        }
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tmpTableName, columnName, columnName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSqls addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [execSqls addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, tableName];
    [execSqls addObject:renameTableName];
    
    return [LYSqliteTool dealSQLs:execSqls dbPath:dbPath];
}

@end
