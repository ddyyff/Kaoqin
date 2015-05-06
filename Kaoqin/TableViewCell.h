//
//  TableViewCell.h
//  Kaoqin
//
//  Created by jstm on 15/4/27.
//  Copyright (c) 2015年 dongyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *cellDetail;

@end
