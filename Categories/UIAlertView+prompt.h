//
//  UIAlertView+prompt.h
//  RACItUp
//
//  Created by Iain Wilson on 07/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (prompt)

- (RACSignal *)rmb_prompt:(RACSignal *)continueSignal cancel:(RACSignal *)cancelSignal;
- (RACSignal *)rmb_prompt:(RACSignal *)continueSignal;

@end
