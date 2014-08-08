//
//  UIAlertView+prompt.m
//  RACItUp
//
//  Created by Iain Wilson on 07/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import "UIAlertView+prompt.h"
#import "UIAlertView+confirmation.h"

@implementation UIAlertView (prompt)

- (RACSignal *)rmb_prompt:(RACSignal *)continueSignal cancel:(RACSignal *)cancelSignal {
  RACSignal *resultSignal = [RACSignal if:self.rmb_confirmation then:continueSignal else:cancelSignal];

  return [resultSignal setNameWithFormat:@"[%@] -rmb_prompt: %@ cancel: %@", self, continueSignal, cancelSignal];
}

- (RACSignal *)rmb_prompt:(RACSignal *)continueSignal {
  RACSignal *resultSignal = [self rmb_prompt:continueSignal cancel:[RACSignal empty]];

  return [resultSignal setNameWithFormat:@"[%@] -rmb_prompt: %@", self, continueSignal];
}

@end
