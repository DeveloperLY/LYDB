//
//  LYTableTool.h
//  LYDB_Example
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTableTool : NSObject

/**
 * 现有表的所有字段
 */
+ (NSArray *)tableSortedColumnNames:(Class)cls dbPath:(NSString *)dbPath;

@end
