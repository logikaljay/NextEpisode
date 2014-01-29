//
//  NESearchShowViewController.m
//  NextEpisode
//
//  Created by Jay Baker on 29/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import "NESearchShowViewController.h"
#import "NEShow.h"
#import "NEShowDatabase.h"
#import "NEGetShowsList.h"

@implementation NESearchShowViewController

@synthesize tableData;
@synthesize resultsView;
@synthesize searchBar;
@synthesize disableViewOverlay;

- (NSMutableArray *)shows
{
    if (_shows == nil) {
        _shows = [[NSMutableArray alloc] init];
    }
    
    return _shows;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)uiSearchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    self.resultsView.allowsSelection = NO;
    self.resultsView.scrollEnabled = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)uiSearchBar
{
    // build our search URL
    NSString *url = [NSString stringWithFormat:@"http://services.tvrage.com/feeds/search.php?show=%@", uiSearchBar.text];
    
    // filter people by match
    NSMutableArray *results = [[[NEGetShowsList alloc] init] parseXMLFileAtURL:[NSURL URLWithString:url]];
    
    // iterate over articles creating temp shows for each one
    for (NSMutableDictionary *result in results) {
        NEShow *show = [[NEShow alloc] init];
        show.showId = [[result objectForKey:@"showid"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        show.showName = [[result objectForKey:@"name"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [self.shows addObject:show];
    }
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.resultsView.allowsSelection = YES;
    self.resultsView.scrollEnabled = YES;
	
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:_shows];
    [self.resultsView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)uiSearchBar
{
    uiSearchBar.text=@"";
    
    [uiSearchBar setShowsCancelButton:NO animated:YES];
    [uiSearchBar resignFirstResponder];
    self.resultsView.allowsSelection = YES;
    self.resultsView.scrollEnabled = YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"SearchResult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:MyIdentifier];
    }
	
    NEShow *show = [self.shows objectAtIndex:indexPath.row];
    cell.textLabel.text = show.showName;
    cell.detailTextLabel.text = show.showId;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // add the show to the database
    NEShow *show = [self.shows objectAtIndex:indexPath.row];
    [[NEShowDatabase database] add:show];
    
    // close search screen
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [searchBar setDelegate:self];
    [resultsView setDelegate:self];
    [resultsView setDataSource:self];
    
    // setup the navigation bar
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Find Show"];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:@selector(backToList:)];
    [item setLeftBarButtonItem:back];
    [self.navBar pushNavigationItem:item animated:YES];
    
    self.tableData =[[NSMutableArray alloc]init];
    self.disableViewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f,44.0f,320.0f,416.0f)];
    self.disableViewOverlay.backgroundColor=[UIColor blackColor];
    self.disableViewOverlay.alpha = 0;
}

- (IBAction)backToList:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
