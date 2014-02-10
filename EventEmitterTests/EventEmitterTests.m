//
//  EventEmitter-Prefix.pch
//  EventEmitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import "EventEmitter.h"

SpecBegin(EventEmitter)

__block NSObject *emitter;

describe(@"emit:", ^{
    beforeEach(^{
        emitter = [[NSObject alloc] init];
    });
    
    it(@"notifies listener", ^AsyncBlock {
        [emitter on:@"key" listener:^{
            done();
        }];
        
        [emitter emit:@"key"];
    });
    
    it(@"notifies listener multiple times", ^{
        __block int times = 0;
        
        [emitter on:@"key" listener:^{
            times++;
        }];
        
        [emitter emit:@"key"];
        [emitter emit:@"key"];
        
        expect(times).to.equal(2);
    });
    
    it(@"notifies listener only once", ^{
        __block int times = 0;
        
        [emitter once:@"key" listener:^{
            times++;
        }];
        
        [emitter emit:@"key"];
        [emitter emit:@"key"];
        
        expect(times).to.equal(1);
    });
    
    it(@"notifies listener with one parameter", ^AsyncBlock {
        [emitter on:@"key" listener:^(NSArray *value) {
            done();
        }];
        
        [emitter emit:@"key", @[@"one", @"two"]];
    });
    
    it(@"notifies listener with two parameters", ^AsyncBlock {
        [emitter on:@"key" listener:^(BOOL param1, NSString *param2) {
            done();
        }];
        
        [emitter emit:@"key", YES, @"two"];
    });
    
    it(@"notifies listener and ignores extra parameters", ^AsyncBlock {
        [emitter on:@"key" listener:^(id param1, BOOL param2){
            done();
        }];
        
        [emitter emit:@"key"];
    });
    
    it(@"removes listener", ^{
        id listener = ^{
            XCTFail(@"listener should not fire");
        };
        
        [emitter on:@"key" listener:listener];
        
        [emitter removeListener:@"key" listener:listener];
        
        [emitter emit:@"key"];
    });
    
    it(@"removes all listeners for an event", ^{
        id listener = ^{
            XCTFail(@"listener should not fire");
        };
        
        [emitter on:@"key" listener:listener];
        
        [emitter removeAllListeners:@"key"];
        
        [emitter emit:@"key"];
    });

    
    it(@"removes all listeners", ^{
        id listener = ^{
            XCTFail(@"listener should not fire");
        };
        
        [emitter on:@"key" listener:listener];
        
        [emitter removeAllListeners];
        
        [emitter emit:@"key"];
    });
});

SpecEnd