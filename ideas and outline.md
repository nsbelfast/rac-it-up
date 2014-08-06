#RAC It Up
===
http://racitupcaddy.com/

###ReactiveCocoa
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
	
###Heads Up
- We won't go into FRP but hopefully you'll get a feel for it as we start to delve in
- We're going to primarily use UIKit to demonstrate but works on Mac dev also
- Slides will be online
- Github repo will be open sourced
- Q&A at the end but feel free to shout out any questions (and witty retorts – strictly witty ones)

###Basic blocks are Signals and Streams
- Example of signal
- Show how it's 'cold' and only generates output when subscribed to
- Subcribing to next, completed and error
- Empty signals complete immediately
- Subjects are hot signals
- Can be defered
- Most of the time, an operating method will return a new signal – easily chained


###State Management
- Provide a property that will change according to another
- Show the RAC() = RACObserve() and [RACObserve() subscribeNext] patterns
- Binding to User Defaults?
- Enable a button when a form is complete
- When everything is chained together, a small change can have a cascading effect, reducing the need to large refactors for small changes
- @keypath

###Controls
- RACCommand - encapsulating a signal
- UIControlEvents
- Text fields

###Notifications
- Keyboard show/hide
- NotificationCenter

###Break away from old delegate pattern
- UIControls
- UIGestureRecogniser
- UIAlertView

###Logic
- if:else:, and, or, not & switch as signals!
- filtering, mapping
- combining, merging
- Show example of tuple, e.g. combineLatest:reduce:

###Collections
- Some other libs provide collection operations, e.g. Underscore
- Why not use both?
- Working with signals allows for chaining though
- Collections are treated as streams
- Execution is lazy

###Schedulers
- Main
- Background by default?
- Delays
- Intervals
- Repeats
- Retrys
- Throttling

###Complex examples
- Networking – chaining signals & waiting on requests returned

###Where it can get tricky
- Table view cell reuse
- Timers – seems well suited but not advised for precision timing


#Must Haves:
- Gifs
- Code snippets / text expander
- Git repo
- Slides
- Music?