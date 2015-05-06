//
//  ViewController.m
//  FmdbTest
//
//  Created by Tang Qiao on 12-4-22.
//  Copyright (c) 2012年 blog.devtang.com All rights reserved.
//

#import "FMDBAction.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "MacroUtils.h"

@interface FMDBAction()

@property (nonatomic, retain) NSString * dbPath;

@end

@implementation FMDBAction
- (id) init {
//    NSString * doc = PATH_OF_DOCUMENT;
//    NSString * path = [doc stringByAppendingPathComponent:@"db.sqlite"];
//    self.dbPath = path;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.gfan"];
    NSURL *storeURL = [containerURL URLByAppendingPathComponent:@"db.sqlite"];
    self.dbPath = [storeURL path];
    
    return self;
}
#pragma mark - SQL Operations


- (void)createTable {
    debugMethod();
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString * sql = @"CREATE TABLE 'list' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'exif' VARCHAR(3000), 'fingerprinttime' Date, 'alerttime' Date, 'alertflag' INTEGER)";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                debugLog(@"error when creating db table");
            } else {
                debugLog(@"succ to creating db table");
            }
            [db close];
        } else {
            debugLog(@"error when open db");
        }
    }
}


- (void)insertData:(NSString *) fingerprinttime alertTime:(NSString *) alerttime{
    static int idx = 1;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"insert into list (name, exif, fingerprinttime, alerttime, alertflag) values(?, ?, ?, ?, ?) ";
        NSString *name = [NSString stringWithFormat:@"image%d.png", idx++];
        BOOL res = [db executeUpdate:sql, name, @"Apple iPhone 6", fingerprinttime, alerttime, 0];
        if (!res) {
            debugLog(@"error to insert data");
        } else {
            debugLog(@"succ to insert data");
        }
        [db close];
    }
}

- (void)updateAlertflagById:(int) listid{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
//        使用此方式update崩溃
//        NSString *sql = @"update list set alertflag=1 where id=1";
//        BOOL res = [db executeUpdate:sql, listid];
        NSString *sql = [NSString stringWithFormat:@"update list set alertflag=%d where id=%d", 1, listid];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error to update data");
        } else {
            debugLog(@"succ to update data");
        }
        [db close];
    }
}


- (NSMutableArray *)queryData {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    debugMethod();
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {

        NSString *sql = @"select * from list order by id desc";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            int listid = [rs intForColumn:@"id"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *exif = [rs stringForColumn:@"exif"];
            NSString *fingerprinttime = [rs stringForColumn:@"fingerprinttime"];
            NSString *alerttime = [rs stringForColumn:@"alerttime"];
            int alertflag = [rs intForColumn:@"alertflag"];
            debugLog(@"user id = %d, name = %@, exif = %@, fingerprinttime = %@, alerttime = %@, alertflag = %d", listid, name, exif, fingerprinttime, alerttime, alertflag);
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", listid], @"listid", [NSString stringWithFormat:@"%d", alertflag], @"alertflag", fingerprinttime, @"fingerprinttime", alerttime, @"alerttime", nil];
            [list addObject:temp];
        }
        [db close];
    }
    
    return list;
}

- (NSMutableArray *)queryDataById:(int) id {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    debugMethod();
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        
        NSString *sql = [NSString stringWithFormat:@"select top 1 * from list where id = %d order by id desc", id];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            int listid = [rs intForColumn:@"id"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *exif = [rs stringForColumn:@"exif"];
            NSString *fingerprinttime = [rs stringForColumn:@"fingerprinttime"];
            NSString *alerttime = [rs stringForColumn:@"alerttime"];
            int alertflag = [rs intForColumn:@"alertflag"];
            debugLog(@"user id = %d, name = %@, exif = %@, fingerprinttime = %@, alerttime = %@, alertflag = %@", listid, name, exif, fingerprinttime, alerttime, alertflag);
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", listid], @"listid", [NSString stringWithFormat:@"%d", alertflag], @"alertflag", fingerprinttime, @"fingerprinttime", alerttime, @"alerttime", nil];
            [list addObject:temp];
        }
        [db close];
    }
    
    return list;
}

- (void)clearAll {
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"delete from list";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error to delete db data");
        } else {
            debugLog(@"succ to deleta db data");
        }
        [db close];
    }
}

- (void)multithread {
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString * sql = @"insert into photos (name, exif) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"queue111 %d", i];
                BOOL res = [db executeUpdate:sql, name, @"Apple iPhone 6"];
                if (!res) {
                    debugLog(@"error to add db data: %@", name);
                } else {
                    debugLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });
    
    dispatch_async(q2, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString * sql = @"insert into photos (name, exif) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"queue222 %d", i];
                BOOL res = [db executeUpdate:sql, name, @"Apple iPhone 6"];
                if (!res) {
                    debugLog(@"error to add db data: %@", name);
                } else {
                    debugLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });
}

@end
