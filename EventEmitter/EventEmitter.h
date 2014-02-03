//
//  EventEmitter-Prefix.pch
//  EventEmitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(EventEmitter)

- (void)addListener:(NSString *)event listener:(id)listener;

- (void)on:(NSString *)event listener:(id)listener;

- (void)once:(NSString *)event listener:(id)listener;

- (void)removeListener:(NSString *)event listener:(id)listener;

- (void)removeAllListeners:(NSString *)event;

- (void)emit:(NSString *)event, ...;

@end
