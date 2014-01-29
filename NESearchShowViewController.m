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

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"File found and parsing started");
}

- (void)parseXMLFileAtURL:(NSURL *)URL
{
    NSString *userAgent = @"Mozilla/5.0 (Macintosh; U; Intel Mac OSX 10_9_0; en-us) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    NSData *xmlFile = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    articles = [[NSMutableArray alloc] init];
    rssParser = [[NSXMLParser alloc] initWithData:xmlFile];
    [rssParser setDelegate:self];
    [rssParser parse];
    errorParsing = NO;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSString *error = [NSString stringWithFormat:@"Parsing Error %i", [parseError code]];
    NSLog(@"%@", error);
    errorParsing = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributes
{
    currentElement = [elementName copy];
    ElementValue = [[NSMutableString alloc] init];
    if ([elementName isEqualToString:@"show"]) {
        item = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [ElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"show"]) {
        [articles addObject:[item copy]];
    } else {
        [item setObject:ElementValue forKey:elementName];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (!errorParsing) {
        NSLog(@"XML processing done");
    } else {
        NSLog(@"Error occured during XML processing");
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)uiSearchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    self.resultsView.allowsSelection = NO;
    self.resultsView.scrollEnabled = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)uiSearchBar
{
    NSString *people = [NSString stringWithFormat:@"Jay,Bob,Sam,Tom,%@", uiSearchBar.text];
    
    // build our search URL
    NSString *url = [NSString stringWithFormat:@"http://services.tvrage.com/feeds/search.php?show=%@", uiSearchBar.text];
    
    // filter people by match
    [self parseXMLFileAtURL:[NSURL URLWithString:url]];
    // NSArray *results = [articles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", uiSearchBar.text]];
    NSArray *results = [articles copy];
    
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
