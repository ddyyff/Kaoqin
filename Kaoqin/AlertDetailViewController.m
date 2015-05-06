//
//  AlertDetailViewController.m
//  Kaoqin
//
//  Created by jstm on 15/4/14.
//  Copyright (c) 2015年 dongyf. All rights reserved.
//

#import "AlertDetailViewController.h"
#import "FMDBAction.h"

@interface AlertDetailViewController ()

@end

@implementation AlertDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", _fingerprintData);
    
    [_fingerprintDetail setText:[NSString stringWithFormat:@"%@\r\n%@", [_fingerprintData valueForKey:@"fingerprinttime"], [_fingerprintData valueForKey:@"alerttime"]]];
    
    if ([[_fingerprintData valueForKey:@"alertflag"] isEqualToString:@"1"]) {
        [(UIButton *)[self.view viewWithTag:3000] setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createAlert:(id)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil)
    {
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSDate* fireDate = [formater dateFromString:[_fingerprintData valueForKey:@"alerttime"]];
        
        int listid = [[_fingerprintData valueForKey:@"listid"] intValue];
        FMDBAction *fmdb = [[FMDBAction alloc] init];
        [fmdb updateAlertflagById:listid];
        
        notification.fireDate = fireDate;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = @"10 minutes to go home...";
        notification.soundName = @"ring.m4a"; //UILocalNotificationDefaultSoundName;
//        notification.applicationIconBadgeNumber = 1;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"10minutestogo" forKey:@"key"];
        notification.userInfo = userInfo;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        
    }
}
@end
