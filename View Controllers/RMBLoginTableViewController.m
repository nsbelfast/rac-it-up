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
  
  RAC(self.loginButton, enabled) = wholeFormIsValid;
  
  // tint logic
  RAC(self.navigationController.navigationBar, barTintColor) = [RACSignal if:wholeFormIsValid
                                                                        then:[RACSignal return:[UIColor greenColor]]
                                                                        else:[RACSignal return:[UIColor redColor]]];
}


@end
