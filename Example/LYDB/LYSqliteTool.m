//
//  LYSqliteTool.m
//  LYDB
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYSqliteTool.h"
#import <sqlite3.h>

@implementation LYSqliteTool

sqlite3 *ppDb = nil;

+ (BOOL)dealSQL:(NSString *)sql dbPath:(NSString *)dbPath {
    // 打开数据库
    if (![self openDB:dbPath]) {
        return NO;
    }
    
    // 执行处理Sql语句
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    // 关闭数据库
    [self closeDB];
    
    return result;
}

+ (NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql dbPath:(NSString *)dbPath {
    // 打开数据库
    [self openDB:dbPath];
    
    // 创建预处理语句
    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        return nil;
    }
    
    // 绑定数据
    NSMutableArray *rowDictArray = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        
        NSMutableDictionary *rowDict = [NSMutableDictionary dictionary];
        for (int i = 0; i < columnCount; i++) {
            // 列名
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            
            // 列的类型
            int type = sqlite3_column_type(ppStmt, i);
            // 根据列的类型获取列值
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE3_TEXT:
                    value = [NSString stringWithUTF8String: (const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                    
                default:
                    break;
            }
            [rowDict setValue:value forKey:columnName];
        }
        [rowDictArray addObject:rowDict];
    }
    
    // 释放资源
    sqlite3_finalize(ppStmt);
    
    [self closeDB];
    
    return rowDictArray;
}

#pragma mark - Private Method
+ (BOOL)openDB:(NSString *)dbPath {
    if (dbPath == nil) {
        return NO;
    }
    
    // 创建&打开数据库
    return sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
}

+ (void)closeDB {
    sqlite3_close(ppDb);
}

@end
