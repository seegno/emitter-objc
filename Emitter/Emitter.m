//
//  Emitter-Prefix.pch
//  Emitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <objc/runtime.h>
#import <BlocksKit/A2BlockInvocation.h>
#import <SLObjectiveCRuntimeAdditions/SLBlockDescription.h>

#import "A2BlockInvocation+EXT.h"
#import "Emitter.h"

@implementation NSObject(Emitter)

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

    [self emit:event args:args];

    va_end(args);
}

- (void)emit:(id)event args:(va_list)args
{
    // Emit event for all registered listeners
    for (id listener in self.eventListeners[event]) {
        NSMethodSignature *signature = [[[SLBlockDescription alloc] initWithBlock:listener] blockSignature];
        A2BlockInvocation *blockInvocation = [[A2BlockInvocation alloc] initWithBlock:listener methodSignature:signature];

        [blockInvocation setArgumentsFromArgumentList:args];
        [blockInvocation invoke];
    }

    // Remove events that are only scheduled to execute once
    NSSet *eventsToRemove = [self.eventListeners[event] keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return YES == [obj boolValue];
    }];

    for (NSDictionary *listener in eventsToRemove) {
        [self removeListener:event listener:listener];
    }
}

@end
