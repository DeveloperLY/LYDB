//
//  LYStudent.h
//  LYDB_Example
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYModelProtocol.h"

@interface LYStudent : NSObject <LYModelProtocol>

@property (nonatomic, assign) NSUInteger stuNum;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, copy) NSString *address;

@end
