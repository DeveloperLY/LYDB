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

@end
