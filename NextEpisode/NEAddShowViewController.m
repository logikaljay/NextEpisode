//
//  NEAddShowViewController.m
//  NextEpisode
//
//  Created by Jay Baker on 29/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import "NEAddShowViewController.h"
#import "NEViewController.h"
#import "NEShowDatabase.h"
#import "NEShow.h"

@interface NEAddShowViewController ()

@end

@implementation NEAddShowViewController

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
    
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"New Item"];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:@selector(backToList:)];
    [item setLeftBarButtonItem:back];
    [self.navBar pushNavigationItem:item animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToList:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addShow:(id)sender {
    // build the show
    NEShow *show = [[NEShow alloc] init];
    [show setShowId:self.showIdField.text];
    [show setShowName:self.showNameField.text];
    
    [[NEShowDatabase database] add:show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
