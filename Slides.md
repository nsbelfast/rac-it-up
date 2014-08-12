# RAC It Up
#### A short tour of ReactiveCocoa with some practical examples

***

# ReactiveCocoa

^3.0 coming which will deprectate some of this

- Functional reactive programming framework for ObjC
- Currently 2.0
- Inspired by Reactive Extensions
- Alternative to traditional KVO paradigm

***

# ReactiveCocoa

^Macros help with short-handing common patterns as we'll see

^Categories on existing classes, including UIKit

^Signals conform to ARC etc

- Handy macros
- Handy categories
- Good memory management semantics
- Tuples!

***

# ReactiveCocoa is good for you :+1:

- Handle asynchronous / event-driven data sources
- Chain dependent operations
- Parallelise independent work
- Simplify collection transformations
- Manage state

***

# RACSignal

Represents a event source, or stream of values delivered over time.

Three types of event:

  * Next (Value)
  * Error
  * Completed

***

NOTE: I wonder should we try and keep code to an absolute minimum in the slides

We can maybe explain concepts briefly through text/diagrams and then code right through an example?


***

# Subscription

Each type of event received from a signal is delivered to its subscribers.

Can be as simple as a block:

```objectivec
[[[RACSignal empty] delay:5] subscribeCompleted:^{
	NSLog(@"Time's up!");
}];
```

***

# Example (KVO)

```objectivec
RACObserve(self, firstName)
```
returns a signal representing future changes
to the `firstName` property.

***

# Example (KVO)

This can be subscribed to as shown before

```objectivec
[RACObserve(self, name) subscribeNext:^(NSString *name) {
	NSLog(@"Changed name to: %@", name);
}];
```

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
