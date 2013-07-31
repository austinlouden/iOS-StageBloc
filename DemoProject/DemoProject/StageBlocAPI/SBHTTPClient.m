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
    //[self setAuthorizationHeaderWithToken:[NSString stringWithFormat:@"OAuth %@", token]];
    [self setAuthorizationHeaderWithToken:[NSString stringWithFormat:@"%@", token]];
    
    return self;
}

@end