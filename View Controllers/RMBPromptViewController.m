//
//  RMBPromptViewController.m
//  RACItUp
//
//  Created by Iain Wilson on 07/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import "RMBPromptViewController.h"

#import "UIAlertView+prompt.h"
#import "UINavigationItem+indicateActivityWithSignal.h"

@interface RMBPromptViewController ()

@property (nonatomic) UITextField *targetTextField;
@property (nonatomic) UILabel *instructionLabel;
@property (nonatomic) UIButton *triggerButton;
@property (nonatomic) UIButton *cancelButton;

@property (nonatomic) RACCommand *destroyCommand;

@end

@implementation RMBPromptViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.navigationItem.title = @"Prompting";

  UIColor *positiveColor = [UIColor colorWithRed:0x5c / 255.f green:0xb8 / 255.f blue:0x5c / 255.f alpha:1.f];
  UIColor *negativeColor = [UIColor colorWithRed:0xd9 / 255.f green:0x53 / 255.f blue:0x4f / 255.f alpha:1.f];

  self.instructionLabel = [UILabel new];
  self.instructionLabel.layer.cornerRadius = 5.f;
  self.instructionLabel.textAlignment = NSTextAlignmentCenter;
  self.instructionLabel.textColor = [UIColor whiteColor];
  self.instructionLabel.font = [UIFont boldSystemFontOfSize:20.f];
  [self.view addSubview:self.instructionLabel];

  self.targetTextField = [UITextField new];
  self.targetTextField.backgroundColor = [UIColor whiteColor];
  self.targetTextField.placeholder = @"Enter target";
  [self.view addSubview:self.targetTextField];

  self.triggerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.triggerButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
  self.triggerButton.layer.borderColor = self.view.tintColor.CGColor;
  self.triggerButton.layer.borderWidth = 3.f;
  self.triggerButton.layer.cornerRadius = 5.f;
  [self.triggerButton setTitle:@"Destroy!" forState:UIControlStateNormal];
  [self.triggerButton setTitleColor:self.view.tintColor forState:UIControlStateNormal | UIControlStateDisabled];
  [self.view addSubview:self.triggerButton];

  self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
  self.cancelButton.layer.borderColor = negativeColor.CGColor;
  self.cancelButton.layer.borderWidth = 3.f;
  self.cancelButton.layer.cornerRadius = 5.f;
  self.cancelButton.tintColor = negativeColor;
  [self.cancelButton setTitle:@"Abort!" forState:UIControlStateNormal];
  [self.cancelButton setTitleColor:negativeColor forState:UIControlStateNormal | UIControlStateDisabled];
  [self.view addSubview:self.cancelButton];

  RACSignal *triggerButtonTapped = [self.triggerButton rac_signalForControlEvents:UIControlEventTouchUpInside];
  RACSignal *targetSignal = self.targetTextField.rac_textSignal;

  RACSignal *validSignal = [targetSignal map:^(NSString *target) {
    NSString *trimmed = [target stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return @(trimmed.length > 0);
  }];

  RACSignal *cancellation = [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] take:1];

  self.destroyCommand = [[RACCommand alloc] initWithEnabled:validSignal signalBlock:^(NSString *target) {
    // Destruction is swift...
    RACSignal *destroySignal = [[RACSignal empty] delay:2];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Continue?"
                                                    message:[NSString stringWithFormat:@"Destroy %@? Really?", target]
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Continue", nil];

    RACSignal *destruction = [destroySignal finally:^{
      [[[UIAlertView alloc] initWithTitle:@"Complete"
                                  message:[NSString stringWithFormat:@"Destroyed %@!", target]
                                 delegate:nil
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil] show];
    }];

    RACSignal *cancellableDestruction = [destruction takeUntil:cancellation];
    RACSignal *animatedDestruction = [self.navigationItem rmb_indicateActivityWithSignal:cancellableDestruction];

    [self.targetTextField resignFirstResponder];

    return [alert rmb_prompt:animatedDestruction];
  }];

  [self.destroyCommand rac_liftSelector:@selector(execute:) withSignalsFromArray:@[
    [targetSignal sample:triggerButtonTapped]
  ]];

  RAC(self.cancelButton, hidden) = [self.destroyCommand.executing not];

  RAC(self.instructionLabel, text) = [RACSignal if:validSignal
                                              then:[RACSignal return:@"✓"]
                                              else:[RACSignal return:@"✗"]];

  RAC(self.instructionLabel, backgroundColor) = [RACSignal if:validSignal
                                                         then:[RACSignal return:positiveColor]
                                                         else:[RACSignal return:negativeColor]];

  RAC(self.triggerButton.layer, opacity) = [RACSignal if:RACObserve(self.triggerButton, enabled)
                                                    then:[RACSignal return:@(1)]
                                                    else:[RACSignal return:@(.25f)]];

  RAC(self.triggerButton, enabled) = [[RACSignal combineLatest:@[
                                        validSignal,
                                        [self.destroyCommand.executing not]
                                      ]] and];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  self.targetTextField.frame   = CGRectMake(20, 40, CGRectGetWidth(self.view.bounds) - 40, 40);
  self.instructionLabel.frame  = CGRectOffset(self.targetTextField.frame, 0, 60);
  self.triggerButton.frame     = CGRectOffset(self.instructionLabel.frame, 0, 60);
  self.cancelButton.frame      = CGRectOffset(self.triggerButton.frame, 0, 60);
}

@end
