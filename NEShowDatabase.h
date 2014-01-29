//
//  NEShowDatabase.h
//  NextEpisode
//
//  Created by Jay Baker on 28/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface NEShowDatabase : NSObject {
    sqlite3 *_database;
}

+ (NEShowDatabase *)database;
- (NSArray *)shows;
- (void)add:(NSObject*)show;
- (void)delete:(NSObject*)show;
- (void)update:(NSObject*)show;

@end
