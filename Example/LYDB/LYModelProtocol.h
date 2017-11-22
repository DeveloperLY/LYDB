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
+ (NSString *)primaryKey;

@optional
+ (NSArray *)ignoreColumnNames;

@end

#endif /* LYModelProtocol_h */
