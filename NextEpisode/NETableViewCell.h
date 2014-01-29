//
//  NETableViewCell.h
//  NextEpisode
//
//  Created by Jay Baker on 29/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEShow.h"
#import "NETableViewCellDelegate.h"

@interface NETableViewCell : UITableViewCell
@property (nonatomic) NEShow *show;
@property (nonatomic, assign) id<NETableViewCellDelegate> delegate;
@end
