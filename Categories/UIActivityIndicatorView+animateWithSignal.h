//
//  UIActivityIndicatorView+animateWithSignal.h
//  RACItUp
//
//  Created by Iain Wilson on 08/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActivityIndicatorView (animateWithSignal)

- (RACSignal *)rmb_animateWithSignal:(RACSignal *)signal;

@end
