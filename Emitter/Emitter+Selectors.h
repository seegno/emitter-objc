//
//  Emitter+Selectors.h
//  Emitter
//
//  Created by Nuno Sousa on 2/1/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//

@interface NSObject(EmitterSelectors)

/**
 *  Adds an event listener that will trigger a selector on a given target.
 *
 *  @param event    The event to listen to.
 *  @param selector The selector that will be called.
 *  @param target   The target object.
 */
- (void)addListener:(id)event selector:(SEL)selector target:(__weak id)target;

/**
 *  Adds an event listener that will trigger a selector on a given target.
 *
 *  @param event    The event to listen to.
 *  @param selector The selector that will be called.
 *  @param target   The target object.
 */
- (void)on:(id)event selector:(SEL)selector target:(__weak id)target;

/**
 *  Adds an event listener that will only trigger a selector on a given target once.
 *
 *  @param event    The event to listen to.
 *  @param selector The selector that will be called.
 *  @param target   The target object.
 */
- (void)once:(id)event selector:(SEL)selector target:(__weak id)target;

/**
 *  Removes an event listener for a selector on a given target.
 *
 *  @param event    The event to remove.
 *  @param selector The selector.
 *  @param target   The target.
 */
- (void)removeListener:(id)event selector:(SEL)selector target:(__weak id)target;

@end
