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
  
  // 3. Whole form validation
  
  RACSignal *emailTextSignal = [self.emailTextField rac_textSignal];
  RACSignal *passwordTextSignal = [self.passwordTextField rac_textSignal];
  
  RACSignal *formIsValid = [RACSignal combineLatest:@[emailTextSignal, passwordTextSignal]
                                             reduce:^id(NSString *emailText, NSString *passwordText) {
                                               return @(emailText.length > 0 && passwordText.length > 0);
                                             }];
  
  RAC(self.loginButton, enabled) = formIsValid;
}


@end
