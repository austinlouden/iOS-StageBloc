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

### Authentication

StageBloc uses OAuth 2.0 for authentication. The method below will grant a user an OAuth token and automatically store it in the Keychain.
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
