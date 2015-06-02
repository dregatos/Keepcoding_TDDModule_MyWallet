//
//  NSObject+GNUStepAddons.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import ObjectiveC;
#import "NSObject+GNUStepAddons.h"

@implementation NSObject (GNUStepAddons)

- (id)subclassResponsability:(SEL)aSel {
    
    char prefix = class_isMetaClass(object_getClass(self)) ? '+' : '-';
    NSString *className = NSStringFromClass([self class]);
    NSString *selectorName = NSStringFromSelector(aSel);
    [NSException raise: NSInvalidArgumentException format:@"%@%c%@ should be overriden by its subclass",className , prefix, selectorName];
    
    return self; // not reached
}

@end
