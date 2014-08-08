//
//  UINavigationItem+indicateActivityWithSignal.m
//  RACItUp
//
//  Created by Iain Wilson on 08/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import "UINavigationItem+indicateActivityWithSignal.h"
#import "UIActivityIndicatorView+animateWithSignal.h"

@implementation UINavigationItem (indicateActivityWithSignal)

- (RACSignal *)rmb_indicateActivityWithSignal:(RACSignal *)signal {
  __block UIView *previousTitleView;
  __block BOOL didHideBackButton;

  UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

  @weakify(self);
  return [[[RACSignal defer:^{
    return [activityIndicator rmb_animateWithSignal:signal];
  }] initially:^{
    @strongify(self);
    previousTitleView = self.titleView;
    didHideBackButton = self.hidesBackButton;

    self.titleView = activityIndicator;
    self.hidesBackButton = YES;
  }] finally:^{
    @strongify(self);
    self.titleView = previousTitleView;
    self.hidesBackButton = didHideBackButton;
  }];
}

@end
