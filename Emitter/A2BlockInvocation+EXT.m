//
//  A2BlockInvocation+EXT.m
//  Emitter
//
//  Created by Nuno Sousa on 19/02/14.
//  Copyright (c) 2014 Seegno. All rights reserved.
//
//  Original implementation from libextobjc: https://github.com/jspahrsummers/libextobjc
//

#import "A2BlockInvocation+EXT.h"

typedef struct { int i; } *empty_struct_ptr_t;
typedef union { int i; } *empty_union_ptr_t;

@implementation A2BlockInvocation (EXT)

- (BOOL)setArgumentsFromArgumentList:(va_list)args
{
    va_list cargs;

    va_copy(cargs, args);

    NSMethodSignature *signature = [self methodSignature];
    NSUInteger skip = 1;
    NSUInteger count = [signature numberOfArguments];

    for (NSUInteger i = skip;i < count;++i) {
        const char *type = [signature getArgumentTypeAtIndex:i];
        while (
               *type == 'r' ||
               *type == 'n' ||
               *type == 'N' ||
               *type == 'o' ||
               *type == 'O' ||
               *type == 'R' ||
               *type == 'V'
               ) {
            ++type;
        }

        switch (*type) {
            case 'c':
            {
                char val = (char)va_arg(cargs, int);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'i':
            {
                int val = va_arg(cargs, int);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 's':
            {
                short val = (short)va_arg(cargs, int);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'l':
            {
                long val = va_arg(cargs, long);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'q':
            {
                long long val = va_arg(cargs, long long);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'C':
            {
                unsigned char val = (unsigned char)va_arg(cargs, unsigned int);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'I':
            {
                unsigned int val = va_arg(cargs, unsigned int);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'S':
            {
                unsigned short val = (unsigned short)va_arg(cargs, unsigned int);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'L':
            {
                unsigned long val = va_arg(cargs, unsigned long);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'Q':
            {
                unsigned long long val = va_arg(cargs, unsigned long long);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'f':
            {
                float val = (float)va_arg(cargs, double);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'd':
            {
                double val = va_arg(cargs, double);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case 'B':
            {
                _Bool val = (_Bool)va_arg(cargs, int);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case '*':
            {
                char *val = va_arg(cargs, char *);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case '@':
            {
                __unsafe_unretained id val = va_arg(cargs, id);
                [self setArgument:&val atIndex:i-skip];

                if (type[1] == '?') {
                    // @? is undocumented, but apparently used to represent
                    // a block -- not sure how to disambiguate it from
                    // a separate @ and ?, but I assume that a block parameter
                    // is a more common case than that
                    ++type;
                }
            }

                break;

            case '#':
            {
                Class val = va_arg(cargs, Class);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case ':':
            {
                SEL val = va_arg(cargs, SEL);
                [self setArgument:&val atIndex:i-skip];
            }

                break;

            case '[':
                NSLog(@"Unexpected array within method argument type code \"%s\", cannot set invocation argument!", type);
                va_end(cargs);
                return NO;

            case 'b':
                NSLog(@"Unexpected bitfield within method argument type code \"%s\", cannot set invocation argument!", type);
                va_end(cargs);
                return NO;

            case '{':
                NSLog(@"Cannot get variable argument for a method that takes a struct argument!");
                va_end(cargs);
                return NO;

            case '(':
                NSLog(@"Cannot get variable argument for a method that takes a union argument!");
                va_end(cargs);
                return NO;

            case '^':
                switch (type[1]) {
                    case 'c':
                    case 'C':
                    {
                        char *val = va_arg(cargs, char *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case 'i':
                    case 'I':
                    {
                        int *val = va_arg(cargs, int *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case 's':
                    case 'S':
                    {
                        short *val = va_arg(cargs, short *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case 'l':
                    case 'L':
                    {
                        long *val = va_arg(cargs, long *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case 'q':
                    case 'Q':
                    {
                        long long *val = va_arg(cargs, long long *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case 'f':
                    {
                        float *val = va_arg(cargs, float *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case 'd':
                    {
                        double *val = va_arg(cargs, double *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case 'B':
                    {
                        _Bool *val = va_arg(cargs, _Bool *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case 'v':
                    {
                        void *val = va_arg(cargs, void *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case '*':
                    case '@':
                    case '#':
                    case '^':
                    case '[':
                    {
                        void **val = va_arg(cargs, void **);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case ':':
                    {
                        SEL *val = va_arg(cargs, SEL *);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case '{':
                    {
                        empty_struct_ptr_t val = va_arg(cargs, empty_struct_ptr_t);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case '(':
                    {
                        empty_union_ptr_t val = va_arg(cargs, empty_union_ptr_t);
                        [self setArgument:&val atIndex:i-skip];
                    }

                        break;

                    case '?':
                    {
                        // assume that this is a pointer to a function pointer
                        //
                        // even if it's not, the fact that it's
                        // a pointer-to-something gives us a good chance of not
                        // causing alignment or size problems
                        IMP *ptr = va_arg(cargs, IMP *);
                        [self setArgument:&ptr atIndex:i-skip];
                    }
                        
                        break;
                        
                    case 'b':
                    default:
                        NSLog(@"Pointer to unexpected type within method argument type code \"%s\", cannot set method invocation!", type);
                        va_end(cargs);
                        return NO;
                }
                
                break;
                
            case '?':
            {
                // this is PROBABLY a function pointer, but the documentation
                // leaves room open for uncertainty, so at least log a message
                NSLog(@"Assuming method argument type code \"%s\" is a function pointer", type);
                
                IMP ptr = va_arg(cargs, IMP);
                [self setArgument:&ptr atIndex:i-skip];
            }
                
                break;
                
            default:
                NSLog(@"Unexpected method argument type code \"%s\", cannot set method invocation!", type);
                va_end(cargs);
                return NO;
        }
    }

    va_end(cargs);
    
    return YES;
}
@end
