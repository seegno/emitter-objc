//
//  Emitter+SelectorsTests.m
//  Emitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import "Emitter.h"

@interface TestObject : NSObject

- (void)listener;
- (void)listenerWithParam1:(id)value1;
- (void)listenerWithParam1:(id)value1 param2:(id)value2;

@end

@implementation TestObject

- (void)listener {}
- (void)listenerWithParam1:(id)value1 {}
- (void)listenerWithParam1:(id)value1 param2:(id)value2 {}

@end

SpecBegin(EmitterSelectors)

__block NSObject *emitter;
__block TestObject *target1;
__block TestObject *target2;

beforeEach(^{
    emitter = [[NSObject alloc] init];
    target1 = mock(TestObject.class);
    target2 = mock(TestObject.class);
});

describe(@"emit:", ^{
    it(@"notifies selector", ^ {
        [emitter on:@"key" selector:@selector(listener) target:target1];
        
        [emitter emit:@"key"];

        [verify(target1) listener];
    });
    
    it(@"notifies listener multiple times", ^{
        [emitter on:@"key" selector:@selector(listener) target:target1];
        
        [emitter emit:@"key"];
        [emitter emit:@"key"];

        [verifyCount(target1, times(2)) listener];
    });
    
    it(@"notifies listener only once", ^{
        [emitter once:@"key" selector:@selector(listener) target:target1];
        
        [emitter emit:@"key"];
        [emitter emit:@"key"];

        [verifyCount(target1, times(1)) listener];
    });
    
    it(@"notifies listener with one parameter", ^{
        NSArray *param1 = @[@"one", @"two"];

        [emitter on:@"key" selector:@selector(listenerWithParam1:) target:target1];

        [emitter emit:@"key", param1];

        [verify(target1) listenerWithParam1:param1];
    });
    
    it(@"notifies listener with two parameters", ^{
        [emitter on:@"key" selector:@selector(listenerWithParam1:param2:) target:target1];

        [emitter emit:@"key", @1, @"two"];

        [verify(target1) listenerWithParam1:@1 param2:@"two"];
    });
    
    it(@"notifies listener with two parameters multiple times", ^{
        __block int expected = 1000;

        [emitter on:@"key" selector:@selector(listenerWithParam1:param2:) target:target1];

        for(int i=0; i < expected; i++) {
            [emitter emit:@"key", @"example-parameter", @(expected)];
        }

        [verifyCount(target1, times(expected)) listenerWithParam1:@"example-parameter" param2:@(expected)];
    });

    it(@"notifies multiple listeners with one parameter", ^{
        NSString *param = @"example-parameter";

        [emitter on:@"key" selector:@selector(listenerWithParam1:) target:target1];
        [emitter on:@"key" selector:@selector(listenerWithParam1:) target:target2];

        [emitter emit:@"key", param];

        [verify(target1) listenerWithParam1:param];
        [verify(target2) listenerWithParam1:param];
    });

    it(@"notifies listener with an array of arguments", ^{
        NSString *param1 = @"example-parameter";
        NSNumber *param2 = @123;

        [emitter on:@"key" selector:@selector(listenerWithParam1:param2:) target:target1];

        [emitter emit:@"key" args:@[param1, param2]];

        [verify(target1) listenerWithParam1:param1 param2:param2];
    });
});

describe(@"removeListener:", ^{
    it(@"removes listener", ^{
        [emitter on:@"key" selector:@selector(listener) target:target1];
        
        [emitter removeListener:@"key" selector:@selector(listener) target:target1];
        
        [emitter emit:@"key"];

        [verifyCount(target1, never()) listener];
    });

    it(@"removes listener while iterating listeners", ^{
        [emitter on:@"key" selector:@selector(listener) target:target1];
        [emitter on:@"key2" listener:^{
            [emitter removeListener:@"key" selector:@selector(listener) target:target1];
        }];

        [emitter removeListener:@"key" selector:@selector(listener) target:target1];

        [emitter emit:@"key2"];
        [emitter emit:@"key"];

        [verifyCount(target1, never()) listener];
    });
    
    it(@"removes all listeners for an event", ^{
        [emitter on:@"key" selector:@selector(listener) target:target1];

        [emitter removeAllListeners:@"key"];

        [emitter emit:@"key"];

        [verifyCount(target1, never()) listener];
    });

    it(@"removes all listeners for multiple events", ^{
        [emitter on:@"key" selector:@selector(listener) target:target1];
        [emitter on:@"key" selector:@selector(listener) target:target2];

        [emitter removeAllListeners:@"key"];

        [emitter emit:@"key"];

        [verifyCount(target1, never()) listener];
        [verifyCount(target2, never()) listener];
    });

    it(@"removes all listeners", ^{
        [emitter on:@"key" selector:@selector(listener) target:target1];
        [emitter on:@"key" selector:@selector(listener) target:target2];

        [emitter removeAllListeners];

        [emitter emit:@"key"];

        [verifyCount(target1, never()) listener];
        [verifyCount(target2, never()) listener];
    });
});

SpecEnd