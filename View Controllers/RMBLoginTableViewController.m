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

@end

@implementation RMBLoginTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // 1. A basic signal with a subscription
  
  RACSignal *emailTextSignal = [self.emailTextField rac_textSignal];
  [emailTextSignal subscribeNext:^(id x) {
    NSLog(@"Email text field: %@", x);
  }];
  
  
  
}


@end
