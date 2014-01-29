//
//  NEViewController.h
//  NextEpisode
//
//  Created by Jay Baker on 28/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NETableViewCellDelegate.h"

@interface NEViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, NETableViewCellDelegate> {
    NSString *requestData;
}

@property (weak, nonatomic) IBOutlet UITableView *currentShows;
@property (strong, nonatomic) NSMutableArray *names;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain) NSString *requestData;
@end
