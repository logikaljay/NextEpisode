//
//  NESearchShowViewController.h
//  NextEpisode
//
//  Created by Jay Baker on 29/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NESearchShowViewController : UIViewController
<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate> {
    NSMutableArray *tableData;
    UITableView *resultsView;
    UISearchBar *searchBar;
    UIView *disableViewOverlay;
    
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
}
@property (retain) NSMutableArray *tableData;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *resultsView;
@property (retain, nonatomic) IBOutlet UIView *disableViewOverlay;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic) NSMutableArray *shows;

- (void)parseXMLFileAtURL:(NSURL *)URL;

@end
