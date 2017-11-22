//
//  LYSqliteTool.h
//  LYDB
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYSqliteTool : NSObject

/**
 *  执行Sql语句
 */
+ (BOOL)dealSQL:(NSString *)sql dbPath:(NSString *)dbPath;

/**
 *  查询Sql语句
 */
+ (NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql dbPath:(NSString *)dbPath;

@end
