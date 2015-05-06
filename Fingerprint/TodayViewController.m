//
//  TodayViewController.m
//  Fingerprint
//
//  Created by jstm on 15/4/1.
//  Copyright (c) 2015年 dongyf. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "FMDBAction.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController
NSMutableArray *list;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    FMDBAction *fmdb = [[FMDBAction alloc] init];
    list = [fmdb queryData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

//创建indexPath中指定单元实例
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    static NSString *identifier = @"TodayCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil ==cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        //[pCell release];
    }
    
    //返回对应位置的数据，并设置到单元中
    //NSArray*data=[self.dataSource allKeys];
    //NSArray*ar=[self.dataSource objectForKey:key];
    cell.textLabel.text = [[list objectAtIndex:row] valueForKey:@"fingerprinttime"];
    cell.textLabel.textColor = [UIColor whiteColor];
    // pCell.textLabel.text = [[_dataSource objectForKey:key] objectAtIndex:row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.bottom = 10.0;
    return margins;
}
- (IBAction)fingerTouch:(id)sender {
    [self addFingerTime];
}

- (void) addFingerTime{
    NSDate *date1 = [NSDate date];
    NSTimeInterval alertInterval = (8 * 60 * 60) + (50 * 60.0);
    NSDate *dateAlert = [date1 dateByAddingTimeInterval:alertInterval];
    //直接输出当前时间date1时又时区错误。而用格式化后就正常了
    NSDateFormatter *format3 = [[NSDateFormatter alloc]init];
    [format3 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    //以下语句可以省略，如果把GTM变成UTC的话，就会存在时差问题，到底是哪一种，届时根据实际情况修改
    [format3 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GTM"]];
    NSLog(@"%@", [format3 stringFromDate:date1]);
    //    [_touchList setText:[NSString stringWithFormat:@"%@", [format3 stringFromDate:date1]]];
    
    NSString *alertTime = [format3 stringFromDate:dateAlert];
    
    FMDBAction *fmdb = [[FMDBAction alloc] init];
    [fmdb insertData:[format3 stringFromDate:date1] alertTime: alertTime];
    list = [fmdb queryData];
    
    
    UITableView *t = (UITableView *)[self.view viewWithTag:2000];
    [t reloadData];
}

- (IBAction)addAlert:(id)sender {
}
@end
