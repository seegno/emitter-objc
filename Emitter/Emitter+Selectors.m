//
//  Emitter+Selectors.m
//  Emitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <objc/runtime.h>

#import "Emitter+Blocks.h"
#import "Emitter+Selectors.h"

@implementation NSObject(EmitterEmitterBlocks)

- (NSMutableDictionary *)eventSelectors
{
    @synchronized(self)
    {
        NSMutableDictionary *_eventSelectors = objc_getAssociatedObject(self, @"eventSelectors");

        if (!_eventSelectors) {
            _eventSelectors = [[NSMutableDictionary alloc] init];

            objc_setAssociatedObject(self, @"eventSelectors", _eventSelectors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        return _eventSelectors;
    }
}

- (void)addListener:(id)event selector:(SEL)selector target:(id)target once:(BOOL)once
{
    if ([self selectorWithEvent:event selector:selector target:target]) {
        return;
    }

    id block = ^(void *first, void *second, void *third, void *fourth, void *fifth, void *sixth, void *seventh, void *eighth, void *nineth, void *tenth) {
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];

        [invocation setTarget:target];
        [invocation setSelector:selector];

        void *args[] = { first, second, third, fourth, fifth, sixth, seventh, eighth, nineth, tenth };

        // Set all arguments (skip the first two arguments -- `self` and `_cmd`)
        for (int i=2; i < signature.numberOfArguments; i++) {
            [invocation setArgument:&(args[i-2]) atIndex:i];
        }

        [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
    };

    if (! self.eventSelectors[event]) {
        self.eventSelectors[event] = [[NSMutableArray alloc] init];
    }

    [self.eventSelectors[event] addObject:@{
        @"selector": NSStringFromSelector(selector),
        @"target": target,
        @"block": block
    }];

    if (once) {
        [self once:event listener:block];
    } else {
        [self on:event listener:block];
    }
}

- (void)addListener:(id)event selector:(SEL)selector target:(id)target
{
    [self addListener:event selector:selector target:target once:NO];
}

- (void)on:(id)event selector:(SEL)selector target:(id)target
{
    [self addListener:event selector:selector target:target once:NO];
}

- (void)once:(id)event selector:(SEL)selector target:(id)target
{
    [self addListener:event selector:selector target:target once:YES];
}

- (void)removeListener:(id)event selector:(SEL)selector target:(id)target
{
    NSDictionary *listener = [self selectorWithEvent:event selector:selector target:target];

    [self removeListener:event listener:listener[@"block"]];

    [self.eventSelectors[event] removeObject:listener];

    if (0 == [self.eventSelectors[event] count]) {
        [self.eventSelectors removeObjectForKey:event];
    }
}

- (NSDictionary *)selectorWithEvent:(id)event selector:(SEL)selector target:(id)target
{
    NSUInteger index = [self.eventSelectors[event] indexOfObjectPassingTest:^BOOL(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        return target == obj[@"target"] && [NSStringFromSelector(selector) isEqualToString:obj[@"selector"]];
    }];

    if (index == NSNotFound) {
        return nil;
    }

    return self.eventSelectors[event][index];
}

@end
