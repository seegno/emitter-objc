//
//  NSInvocation+BlockArguments.h
//  Emitter
//
//  Created by Nuno Sousa on 19/02/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//
//  Original implementation from libextobjc: https://github.com/jspahrsummers/libextobjc
//

#import <Foundation/Foundation.h>

@interface NSInvocation (BlockArguments)

- (BOOL)setArgumentsFromArgumentList:(va_list)cargs;

@end
