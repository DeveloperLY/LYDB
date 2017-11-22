//
//  LYTableTool.m
//  LYDB
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYTableTool.h"
#import "LYModelTool.h"
#import "LYSqliteTool.h"

@implementation LYTableTool

+ (NSArray *)tableSortedColumnNames:(Class)cls dbPath:(NSString *)dbPath {
    NSString *tableName = [LYModelTool tableName:cls];
    
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    NSMutableDictionary *mDict = [LYSqliteTool querySql:queryCreateSqlStr dbPath:dbPath].firstObject;
    
    NSString *createTableSql = mDict[@"sql"];
    if (createTableSql.length == 0) {
        return nil;
    }
    // 去除多余的字符
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"("][1];
    
    NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    
    NSMutableArray *names = [NSMutableArray array];
    for (NSString *nameType in nameTypeArray) {
        if ([nameType containsString:@"primary"]) {
            continue;
        }
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        
        [names addObject:name];
    }
    
    [names sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    return names;
}

@end
