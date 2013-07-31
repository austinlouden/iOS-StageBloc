//
//  SBRootViewController.m
//  DemoProject
//
//  Created by Austin Louden on 7/31/13.
//  Copyright (c) 2013 StageBloc. All rights reserved.
//

#import "SBRootViewController.h"
#import "SBHTTPClient.h"

@interface SBRootViewController ()

@end

@implementation SBRootViewController

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
	// Do any additional setup after loading the view.
    
    [[SBHTTPClient sharedClient] authenicateWithUsername:@"austinlouden@gmail.com" password:@"3LOFuWw1"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
