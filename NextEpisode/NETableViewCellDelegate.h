//
//  NETableViewCellDelegate.h
//  NextEpisode
//
//  Created by Jay Baker on 29/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEShow.h"

@protocol NETableViewCellDelegate <NSObject>
- (void) showDeleted:(NEShow *)show;
@end
