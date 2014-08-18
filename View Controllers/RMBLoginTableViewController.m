//
//  RMBLoginTableViewController.m
//  RACItUp
//
//  Created by Niall Kelly on 15/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import "RMBLoginTableViewController.h"

#import <RACAFNetworking.h>

#import <UIAlertView+RACSignalSupport.h>
#import "UINavigationItem+indicateActivityWithSignal.h"

@interface RMBLoginTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (nonatomic) AFHTTPRequestOperationManager *client;
@end

@implementation RMBLoginTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // 4. Concise form validation
  
  id (^FieldIsValidMap)(NSString *) = ^(NSString *fieldText){
    return @(fieldText.length > 0);
	};
  
  RACSignal *emailValidSignal = [self.emailTextField.rac_textSignal map:FieldIsValidMap];
  RACSignal *passwordValidSignal = [self.passwordTextField.rac_textSignal map:FieldIsValidMap];
  
  // (HINT: invert the logic by simply appending a -not!)
  RACSignal *wholeFormIsValid = [[RACSignal combineLatest:@[emailValidSignal, passwordValidSignal]] and];
  
  
  // 5. No delegates, or target:selector patterns
  
  @weakify(self);
  RACCommand *loginCommand = [[RACCommand alloc] initWithEnabled:wholeFormIsValid
                                                     signalBlock:^(UIButton *sender) {
                                                       @strongify(self);
                                                       // we'll wait 3 seconds for this example to simulate a slower connection
                                                       return [[[RACSignal empty] delay:3] concat:[self login]];
                                                     }];
  
  self.loginButton.rac_command = loginCommand;
  
  RACSignal *keyboardShowingSignal = [RACSignal merge:@[
                                       [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] mapReplace:@YES],
                                       [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardDidHideNotification object:nil] mapReplace:@NO]
                                     ]];

  [keyboardShowingSignal subscribeNext:^(NSNumber *keyboardIsOnScreen) {
    // look how easy this is! how would we even have done this before?
    NSLog(@"Keyboard is %@showing", keyboardIsOnScreen.boolValue ? @"" : @"not ");
  }];
  
  RAC(self.navigationItem, rightBarButtonItem) = [RACSignal if:[loginCommand executing]
                                                          then:[RACSignal return:self.cancelButton]
                                                          else:[RACSignal return:self.loginButton]];
  
  // 6. Chaining dependent operations

  self.client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://httpbin.org/"]];
  self.client.requestSerializer = [AFJSONRequestSerializer serializer];
  self.client.responseSerializer = [AFJSONResponseSerializer serializer];
}

#pragma mark - Authentication

/// Makes an authenticated request using `credential`
- (RACSignal *)authenticateWithCredential:(NSURLCredential *)credential {
  return [[[self.client rac_GET:@"/digest-auth/auth/valid@email.com/password" parameters:nil] initially:^{
    self.client.credential = credential;
  }] doError:^(NSError *error) {
    // Remove the credential if the login failed
    self.client.credential = nil;
  }];
}

/// Returns a signal that attempts to login with the entered email / password, displaying an alert on success or error
- (RACSignal *)login {
  NSURLCredential *credential = [NSURLCredential credentialWithUser:self.emailTextField.text password:self.passwordTextField.text persistence:NSURLCredentialPersistenceNone];

  RACSignal *loginRequest = [self authenticateWithCredential:credential];
  RACSignal *loginActivity = [self.navigationItem rmb_indicateActivityWithSignal:loginRequest];

  return [[loginActivity catch:^(NSError *error) {
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];

    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    RACSignal *displayError = [RACSignal defer:^{
      [errorAlert show];
      return [errorAlert.rac_buttonClickedSignal take:1];
    }];

    if (response.statusCode == 401) {
      errorAlert.message = @"Invalid email or password";
    }
    else {
      errorAlert.message = @"Unable to login";
    }

    return [displayError concat:[RACSignal error:error]];
  }] doCompleted:^{
    [[[UIAlertView alloc] initWithTitle:@"Login successful" message:@"You're in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
  }];
}

@end
