//
//  LYModelProtocol.h
//  LYDB
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#ifndef LYModelProtocol_h
#define LYModelProtocol_h

#import <Foundation/Foundation.h>

@protocol LYModelProtocol <NSObject>

@required
/**
 操作模型必须实现的方法获取主键信息
 
 @return 主键字符串
 */
+ (NSString *)primaryKey;

@optional

/**
忽略的字段数组

@return 忽略的字段数组
*/
+ (NSArray *)ignoreColumnNames;

/**
 新字段名称-> 旧的字段名称的映射表
 
 @return 映射表格
 */
+ (NSDictionary *)newOldPropertyMapper;

@end

#endif /* LYModelProtocol_h */
