//
//  TodayViewController.h
//  Fingerprint
//
//  Created by jstm on 15/4/1.
//  Copyright (c) 2015年 dongyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (IBAction)fingerTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *touchList;
- (IBAction)addAlert:(id)sender;
- (void) addFingerTime;
@end
