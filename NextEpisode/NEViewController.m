//
//  NEViewController.m
//  NextEpisode
//
//  Created by Jay Baker on 28/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import "NEViewController.h"
#import "NETableViewCell.h"
#import "NEAddShowViewController.h"
#import "NEShowDatabase.h"
#import "NEShow.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "NSObject+stringByStrippingHTML.h"

@interface NEViewController ()

@end

@implementation NEViewController

@synthesize requestData;
@synthesize refreshControl;

- (NSMutableArray*)names
{
    if (_names == nil)
    {
        _names = [[NSMutableArray alloc] init];
    }
    
    return _names;
}

-(void) refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Fetching show dates..."];
    refreshControl = refresh;
    // update the shows
    [self updateShows];
}

- (void)updateShows
{
    for (NEShow *show in _names) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://epguides.com/common/exportToCSV.asp?rage=%@", show.showId]];
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setCompletionBlock:^{
            NSString *response = [request responseString];
            NSString *strippedHtml = [response stringByStrippingHTML];
            
            NSArray *lines = [strippedHtml componentsSeparatedByString:@"\n"];
            NSArray *data = [lines filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 20"]];
            
            for (NSString *row in data) {
                NSArray *showData = [row componentsSeparatedByString:@","];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd/MMM/yy"];
                NSDate *showDate = [formatter dateFromString:showData[4]];
                NSComparisonResult result = [[NSDate date] compare:showDate];
                if (result == NSOrderedAscending) {
                    NSString *seasonStr = showData[1];
                    int season = [showData[1] integerValue];
                    if (season <= 9) {
                        seasonStr = [NSString stringWithFormat:@"0%@", seasonStr];
                    }
                    
                    NSString *episodeStr = showData[2];
                    int episode = [showData[2] integerValue];
                    if (episode <= 9) {
                        episodeStr = [NSString stringWithFormat:@"0%@", episodeStr];
                    }
                    
                    [show setShowDate:[NSString stringWithFormat:@"S%@E%@ - %@ - %@", seasonStr, episodeStr, showData[4], showData[5]]];
                    [[NEShowDatabase database] update:show];
                    [self redraw];
                    break;
                }
            }
        }];
        [request setDelegate:self];
        [request startAsynchronous];
        [request setDidFinishSelector:@selector(updateShowsFinished:)];
    }
}

- (void)updateShowsFinished:(ASIHTTPRequest *) request
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refreshControl endRefreshing];
}

- (void)redraw
{
    self.names = nil;
    
    NSArray *shows = [NEShowDatabase database].shows;
    for (NEShow *show in shows) {
        [self.names addObject:show];
    }
    
    [_currentShows reloadData];
}

- (IBAction)startAddShowView:(id)sender
{
    NSLog(@"Add Show button pressed");
    NEAddShowViewController *addView = [[NEAddShowViewController alloc] initWithNibName:@"NEAddShowViewController" bundle:nil];
    [self presentViewController:addView animated:YES completion:nil];
}

- (void)showDeleted:(id)show
{
    NSUInteger index = [_names indexOfObject:show];
    [self.currentShows beginUpdates];
    [_names removeObject:show];
    [self.currentShows deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.currentShows endUpdates];
    
    // delete the show from the database
    [[NEShowDatabase database] delete:show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Setup the refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_currentShows addSubview:refresh];
    
    // Setup the table panning, delegate and data source
    [self.currentShows registerClass:[NETableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.currentShows setDelegate:self];
    [self.currentShows setDataSource:self];
    
    // redraw the table data
    [self redraw];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self redraw];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NETableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NETableViewCell *cell = [[NETableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NEShow *show = [self.names objectAtIndex:indexPath.row];
    cell.textLabel.text = show.showName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Next: %@", show.showDate];
    cell.delegate = self;
    cell.show = show;
    
    return cell;
}

@end