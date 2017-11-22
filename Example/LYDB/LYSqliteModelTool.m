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
    
    // 获取新旧字段映射关系
    NSDictionary *newOldPropertyMapper = @{};
    if ([cls respondsToSelector:@selector(newOldPropertyMapper)]) {
        newOldPropertyMapper = [cls newOldPropertyMapper];
    }
    
    for (NSString *columnName in newNames) {
        NSString *oldName = columnName;
        // 获取新字段映射的旧字段名
        if ([newOldPropertyMapper[columnName] length] != 0) {
            oldName = newOldPropertyMapper[columnName];
        }
        
        if ((![oldNames containsObject:columnName] && ![oldNames containsObject:oldName]) || [columnName isEqualToString:primaryKey]) {
            continue;
        }
        
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tmpTableName, columnName, oldName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSqls addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [execSqls addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, tableName];
    [execSqls addObject:renameTableName];
    
    return [LYSqliteTool dealSQLs:execSqls dbPath:dbPath];
}

+ (BOOL)saveOrUpdateModel:(id)model dbPath:(NSString *)dbPath {
    Class cls = [model class];
    
    // 判断表表是否存在
    if (![LYTableTool isTableExists:cls dbPath:dbPath]) {
        [self createTable:cls dbPath:dbPath];
    }
    
    // 检查表结构是否需要更新
    if ([self isTableRequiredUpdate:cls dbPath:dbPath]) {
        [self updateTable:cls dbPath:dbPath];
    }
    
    // 表名
    NSString *tableName = [LYModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"LYDBException" reason:@"如果需要操作这个模型，必须先实现协议方法+ (NSString *)primaryKey, 配置主键信息。" userInfo:nil];
        [excp raise];
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *result = [LYSqliteTool querySql:checkSql dbPath:dbPath];
    
    // 获取字段数组
    NSArray *columnNames = [LYModelTool classIvarNameTypeDic:cls].allKeys;
    
    // 获取字段值数组
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        id value = [model valueForKeyPath:columnName];
        [values addObject:value];
    }
    
    // 拼接字段
    NSMutableArray *setValueArray = [NSMutableArray array];
    NSInteger count = columnNames.count;
    for (int i = 0; i < count; i++) {
        NSString *name = columnNames[i];
        id value = values[i];
        NSString *setStr = [NSString stringWithFormat:@"%@ ='%@'", name, value];
        [setValueArray addObject:setStr];
    }
    
    // 拼接对应的SQL语句
    NSString *execSql = @"";
    if (result.count > 0) {
        execSql = [NSString stringWithFormat:@"update %@ set %@  where %@ = '%@'", tableName, [setValueArray componentsJoinedByString:@","], primaryKey, primaryValue];
    } else {
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')", tableName, [columnNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
    }
    
    // 执行SQL语句
    return [LYSqliteTool dealSQL:execSql dbPath:dbPath];
}

@end
