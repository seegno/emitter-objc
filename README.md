EventEmitter for Objective-C that implements the NodeJS EventEmitter API as closely as possible.

The library adds a category to NSObject that allows any object to `emit` or `listen` to events.

[![Build Status](https://travis-ci.org/seegno/emitter-objc.png)](https://travis-ci.org/seegno/emitter-objc)

## Install it

Add it as a Cocoapods dependency to your Podfile:

	pod 'Emitter', '~> 0.0.5'

## Use it

### Quick Start

Register event listener on any object:

```objective-c
#import <EventEmitter/EventEmitter.h>

NSObject *server = [[NSObject alloc] init];

[server on:@"connection" listener:^(id stream) {
	NSLog(@"someone connected!");
}];

[server once:@"connection" listener:^(id stream) {
	NSLog(@"Ah, we have our first user!");
}];
```

And later fire an event to the same object:

```objective-c
[server emit:@"connection", stream];

[server emit:@"event" @{
	@"type": @"somethinghappend",
	@"another key": @"another value",
}];
```

### Listening for events

You can listen for events using:

```objective-c
- (void)addListener:(NSString *)event listener:(id)listener;
- (void)on:(NSString *)event listener:(id)listener;
- (void)once:(NSString *)event listener:(id)listener;
```

Stop listening with:

```objective-c
- (void)removeListener:(NSString *)event listener:(id)listener;
- (void)removeAllListeners:(NSString *)event;
```

### Emitting events

Emit events with:

```objective-c
- (void)emit:(NSString *)event, ...;
```

### Dynamic block invocation

Any callback block you provide will be called with the correct parameters (we used the fantastic [BlocksKit](https://github.com/pandamonia/BlocksKit) to dynamically invoke the callback block).

This means you can emit events with any number of parameters such as:

```objective-c
[object emit:@"event", @"hello", @123, NO, @{ @"key": @"value" }];
```

and listen for them with:

```objective-c
[object on:@"event", ^(NSString *param1, NSNumber *param2, BOOL param3, NSDictionary *param4){
	NSLog(@"Every parameter was passed correctly!");
}];
```

## Credits

The original idea was taken from jerolimov's [EventEmitter](https://github.com/jerolimov/EventEmitter) and expanded to support dynamic block arguments and a single method to emit events.
