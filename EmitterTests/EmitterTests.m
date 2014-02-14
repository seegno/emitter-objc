//
//  Emitter-Prefix.pch
//  Emitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import "Emitter.h"

SpecBegin(Emitter)

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
        NSArray *param1 = @[@"one", @"two"];

        [emitter on:@"key" listener:^(NSArray *value) {
            expect(value).to.equal(param1);

            done();
        }];
        
        [emitter emit:@"key", param1];
    });
    
    it(@"notifies listener with two parameters", ^AsyncBlock {
        [emitter on:@"key" listener:^(BOOL param1, NSString *param2) {
            expect(param1).to.equal(YES);
            expect(param2).to.equal(@"two");

            done();
        }];
        
        [emitter emit:@"key", YES, @"two"];
    });
    
    it(@"notifies listener with two parameters multiple times", ^AsyncBlock {
        NSString *param = @"example-parameter";

        __block int times = 0;
        __block int expected = 1000;

        [emitter on:@"key" listener:^(NSString *value, int i) {
            expect(value).to.equal(param);
            expect(i).to.equal(times);

            if (++times == expected) {
                done();
            };
        }];

        for(int i=0; i < expected; i++) {
            [emitter emit:@"key", param, i];
        }
    });
    
    it(@"notifies listener and ignores extra parameters", ^AsyncBlock {
        [emitter on:@"key" listener:^(int param1, BOOL param2){
            done();
        }];
        
        [emitter emit:@"key"];
    });

    it(@"notifies listener and sets extra object parameters to nil", ^AsyncBlock {
        [emitter on:@"key" listener:^(id param1, BOOL param2){
            expect(param1).to.beNil();

            done();
        }];

        [emitter emit:@"key"];
    });

    it(@"notifies listener and sets invalid parameter to nil", ^AsyncBlock {
        NSString *param = @"example-parameter";

        [emitter on:@"key" listener:^(NSArray *param){
            expect(param).to.beNil();

            done();
        }];

        [emitter emit:@"key", param];
    });

    it(@"notifies multiple listeners with one parameter", ^AsyncBlock {
        NSString *param = @"example-parameter";

        __block BOOL listener1;
        __block BOOL listener2;

        [emitter on:@"key" listener:^(NSString *value) {
            listener1 = YES;

            expect(value).to.equal(param);

            if (listener1 && listener2) {
                done();
            }
        }];

        [emitter on:@"key" listener:^(NSString *value) {
            listener2 = YES;

            expect(value).to.equal(param);

            if (listener1 && listener2) {
                done();
            }
        }];

        [emitter emit:@"key", param];
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