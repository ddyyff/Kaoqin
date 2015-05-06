//
//  ViewController.m
//  Kaoqin
//
//  Created by jstm on 15/4/1.
//  Copyright (c) 2015年 dongyf. All rights reserved.
//

#import "ViewController.h"
#import "FMDBAction.h"
#import "TableViewCell.h"
#import "AlertDetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController
NSMutableArray *list;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FMDBAction *fmdb = [[FMDBAction alloc] init];
    [fmdb createTable];
    list = [fmdb queryData];
    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    if (notification != nil)
//    {
//        NSDate *now = [NSDate new];
//        notification.fireDate = [now dateByAddingTimeInterval:5];
//        notification.timeZone = [NSTimeZone defaultTimeZone];
//        notification.alertBody = @"测试1";
//        notification.soundName = @"ring.m4a";
////        notification.applicationIconBadgeNumber = 1;
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    }
//    NSString *a = [[NSBundle mainBundle] pathForResource:@"ring" ofType:@"m4a"];
//    NSLog(@"%@",a);

//    tableView = [[UITableView alloc] init];
//    [tableView setDelegate:self];
//    [tableView setDataSource:self];
//    [tableView setFrame:CGRectMake(0, 100, 0, 0)];
//    [self.view addSubview:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

//创建indexPath中指定单元实例
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
//    static NSString *identifier = @"CellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
////    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//    if (nil ==cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//        //[pCell release];
//    }
//
//    
//    //返回对应位置的数据，并设置到单元中
//    //NSArray*data=[self.dataSource allKeys];
//    //NSArray*ar=[self.dataSource objectForKey:key];
//    if ([[[list objectAtIndex:row] valueForKey:@"alertflag"] isEqualToString:@"1"]) {
//        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[list objectAtIndex:row] valueForKey:@"fingerprinttime"], @"已设置"];
////        cell.detailTextLabel.text = [NSString stringWithFormat:@"Alert at: %@", [[list objectAtIndex:row] valueForKey:@"alerttime"]];
//    } else {
//        cell.textLabel.text = [[list objectAtIndex:row] valueForKey:@"fingerprinttime"];
//    }
//    
//    // pCell.textLabel.text = [[_dataSource objectForKey:key] objectAtIndex:row];
    
    
    
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"TableViewCell";
    //自定义cell类
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    
    //返回对应位置的数据，并设置到单元中
    //NSArray*data=[self.dataSource allKeys];
    //NSArray*ar=[self.dataSource objectForKey:key];
    if ([[[list objectAtIndex:row] valueForKey:@"alertflag"] isEqualToString:@"1"]) {
        cell.label.text = [[list objectAtIndex:row] valueForKey:@"fingerprinttime"];
        cell.cellDetail.text = [NSString stringWithFormat:@"%@ %@", [[list objectAtIndex:row] valueForKey:@"alerttime"], @"已设置"];
    //       cell.detailTextLabel.text = [NSString stringWithFormat:@"Alert at: %@", [[list objectAtIndex:row] valueForKey:@"alerttime"]];
    } else {
        cell.label.text = [[list objectAtIndex:row] valueForKey:@"fingerprinttime"];
        cell.cellDetail.text = [[list objectAtIndex:row] valueForKey:@"alerttime"];
    }
    
    // pCell.textLabel.text = [[_dataSource objectForKey:key] objectAtIndex:row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *alertTime = [format3 stringFromDate:dateAlert];
    
    FMDBAction *fmdb = [[FMDBAction alloc] init];
    [fmdb insertData:[format3 stringFromDate:date1] alertTime: alertTime];
    list = [fmdb queryData];
    
    UITableView *t = (UITableView *)[self.view viewWithTag:1000];
    [t reloadData];
}

- (IBAction)refresh:(id)sender {
    FMDBAction *fmdb = [[FMDBAction alloc] init];
    list = [fmdb queryData];
    
    UITableView *t = (UITableView *)[self.view viewWithTag:1000];
    [t reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segueid" sender:[tableView cellForRowAtIndexPath:indexPath]];
    
//    NSInteger row = [indexPath row];

//    
//    AlertDetailViewController *alertDetail = [[AlertDetailViewController alloc] init];
//    [alertDetail setFingerprintData:[list objectAtIndex:row]];
//    
//    [self presentViewController:alertDetail animated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setFingerprintData:)]) {
//        UITableView *tableView = (UITableView *)[self.view viewWithTag:1000];
        UITableViewCell *cell = (UITableViewCell *) sender;
        UITableView *tableView = (UITableView *)[[cell superview] superview];
        
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
//        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        NSUInteger row = [indexPath row];
        [destination setValue:[list objectAtIndex:row] forKey:@"fingerprintData"];
    }
}
@end
