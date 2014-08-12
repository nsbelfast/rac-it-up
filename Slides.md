# RAC It Up
#### A short tour of ReactiveCocoa with some practical examples

***

# ReactiveCocoa

- Functional reactive programming framework for ObjC
- Currently 2.0 with 3.0 coming which will deprectate some of this
- Inspired by Reactive Extensions
- Alternative to traditional KVO paradigm
- Adds some handy macros for short-handing common patterns
- Adds categories on existing classes, including UIKit
- Safe and happy approach to mem management
- Tuples!
- Good for:
	- Handling asynchronous or event-driven data sources
	- Chaining dependent operations
	- Parallelizing independent work
	- Simplifying collection transformations
	- State management

***

# RACSignal

Represents a event source, or stream of values delivered over time.

Three types of event:

  * Next (Value)
  * Error
  * Completed

***

# Example (KVO)

```objectivec
RACObserve(self, firstName)
```
returns an signal representing future changes
to the `firstName` property.

***

# Example (KVO)

Implementing dependent or computed properties through KVO:

```objectivec
RAC(self, fullName) = [RACSignal combineLatest:@[
  RACObserve(self, firstName),
  RACObserve(self, lastName)
] reduce:^(NSString *firstName, NSString *lastName) {
  return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}];
```

***

# Subscription

Each type of event received from a signal is delivered to its subscribers.

Can be as simple as a block:

```objectivec
[RACObserve(self, name) subscribeNext:^(NSString *name) {
  NSLog(@"Changed name to: %@", name);
}];
```

```objectivec
[[[RACSignal empty] delay:5] subscribeCompleted:^{
  NSLog(@"Time's up!");
}];
```

***

# Disposables

A subscription wraps a number of disposables (i.e. cleanup to be performed when
the subscription ends).

From the previous examples, removing KVO or notification observers added.

Can be useful for cancelling any ongoing work.

E.g. a signal that represents a network request would cancel the request.

***

# Categories on Cocoa classes

Provides signal interfaces for commonly used classes

***

# Example `NSNotificationCenter`

```objectivec
#import <NSNotificationCenter+RACSupport.h>
```

```objectivec
[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardDidShowNotification object:nil];
```

Returns an `RACSignal` which will send notifications.

***

# Combining to derive state

```objectivec
RACSignal *keyboardShowingSignal = [RACSignal merge:@[
  [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] mapReplace:@YES],
  [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardDidHideNotification object:nil] mapReplace:@NO]
]];

// Hide someView while the keyboard displays
RAC(self.someView, hidden) = keyboardShowingSignal;
```
