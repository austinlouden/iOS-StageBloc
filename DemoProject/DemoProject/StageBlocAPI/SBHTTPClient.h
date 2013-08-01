//
//  SBHTTPClient.h
//  DemoProject
//
//  Created by Austin Louden on 7/30/13.
//  Copyright (c) 2013 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFOAuth2Client.h"

@interface SBHTTPClient : AFHTTPClient
+ (SBHTTPClient *)sharedClient;
- (BOOL)isAuthorized;
- (void)authenicateWithUsername:(NSString*)username
                       password:(NSString*)password
                        success:(void (^)(AFOAuthCredential *credential))success
                        failure:(void (^)(NSError *error))failure;
@end