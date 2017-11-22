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

@end
