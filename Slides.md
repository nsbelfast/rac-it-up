# RAC It Up
#### A short tour of ReactiveCocoa with some practical examples

***

# ReactiveCocoa

^3.0 coming which will deprectate some of this
^Work on 3.0 was in progress when Swift was introduced, the new 3.0 will see most reimplemented in Swift, with bridging headers for use from Objective-C

- Functional reactive programming framework for ObjC
- Currently 2.3.1
- Inspired by Reactive Extensions
- Alternative to traditional KVO paradigm
- Created by GitHub & used in GitHub for Mac (Hi Coby!)

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

^ Map takes a transformation block which is applied to each value sent on the signal
^ In our example we'll examine the content of the email text field and map it to a BOOL representing its validity

Map `NSString` to an `NSNumber` representing a `BOOL`

- UI state management
- User feedback
- Compact logic

***

# Macros (2)

^ RAC is a shortcut macro which allows updating a property on an object with values sent on a signal
^ RACObserve performs KVO on a property and returns a signal of all values resulting from property changes

Macros like `RAC()` are handy shortcuts for UI state management

Logic automatically updates UI

Like CocoaBindings for iOS and Mac

***

# Combining Signals (3)

But what about validating the form as a whole?

The operator `combineLatest:reduce:` helps

***

# Combining with tuples (3)

^ `combineLatest:` takes an array of inputs signals, and returns a signal that when any input signal sends a value sends a tuple containing the latest value sent by each.
^ Could use `map:` and receive and unpack a tuple to operate on.
^ This is a common use case though, `combineLatest:reduce:` will take a block with as many arguments as input signals

The `combineLatest:` operator takes an array

Variable length

So, `reduce:` needs a tuple

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

# Target:selector pattern is for the bin (5)

^Ok, so notification center has blocks but still...

- UIControlEvent
- RACCommand
- Timers
- NSNotificationCenter
- @weakify/@strongify macros are helpful

***

# Don't retain your delegates, release yourself now (5)

^Many more available, e.g. action sheets
^We'll probably get a solution for the return-value-delegate-type issue in 3.0

For example:

- UIGestureRecogniser
- UIAlertView
- Note: can't be used if delegate method returns a value :pensive:


***

# Collections

^Underscore AND RAC - Why not use both?

- Some other libs provide collection operations, e.g. Underscore
- Working with signals allows for chaining though
- Filtering, mapping etc.
- Collections are treated as streams
- Lazily executed

***

# Collections



***

# Disposables

^(i.e. cleanup to be performed when the subscription ends).
^From the previous examples, removing KVO or notification observers added.

A subscription wraps a number of disposables

Can be useful for cancelling any ongoing work.

E.g. cancelling an ongoing network request.

***

# The chain will keep us together (6)

^Or a background process that must write files, delete duplicates and then upload

Chaining dependent, asynchronous operations allows for streamlining complex tasks

E.g. a network operation that needs to do a number of fetches


***

# Schedulers

- Main (Background by default?)
- Delays
- Intervals
- Repeats
- Retrys
- Throttling

***

# Downsides

^Timers: the timing aspect seems well suited but not for precision

Some places, ReactiveCocoa doesn't offer **huge** benefit as it requires additonal management

E.g. table view cell reuse & timers

And no Swift support... yet.


***

# Extensions

^ Many efforts to bring existing frameworks into the reactive world, replacing delegates with signals, etc

^ Core Data - ReactiveCoreData
^ HTTP client - AFNetworking-RACExtensions
^ ReactiveCocoaLayout - A work in progress with an interesting approach / alternative to auto layout, using signals and operations to express layout changes, animations etc

- HTTP (AFNetworking-RACExtensions)
- Core Data (ReactiveCoreData)
- Core Bluetooth (ReactiveCoreBluetooth)
- Layout (ReactiveCocoaLayout)

[And Many More...](http://cocoapods.org/?q=reactive)

***

# That's all folks

#### Feel free to get in touch!
#### @ominiom
#### @imnk
