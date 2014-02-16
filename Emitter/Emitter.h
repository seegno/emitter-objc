//
//  Emitter-Prefix.pch
//  Emitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Emitter)

/**
 * Adds a listener to the end of the listeners array for the specified event.
 *
 * @param event     The name of the event.
 * @param listener  A block to be called when the event is later emitted.
 */
- (void)addListener:(NSString *)event listener:(id)listener;

/**
 * Adds a listener to the end of the listeners array for the specified event.
 *
 * @param event     The name of the event.
 * @param listener  A block to be called when the event is later emitted.
 */
- (void)on:(NSString *)event listener:(id)listener;

/**
 * Adds a one time listener for the event. This listener is invoked only the next time the event is fired, after which it is removed.
 *
 * @param event     The name of the event.
 * @param listener  A block to be called when the event is later emitted.
 */
- (void)once:(NSString *)event listener:(id)listener;

/**
 * Remove a listener from the listener array for the specified event.
 *
 * @param event     The name of the event.
 * @param listener  A reference to a block already registered with this event.
 */
- (void)removeListener:(NSString *)event listener:(id)listener;

/**
 * Removes all listeners of the specified event.
 *
 * @param event The name of the event.
 */
- (void)removeAllListeners:(NSString *)event;

/**
 * Removes all listeners.
 */
- (void)removeAllListeners;

/**
 * Execute each of the listeners in order with the supplied arguments.
 *
 * @param event     The name of the event.
 * @param va_args   A list of arguments to be passed to the block.
 */
- (void)emit:(NSString *)event, ...;

@end
