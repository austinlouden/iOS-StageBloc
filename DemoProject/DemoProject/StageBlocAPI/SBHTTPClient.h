//
//  SBHTTPClient.h
//  DemoProject
//
//  Created by Austin Louden on 7/30/13.
//  Copyright (c) 2013 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface SBHTTPClient : AFHTTPClient

+ (SBHTTPClient *)sharedClient;
- (void)authenicateWithUsername:(NSString*)username password:(NSString*)password;

@end