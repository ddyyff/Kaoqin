//
//  ViewController.h
//  Kaoqin
//
//  Created by jstm on 15/4/1.
//  Copyright (c) 2015年 dongyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (IBAction)fingerTouch:(id)sender;
- (IBAction)refresh:(id)sender;
- (void) addFingerTime;
@end

