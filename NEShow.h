//
//  NEShow.h
//  NextEpisode
//
//  Created by Jay Baker on 28/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEShow : NSObject {
    int _uniqueId;
    NSString *_showName;
    NSString *_showId;
    NSString *_showDate;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *showName;
@property (nonatomic, copy) NSString *showId;
@property (nonatomic, copy) NSString *showDate;

- (id)initWithUniqueId:(int)uniqueId showName:(NSString *)showName showId:(NSString *)showId showDate:(NSString *)showDate;

@end
