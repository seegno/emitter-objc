//
//  EventEmitter-Prefix.pch
//  EventEmitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import "EventEmitter.h"

#import <objc/runtime.h>
#import <BlocksKit/A2BlockInvocation.h>
#import <SLObjectiveCRuntimeAdditions/SLBlockDescription.h>

@implementation NSObject(EventEmitter)

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

- (void)addListener:(NSString *)event listener:(id)listener once:(BOOL)once
{
    if (!self.eventListeners[event]) {
        self.eventListeners[event] = [[NSMutableDictionary alloc] init];
    }
    
    self.eventListeners[event][listener] = @(once);
}

- (void)addListener:(NSString *)event listener:(id)listener
{
    [self addListener:event listener:listener once:NO];
}

- (void)on:(NSString *)event listener:(id)listener
{
    [self addListener:event listener:listener once:NO];
}

- (void)once:(NSString *)event listener:(id)listener
{
    [self addListener:event listener:listener once:YES];
}

- (void)removeListener:(NSString *)event listener:(id)listener
{
    [self.eventListeners[event] removeObjectForKey:listener];
}

- (void)removeAllListeners:(NSString *)event
{
    for (id listener in self.eventListeners[event]) {
        [self removeListener:event listener:listener];
    }
}

- (void)removeAllListeners
{
    for (NSString *event in self.eventListeners) {
        [self removeAllListeners:event];
    }
}

- (void)emit:(NSString *)event, ...
{
    va_list args;
    va_start(args, event);
    
    [self emit:event args:args];
    
    va_end(args);
}

- (void)emit:(NSString *)event args:(va_list)args
{
    // Emit event for all registered listeners
    for (id listener in self.eventListeners[event]) {
        NSMethodSignature *signature = [[[SLBlockDescription alloc] initWithBlock:listener] blockSignature];
        A2BlockInvocation *invocation = [[A2BlockInvocation alloc] initWithBlock:listener methodSignature:signature];
        
        // The first argument in a block is a pointer to the block structure, so we start from 1
        for (int i = 1; i < signature.numberOfArguments; i++) {
            const char *type = [signature getArgumentTypeAtIndex:i];
            void *arg;
            
            // Support objects and primitive types as arguments
            if (type[0] == @encode(id)[0]) {
                arg = (__bridge void *)((id)va_arg(args, id));
            }
            else if (type[0] == @encode(char *)[0]) {
                arg = va_arg(args, char *);
            }
            else {
                arg = va_arg(args, int);
            }
            
            [invocation setArgument:&arg atIndex:i - 1];
        }
        
        [invocation invoke];
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
