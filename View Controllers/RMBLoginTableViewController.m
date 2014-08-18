//
//  RMBLoginTableViewController.m
//  RACItUp
//
//  Created by Niall Kelly on 15/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import "RMBLoginTableViewController.h"

@interface RMBLoginTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;

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
  self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:wholeFormIsValid
                                                         signalBlock:^RACSignal *(id input) {
                                                           @strongify(self);
                                                           return [self login];
                                                         }];
  
  RACSignal *keyboardShowingSignal = [RACSignal merge:@[[[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] mapReplace:@YES],
                                                        [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardDidHideNotification object:nil] mapReplace:@NO]
                                                        ]];
  [keyboardShowingSignal subscribeNext:^(NSNumber *keyboardIsOnScreen) {
    // look how easy this is! how would we even have done this before?
    NSLog(@"Keyboard is %@showing", keyboardIsOnScreen.boolValue ? @"" : @"not ");
  }];
  
  // 6. Collections
  /*
   RACSequence *results = [[strings.rac_sequence
   filter:^ BOOL (NSString *str) {
   return str.length >= 2;
   }]
   map:^(NSString *str) {
   return [str stringByAppendingString:@"foobar"];
   }];
   */
  
  // 7. Networking & disposables
  
  // What can we log into though??
  
  /*
   [[[[client logIn]
   then:^{
   return [client loadCachedMessages];
   }]
   flattenMap:^(NSArray *messages) {
   return [client fetchMessagesAfterMessage:messages.lastObject];
   }]
   subscribeError:^(NSError *error) {
   [self presentError:error];
   } completed:^{
   NSLog(@"Fetched all messages.");
   }];
   */
}

- (RACSignal *)login {
  return [[RACSignal.empty delay:5] doCompleted:^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log in failed"
                                                    message:@"You suck"
                                                   delegate:nil
                                          cancelButtonTitle:@"Sadface"
                                          otherButtonTitles:@"No, I don't", nil];
    
    [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *buttonIndex) {
      NSLog(@"Alert clicked button at index: %@", buttonIndex);
    }];
    
    [alert show];
  }];
}


@end
