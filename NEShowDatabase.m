//
//  NEShowDatabase.m
//  NextEpisode
//
//  Created by Jay Baker on 28/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import "NEShowDatabase.h"
#import "NEShow.h"

@implementation NEShowDatabase

static NEShowDatabase *_database;

- (NSArray *)shows {
    NSMutableArray *retval =[[NSMutableArray alloc] init];
    NSString *query = @"SELECT uniqueId, showId, showName, showDate FROM shows ORDER BY showName";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *showIdChars = (char *) sqlite3_column_text(statement, 1);
            char *showNameChars = (char *) sqlite3_column_text(statement, 2);
            char *showDateChars = (char *) sqlite3_column_text(statement, 3);
            
            NSString *showId, *showName, *showDate;
            
            if (showIdChars != nil) {
                showId = [[NSString alloc] initWithUTF8String:showIdChars];
            }
            
            if (showNameChars != nil) {
                showName = [[NSString alloc] initWithUTF8String:showNameChars];
            }
            
            if (showDateChars != nil) {
                showDate = [[NSString alloc] initWithUTF8String:showDateChars];
            }
            
            NEShow *show = [[NEShow alloc] initWithUniqueId:uniqueId
                                                   showName:showName
                                                     showId:showId
                                                   showDate:showDate];
            [retval addObject:show];
        }
        
        sqlite3_finalize(statement);
    }
    
    return retval;
}

- (void)add:(NEShow *)show {
    if (show != nil) {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO shows (showId, showName) VALUES ('%@', '%@')", show.showId, show.showName];
        char *error;
        
        if (sqlite3_exec(_database, [query UTF8String], nil, nil, &error) != SQLITE_OK) {
            NSLog(@"Error adding show: %s", error);
        } else {
            NSLog(@"Adding show: %@ %@", show.showId, show.showName);
        }
    }
}

- (void)delete:(NEShow *)show {
    if (show != nil) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM shows WHERE showId = '%@'", show.showId];
        char *error;
        
        if (sqlite3_exec(_database, [query UTF8String], nil, nil, &error) != SQLITE_OK) {
            NSLog(@"Error deleteing show: %s", error);
        }
    }
}

- (void)update:(NEShow *)show {
    if (show != nil) {
        NSString *query = [NSString stringWithFormat:@"UPDATE shows SET showId = '%@', showName = '%@', showDate = '%@' WHERE uniqueId = '%d'",
                           show.showId, show.showName, show.showDate, show.uniqueId];
        char* error;
        
        if (sqlite3_exec(_database, [query UTF8String], nil, nil, &error) != SQLITE_OK) {
            NSLog(@"Error updating show: %s", error);
        }
    }
}

+ (NEShowDatabase*)database {
    if (_database == nil) {
        _database = [[NEShowDatabase alloc] init];
    }
    
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"showlist" ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    
    return self;
}

- (void)dealloc {
    sqlite3_close(_database);
}

@end
