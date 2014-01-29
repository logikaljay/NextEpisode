//
//  NESearchShowViewController.m
//  NextEpisode
//
//  Created by Jay Baker on 29/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import "NESearchShowViewController.h"

@implementation NESearchShowViewController

@synthesize tableData;
@synthesize resultsView;
@synthesize searchBar;
@synthesize disableViewOverlay;

- (void)searchBarTextDidBeginEditing:(UISearchBar *)uiSearchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    self.resultsView.allowsSelection = NO;
    self.resultsView.scrollEnabled = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)uiSearchBar
{
    NSString *people = @"Jay,Bob,Sam,Tom";
    NSArray *results = [people componentsSeparatedByString:@","];
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.resultsView.allowsSelection = YES;
    self.resultsView.scrollEnabled = YES;
	
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:results];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"SearchResult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:MyIdentifier];
    }
	
    //id *data = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = @"Foo";
    return cell;
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
    //[resultsView setDelegate:self];
    [resultsView setDataSource:self];
    
    self.tableData =[[NSMutableArray alloc]init];
    self.disableViewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f,44.0f,320.0f,416.0f)];
    self.disableViewOverlay.backgroundColor=[UIColor blackColor];
    self.disableViewOverlay.alpha = 0;
    
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
