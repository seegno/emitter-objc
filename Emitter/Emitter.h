//
//  Emitter-Prefix.pch
//  Emitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Emitter)

- (void)addListener:(NSString *)event listener:(id)listener;

- (void)on:(NSString *)event listener:(id)listener;

- (void)once:(NSString *)event listener:(id)listener;

- (void)removeListener:(NSString *)event listener:(id)listener;

- (void)removeAllListeners:(NSString *)event;

- (void)removeAllListeners;

- (void)emit:(NSString *)event, ...;

@end
