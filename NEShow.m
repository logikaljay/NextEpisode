//
//  NEShow.m
//  NextEpisode
//
//  Created by Jay Baker on 28/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import "NEShow.h"

@implementation NEShow

@synthesize uniqueId = _uniqueId;
@synthesize showName = _showName;
@synthesize showId = _showId;
@synthesize showDate = _showDate;

- (id)initWithUniqueId:(int)uniqueId showName:(NSString *)showName showId:(NSString *)showId showDate:(NSString *)showDate {
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.showDate = showDate;
        self.showId = showId;
        self.showName = showName;
    }
    
    return self;
}

- (void) dealloc {
    self.showName = nil;
    self.showId = nil;
    self.showDate = nil;
}

@end
