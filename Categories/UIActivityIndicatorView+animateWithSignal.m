//
//  UIActivityIndicatorView+animateWithSignal.m
//  RACItUp
//
//  Created by Iain Wilson on 08/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import "UIActivityIndicatorView+animateWithSignal.h"

@implementation UIActivityIndicatorView (animateWithSignal)

- (RACSignal *)rmb_animateWithSignal:(RACSignal *)signal {
  @weakify(self);
  return [[[signal initially:^{
    @strongify(self);
    [self startAnimating];
  }] finally:^{
    @strongify(self);
    [self stopAnimating];
  }] setNameWithFormat:@"[%@] -rmb_animateWithSignal: %@", self, signal];
}

@end
