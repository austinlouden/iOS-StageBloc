//
//  SBHTTPClient.m
//  DemoProject
//
//  Created by Austin Louden on 7/30/13.
//  Copyright (c) 2013 StageBloc. All rights reserved.
//

#import "SBAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "AFOAuth2Client.h"


#error Enter your StageBloc API credentials below, then comment out this line
static NSString * const kStageBlocConsumerKey = @"";
static NSString * const kStageBlocConsumerSecret = @"";

static NSString * const kSBAPIBaseURLString = @"https://api.stagebloc.com/3.0/";

@implementation SBAPIClient

+ (SBAPIClient *)sharedClient {
    static SBAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SBAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kSBAPIBaseURLString]];
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

#pragma mark - Login and Sign Up

- (void)authenicateWithUsername:(NSString*)username
                       password:(NSString*)password
                        success:(void (^)(AFOAuthCredential *credential))success
                        failure:(void (^)(NSError *error))failure
{
    
    AFOAuth2Client *oauth2Client = [[AFOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:kSBAPIBaseURLString]
                                                                  clientID:kStageBlocConsumerKey
                                                                    secret:kStageBlocConsumerSecret];
    
    [oauth2Client authenticateUsingOAuthWithPath:@"oauth2/token/"
                                        username:username password:password
                                           scope:@"non-expiring"
                                         success:^(AFOAuthCredential *credential) {
        
        [AFOAuthCredential storeCredential:credential withIdentifier:oauth2Client.serviceProviderIdentifier];
        [self setAuthorizationHeaderWithToken:[NSString stringWithFormat:@"%@", credential.accessToken]];
        success(credential);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)signupWithEmail:(NSString*)email
                  password:(NSString*)password
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    [self postPath:@"user/edit.json" parameters:@{@"email": email, @"password" : password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}

@end
