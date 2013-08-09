SBAPIClient is a simple library for communicating with the StageBloc API. It's built on top of [AFNetworking](https://github.com/AFNetworking/AFNetworking) and provides convenient asynchronous block based methods for interacting with the API.

## Getting Started

- [Sign up for StageBloc](http://www.stagebloc.com/signup).
- [Register your application](http://stagebloc.com/account/admin/management/developers/) to receive your `client id` and `secret` keys.
- Browse the [API Documentation](http://stagebloc.com/developers/api/#home), or check out the demo project included in this repository to learn more.

## Installation

The SBAPIClient can easily be dropped into an existing application.

1. Clone the repository with `git clone git@github.com:austinlouden/iOS-StageBloc.git` and add the `SBAPIClient` folder to your XCode project.
2. In the Build Phases tab of your application, link the following frameworks:
  - `Security` - for the secure storage of OAuth tokens
  - `SystemConfiguration` - for network reachability support
  - `MobileCoreServices` - for file MIME type detection on uploaded files

## Example Usage

You can interact with StageBloc API anywhere in your application by using the `SBAPIClient` singleton. Simply `#import "SBAPIClient.h` and use the provided class methods with `[SBAPICLient sharedClient]`.

### Sign In

StageBloc uses OAuth 2.0 for authentication. The method below will grant a user an OAuth token and automatically store it in the Keychain, as well as appending the appropriate headers for future API requests.
```objc
[[SBAPIClient sharedClient] authenicateWithUsername:username 
                                           password:password 
                                            success:^(AFOAuthCredential *credential) 
{        
        NSLog(@"%@", credential.accessToken);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
}];
```
On startup, you can check if a user is authorized with `[[SBAPIClient sharedClient] isAuthorized]` and display a login modal accordingly.

### Sign Up

Sign up is similar to sign in and will return a new `user` object in JSON format.

```objc
[[SBAPIClient sharedClient] signupWithEmail:username 
                                   password:passwordField 
                                    success:^(id responseObject) 
{
        NSLog(@"%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
}];
```

### Everything Else

Once a user is authenticated, all interations can be handled with AFNetworking's `getPath` and `postPath` methods. The path is a URL relative to the base URL specified in the `SBAPIClient.m` file. Any parameters can be passed as an `NSDictionary`.

#### An example request

```objc
[[SBAPIClient sharedClient] getPath:@"photos/list.json" 
                         parameters:@{@"album_id": @2368} 
                            success:^(AFHTTPRequestOperation *operation, id responseObject) 
{
            NSLog(@"%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
}];
```

