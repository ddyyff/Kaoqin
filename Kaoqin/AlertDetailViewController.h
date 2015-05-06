//
//  AlertDetailViewController.h
//  Kaoqin
//
//  Created by jstm on 15/4/14.
//  Copyright (c) 2015年 dongyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertDetailViewController : UIViewController
@property(retain, nonatomic) NSDictionary *fingerprintData;
@property (weak, nonatomic) IBOutlet UITextView *fingerprintDetail;
- (IBAction)createAlert:(id)sender;
@end
