//
//  Emitter+Blocks.h
//  Emitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(EmitterBlocks)

/**
 *  Adds a listener to the end of the listeners array for the specified event.
 *
 *  @param event     The event.
 *  @param listener  A block to be called when the event is later emitted.
 */
- (void)addListener:(id)event listener:(id)listener;

/**
 *  Adds a listener to the end of the listeners array for the specified event.
 *
 *  @param event     The event.
 *  @param listener  A block to be called when the event is later emitted.
 */
- (void)on:(id)event listener:(id)listener;

/**
 *  Adds a one time listener for the event. This listener is invoked only the next time the event is fired, after which it is removed.
 *
 *  @param event     The event.
 *  @param listener  A block to be called when the event is later emitted.
 */
- (void)once:(id)event listener:(id)listener;

/**
 *  Remove a listener from the listener array for the specified event.
 *
 *  @param event     The event.
 *  @param listener  A reference to a block already registered with this event.
 */
- (void)removeListener:(id)event listener:(id)listener;

/**
 *  Removes all listeners of the specified event.
 *
 *  @param event The event.
 */
- (void)removeAllListeners:(id)event;

/**
 *  Removes all listeners.
 */
- (void)removeAllListeners;

/**
 *  Execute each of the listeners, in order, with the supplied arguments.
 *
 *  @param event     The event.
 *  @param va_args   A list of arguments to be passed to the block.
 */
- (void)emit:(id)event, ...;

/**
 *  Execute each of the listeners, in order, with the supplied arguments as an NSArray.
 *
 *  @param event     The event.
 *  @param NSArray   An array of arguments to be passed to the block.
 */
- (void)emit:(id)event args:(NSArray *)args;

@end
