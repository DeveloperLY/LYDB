//
//  LYViewController.m
//  LYDB
//
//  Created by DeveloperLY on 11/22/2017.
//  Copyright (c) 2017 DeveloperLY. All rights reserved.
//

#import "LYViewController.h"
#import "LYSqliteTool.h"
#import "LYSqliteModelTool.h"
#import "LYStudent.h"

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@interface LYViewController ()

@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"dbPath = %@", kCachePath);
    
    NSString *dbName = [NSString stringWithFormat:@"%@/%@", kCachePath, @"test.sqlite"];
    
    [self saveOrUpdateModel:dbName];
    
    NSArray *result = [LYSqliteModelTool queryAllModels:[LYStudent class] dbPath:dbName];
    
    NSLog(@"result == %@", result);
}

- (void)saveOrUpdateModel:(NSString *)dbName {
    LYStudent *stu = [[LYStudent alloc] init];
    stu.stuNum = 3;
    stu.name = @"李四3";
    stu.age = 3;
    stu.score = 733.5;
    stu.mArray = [@[@"dd", @"ddd"] mutableCopy];
    stu.dict = @{@"a" : @"b"};
    
    
    BOOL result = [LYSqliteModelTool saveOrUpdateModel:stu dbPath:dbName];
    
//    BOOL result = [LYSqliteModelTool deleteModel:stu dbPath:dbName];
    
    NSLog(@"result == %zd", result);
}

- (void)dynamicUpdateTable:(NSString *)dbName {
    BOOL result = [LYSqliteModelTool createTable:[LYStudent class] dbPath:dbName];
    
    NSLog(@"result == %zd", result);
}

- (void)dynamicCreateTable:(NSString *)dbName {
    BOOL result = [LYSqliteModelTool createTable:[LYStudent class] dbPath:dbName];
    
    NSLog(@"result == %zd", result);
}

- (void)testQuery {
    NSString *sql = @"select * from t_stu";
    
    NSMutableArray *result = [LYSqliteTool querySql:sql dbPath:[NSString stringWithFormat:@"%@/%@", kCachePath, @"test.db"]];
    
    NSLog(@"result == %@", result);
}

- (void)createTable {
    NSLog(@"dbPath = %@", kCachePath);
    
    NSString *sql = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real)";
    
    
    // 测试创建数据库
    BOOL result = [LYSqliteTool dealSQL:sql dbPath:[NSString stringWithFormat:@"%@/%@", kCachePath, @"test.db"]];
    
    NSLog(@"result == %zd", result);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
