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

// production keys
// client id: 0351fbad394c8f0b6a383152a29c812b
// client secret: 8e83be9ff183046f9aa14f8ffe8604e3

//development keys
// client id: 28d5a7bdff3f3de38387de64ee0f5947
// client secret: ec1e0919c732f228066e7ca0a36e4d18

//#error Enter your StageBloc API credentials below, then comment out this line
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
    
    return self;
}

- (BOOL)isAuthorized
{
    if([AFOAuthCredential retrieveCredentialWithIdentifier:@"api.stagebloc.com"].accessToken) {
        return YES;
    }
    
    return NO;
}

/*
 - (void)authenticateUsingOAuthWithUsername:(NSString *)username
 password:(NSString *)password
 success:(void (^)(AFOAuthAccount *account))success
 failure:(void (^)(NSError *error))failure {
 
 NSURL *url = [NSURL URLWithString:oClientBaseURLString];
 AFOAuth2Client *OAuthClient = [[AFOAuth2Client alloc] initWithBaseURL:url];
 
 [OAuthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
 [OAuthClient authenticateUsingOAuthWithPath:@"oauth/token.json" username:username  password:password clientID:oClientID secret:oClientSecret success:^(AFOAuthAccount *account) {
 [self setAuthorizationWithToken:account.credential.accessToken refreshToken:account.credential.refreshToken];
 success(account);
 } failure:^(NSError *error) {
 failure(nil);
 }];
 }
 */

- (void)authenicateWithUsername:(NSString*)username
                       password:(NSString*)password
                        success:(void (^)(AFOAuthCredential *credential))success
                        failure:(void (^)(NSError *error))failure
{
    
    AFOAuth2Client *oauth2Client = [[AFOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.stagebloc.com/3.0/"]
                                                                  clientID:kStageBlocConsumerKey
                                                                    secret:kStageBlocConsumerSecret];
    
    [oauth2Client authenticateUsingOAuthWithPath:@"oauth2/token/"
                                        username:username password:password
                                           scope:@"non-expiring"
                                         success:^(AFOAuthCredential *credential) {
        [
         AFOAuthCredential storeCredential:credential withIdentifier:oauth2Client.serviceProviderIdentifier];
        [self setAuthorizationHeaderWithToken:[NSString stringWithFormat:@"%@", credential.accessToken]];
        success(credential);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

@end