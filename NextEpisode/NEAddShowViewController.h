//
//  NEAddShowViewController.h
//  NextEpisode
//
//  Created by Jay Baker on 29/01/14.
//  Copyright (c) 2014 Jay Baker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEAddShowViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITextField *showIdField;
@property (weak, nonatomic) IBOutlet UITextField *showNameField;

- (IBAction)addShow:(id)sender;

@end
