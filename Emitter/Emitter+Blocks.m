//
//  Emitter+Blocks.m
//  Emitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <objc/runtime.h>
#import <BlocksKit/A2BlockInvocation.h>

#import "NSInvocation+BlockArguments.h"
#import "Emitter+Blocks.h"

@implementation NSObject(EmitterBlocks)

- (NSMutableDictionary *)eventListeners
{
    @synchronized(self)
    {
        NSMutableDictionary *_eventListeners = objc_getAssociatedObject(self, @"eventListeners");

        if (!_eventListeners) {
            _eventListeners = [[NSMutableDictionary alloc] init];

            objc_setAssociatedObject(self, @"eventListeners", _eventListeners, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        return _eventListeners;
    }
}

- (void)addListener:(id)event listener:(id)listener once:(BOOL)once
{
    if (!self.eventListeners[event]) {
        self.eventListeners[event] = [[NSMutableDictionary alloc] init];
    }

    self.eventListeners[event][listener] = @(once);
}

- (void)addListener:(id)event listener:(id)listener
{
    [self addListener:event listener:listener once:NO];
}

- (void)on:(id)event listener:(id)listener
{
    [self addListener:event listener:listener once:NO];
}

- (void)once:(id)event listener:(id)listener
{
    [self addListener:event listener:listener once:YES];
}

- (void)removeListener:(id)event listener:(id)listener
{
    if (!listener) {
        return;
    }

    [self.eventListeners[event] removeObjectForKey:listener];
}

- (void)removeAllListeners:(id)event
{
    for (id listener in [self.eventListeners[event] copy]) {
        [self removeListener:event listener:listener];
    }
}

- (void)removeAllListeners
{
    for (id event in [self.eventListeners copy]) {
        [self removeAllListeners:event];
    }
}

- (void)emit:(id)event, ...
{
    va_list args;
    va_start(args, event);

    [self emit:event vargs:args];

    va_end(args);
}

- (void)emit:(id)event args:(NSArray *)args
{
    NSDictionary *listeners = [self.eventListeners[event] copy];

    for (id listener in listeners) {
        A2BlockInvocation *blockInvocation = [[A2BlockInvocation alloc] initWithBlock:listener];
        NSMethodSignature *signature = blockInvocation.methodSignature;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];

        for (int i=0; i < MIN(signature.numberOfArguments-2, args.count); i++) {
            id arg = args[i];

            [invocation setArgument:&arg atIndex:i+2];
        }

        [blockInvocation performSelectorOnMainThread:@selector(invokeWithInvocation:) withObject:invocation waitUntilDone:YES];

        // Remove events that are only scheduled to execute once
        if (YES == [listeners[listener] boolValue]) {
            [self removeListener:event listener:listener];
        }
    }
}

- (void)emit:(id)event vargs:(va_list)args
{
    NSDictionary *listeners = [self.eventListeners[event] copy];

    for (id listener in listeners) {
        A2BlockInvocation *blockInvocation = [[A2BlockInvocation alloc] initWithBlock:listener];
        NSMethodSignature *signature = blockInvocation.methodSignature;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];

        [invocation setArgumentsFromArgumentList:args];

        [blockInvocation performSelectorOnMainThread:@selector(invokeWithInvocation:) withObject:invocation waitUntilDone:YES];

        // Remove events that are only scheduled to execute once
        if (YES == [listeners[listener] boolValue]) {
            [self removeListener:event listener:listener];
        }
    }
}

@end
