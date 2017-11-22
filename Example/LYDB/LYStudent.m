//
//  LYStudent.m
//  LYDB_Example
//
//  Created by LiuY on 2017/11/22.
//  Copyright © 2017年 DeveloperLY. All rights reserved.
//

#import "LYStudent.h"

@implementation LYStudent

+ (NSString *)primaryKey {
    return @"stuNum";
}

+ (NSArray *)ignoreColumnNames {
    return @[@"score"];
}

+ (NSDictionary *)newOldPropertyMapper {
    return @{@"age" : @"age2"};
}

@end
