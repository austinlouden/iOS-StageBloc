//
//  SBHTTPClient.m
//  DemoProject
//
//  Created by Austin Louden on 7/30/13.
//  Copyright (c) 2013 StageBloc. All rights reserved.
//

#import "SBHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "AFOAuth2Client.h"

//#error Enter your StageBloc API credentials below
static NSString * const kStageBlocConsumerKey = @"0351fbad394c8f0b6a383152a29c812b";
static NSString * const kStageBlocConsumerSecret = @"8e83be9ff183046f9aa14f8ffe8604e3";

static NSString * const kAFAppDotNetAPIBaseURLString = @"https://api.stagebloc.com/3.0/";

@implementation SBHTTPClient

+ (SBHTTPClient *)sharedClient {
    static SBHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SBHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kAFAppDotNetAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    NSString *token = [AFOAuthCredential retrieveCredentialWithIdentifier:@"api.stagebloc.com"].accessToken;
    [self setAuthorizationHeaderWithToken:[NSString stringWithFormat:@"%@", token]];
    
    return self;
}

- (void)authenicateWithUsername:(NSString*)username password:(NSString*)password
{
    AFOAuth2Client *oauth2Client = [[AFOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.stagebloc.com/3.0/"]
                                                                  clientID:kStageBlocConsumerKey
                                                                    secret:kStageBlocConsumerSecret];
    
    [oauth2Client authenticateUsingOAuthWithPath:@"oauth2/token/" username:username password:password scope:@"non-expiring" success:^(AFOAuthCredential *credential) {
        NSLog(@"token: %@", credential.accessToken);
        [AFOAuthCredential storeCredential:credential withIdentifier:oauth2Client.serviceProviderIdentifier];
        
        
        [[SBHTTPClient sharedClient] getPath:@"blog/list.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end