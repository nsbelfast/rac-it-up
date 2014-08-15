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
  
  // 1. A basic signal with a subscription
  
  RACSignal *emailTextSignal = [self.emailTextField rac_textSignal];
  
  // 2. Validate the email as the user types
  
  RACSignal *emailIsValidSignal = [emailTextSignal map:^id(NSString *value) {
    return @(value.length > 0);
  }];
  
  [emailIsValidSignal subscribeNext:^(NSNumber *valid) {
    NSLog(@"Email is %@valid", valid.boolValue ? @"" : @"NOT ");
  }];
  
  RAC(self.loginButton, enabled) = emailIsValidSignal;
}


@end
