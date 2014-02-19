//
//  A2BlockInvocation+EXT.h
//  Emitter
//
//  Created by Nuno Sousa on 19/02/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//
//  Original implementation from libextobjc: https://github.com/jspahrsummers/libextobjc
//

#import "A2BlockInvocation.h"

@interface A2BlockInvocation (EXT)

- (BOOL)setArgumentsFromArgumentList:(va_list)cargs;

@end
