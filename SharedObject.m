//
//  SharedObject.m
//  Kaoqin
//
//  Created by jstm on 15/4/15.
//  Copyright (c) 2015年 dongyf. All rights reserved.
//

#import "SharedObject.h"

@implementation SharedObject
//+ (SharedStoreObserver *)LocalNotificationInstance {
//    static SharedObject *sharedObjectInstance = nil;
//    static dispatch_once_t predicate;
//    
//    dispatch_once(&predicate, ^{
//        sharedObjectInstance = [[SharedObject alloc] init];
//        
//        [sharedObjectInstance createLocalNotification];
//    });
//    
//    
//    
//    return sharedObjectInstance;
//}
//
//-(void)createLocalNotification
//{
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    if (notification != nil)
//    {
//        NSDate *now = [NSDate new];
//        notification.fireDate = [now dateByAddingTimeInterval:10];
//        notification.timeZone = [NSTimeZone defaultTimeZone];
//        notification.alertBody = @"测试";
//        notification.soundName = UILocalNotificationDefaultSoundName;
//        notification.applicationIconBadgeNumber = 1;
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    }
//}
@end
