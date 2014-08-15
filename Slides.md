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

# Our Example

^We'll build a simple login form with validation and show how the UI can respond dynamically to user input.

^At the end, we'll show a more complex example by mocking up how the form could be sent via a network request reactively.

- Login form
- Field validation
- Dynamic UI
- Network request

****

# RACSignal

Represents an event source, or stream of values delivered over time.

Three types of event:

  * Next (Value)
  * Error
  * Completed

***

# Subscription (1)

Each event for a signal is delivered to its subscribers.

Most often used is `subscribeNext:`

It takes a block which is executed for every value received

***

# Subscription (1)

This is like KVO but for common UIKit elements!

ReactiveCocoa provides categories to help like `rac_textSignal` for `UITextField`

Let's see how this works...

***

# Operations (2)

^ Form validation

^ Signals are lazy (or cold), so you can compose everything before running it

Lots of signal operators available.

We can use `map:` to help with form validation

***

# Operations (2)

Map `NSString` to an `NSNumber` representing a `BOOL`

- UI state management
- User feedback
- Compact logic

***

# Macros (2)

Macros like `RAC()` are handy shortcuts for UI state management

Logic automatically updates UI

Like CocoaBindings for iOS and Mac

***

# Combining Signals (3)

But what about validating the form as a whole?

The operator `combineLatest:reduce` helps

***

# Tuples (3)

The `combineLatest` operator takes an array

Variable length

So, `reduce` needs a tuple

***

# Logical Operators (4)

Combined validation is a common pattern

ReactiveCocoa offers methods for boolean signals

Let's rewrite our form validation...

***

# Moar Logic (4)

ReactiveCocoa offers lots of logic as signals
- if:then:else:
- and
- or
- not
- switch

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

***

# Tuples

- Combined signals can be reduced
- Result is a tuple with the same number of arguments as input signals

```objectivec
EXAMPLE NEEDED
```

***

# Break away from the delegate pattern

^We'll probably get a solution for the return-value-delegate-type issue in 3.0

For example:

- UIControlEvent
- UIGestureRecogniser
- UIAlertView
- Note: can't be used if delegate method returns a value :pensive:

```objectivec
EXAMPLE NEEDED
```

***

# Target:selector pattern is for the bin :thumbsdown:

- UIControlEventTouchUpInside

```objectivec
EXAMPLE NEEDED
```



```objectivec
EXAMPLES NEEDED
```

***

# Collections

- Some other libs provide collection operations, e.g. Underscore
- Why not use both?
- filtering, mapping
- Working with signals allows for chaining though
- Collections are treated as streams
- Execution is lazy

```objectivec
EXAMPLES NEEDED
```

***

# Schedulers

- Main (Background by default?)
- Delays
- Intervals
- Repeats
- Retrys
- Throttling

```objectivec
EXAMPLES NEEDED
```

***

# The chain is your friend

Chaining dependent, asynchronous operations allows for streamlining complex tasks

For example, a network operation that needs to do a number of fetches

Or a background process that must write files, delete duplicates and then upload


```objectivec
SHOW A NETWORKING EXAMPLE WITH AFNETWORKING
```

***

# Pitfalls

Some places, ReactiveCocoa doesn't offer **huge** benefit as it requires additonal management

For example table view cell reuse

Or timers: the timing aspect seems well suited but not for precision
