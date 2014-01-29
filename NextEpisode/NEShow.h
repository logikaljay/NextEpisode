//
//  NEShow.h
//  NextEpisode
//
//  Created by Jay Baker on 28/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEShow : NSObject

@property (copy) NSString *docPath;
@property (weak, nonatomic) NSString *showName;
@property (nonatomic) NSInteger showId;
@property (weak, nonatomic) NSDate *showDate;

@end
