//
//  UIAlertView+confirmation.m
//  RACItUp
//
//  Created by Iain Wilson on 07/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import "UIAlertView+confirmation.h"

@implementation UIAlertView (confirmation)

- (RACSignal *)rmb_confirmation {
  return [[RACSignal defer:^{
    [self show];

    return [[self.rac_buttonClickedSignal map:^(NSNumber *buttonIndex) {
      return @(buttonIndex.integerValue != self.cancelButtonIndex);
    }] take:1];
  }] setNameWithFormat:@"[%@] -rmb_confirmation", self];
}

@end
