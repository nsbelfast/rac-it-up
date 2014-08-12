# RACSignal

Represents a event source, or stream of values delivered over time.

Three types of event:

  * Next (Value)
  * Error
  * Completed

# Example (KVO)

`RACObserve(self, firstName)` returns an signal representing future changes
to the `firstName` property.

Implementing dependent or computed properties through KVO:

```objective-c
RAC(self, fullName) = [RACSignal combineLatest:@[
  RACObserve(self, firstName),
  RACObserve(self, lastName)
] reduce:^(NSString *firstName, NSString *lastName) {
  return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}];
```

# Subscription

Each type of event received from a signal is delivered to its subscribers.

Can be as simple as a block:

```objective-c
[RACObserve(self, name) subscribeNext:^(NSString *name) {
  NSLog(@"Changed name to: %@", name);
}];
```

```objective-c
[[[RACSignal empty] delay:5] subscribeCompleted:^{
  NSLog(@"Time's up!");
}];
```

# Disposables

A subscription wraps a number of disposables (i.e. cleanup to be performed when 
the subscription ends).

From the previous examples, removing KVO or notification observers added.

Can be useful for cancelling any ongoing work.

E.g. a signal that represents a network request would cancel the request.

# Categories on Cocoa classes

Provides signal interfaces for commonly used classes

# Example `NSNotificationCenter`

```objectivec
#import <NSNotificationCenter+RACSupport.h>
```

```objectivec
[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardDidShowNotification object:nil];
```

Returns an `RACSignal` which will send notifications.

# Combining to derive state

```objective-c
RACSignal *keyboardShowingSignal = [RACSignal merge:@[
  [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] mapReplace:@YES],
  [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardDidHideNotification object:nil] mapReplace:@NO]
]];

// Hide someView while the keyboard displays
RAC(self.someView, hidden) = keyboardShowingSignal;
```