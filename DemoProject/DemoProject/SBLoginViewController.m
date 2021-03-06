//
//  SBLoginViewController.m
//  DemoProject
//
//  Created by Austin Louden on 8/1/13.
//  Copyright (c) 2013 StageBloc. All rights reserved.
//

#import "SBLoginViewController.h"
#import "SBAPIClient.h"

@interface SBLoginViewController ()
{
    UITextField *usernameField;
    UITextField *passwordField;
}
@end

@implementation SBLoginViewController

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
	
    usernameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 280.0f, 30.0f)];
    usernameField.placeholder = @"Username or Email";
    usernameField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:usernameField];
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 140.0f, 280.0f, 30.0f)];
    passwordField.placeholder = @"Password";
    passwordField.secureTextEntry = YES;
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:passwordField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setFrame:CGRectMake(50.0f, 180.0f, 220.0f, 40.0f)];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)loginPressed
{
    [[SBAPIClient sharedClient] authenicateWithUsername:usernameField.text password:passwordField.text success:^(AFOAuthCredential *credential) {
        NSLog(@"%@", credential.accessToken);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
    /*
    [[SBAPIClient sharedClient] signupWithEmail:usernameField.text password:passwordField.text success:^(id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
