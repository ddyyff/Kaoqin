//
//  ViewController.h
//  FmdbTest
//
//  Created by Tang Qiao on 12-4-22.
//  Copyright (c) 2012年 blog.devtang.com All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMDBAction : NSObject
- (id) init;
- (void)createTable;
- (void)insertData:(NSString *) fingerprinttime alertTime: (NSString *) alertTime;
- (void)updateAlertflagById:(int) listid;
- (NSMutableArray *)queryData;
- (void)clearAll;
- (void)multithread;
@end
