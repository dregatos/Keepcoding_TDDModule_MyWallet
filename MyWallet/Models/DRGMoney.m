//
//  DRGMoney.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGMoney.h"
#import "NSObject+GNUStepAddons.h"

@interface DRGMoney ()

@property (nonatomic) NSInteger amount;

@end

@implementation DRGMoney

- (instancetype)initWithAmount:(NSInteger)amount {
    
    if (self = [super init]) {
        _amount = amount;
    }
    return self;
}

- (DRGMoney *)times:(NSInteger)multiplier {
    
    // Mustn't be called. NEVER. Must be handled by the subclass
    return [self subclassResponsability:_cmd];
}

#pragma mark - Overwritten

- (NSString *)description {
    NSString *objDescription = [NSString stringWithFormat:@"%ld", (long)self.amount]; //Wrap the custom description here.
    return [NSString stringWithFormat:@"<%@: %@>", [self class], objDescription];
}

- (BOOL)isEqual:(id)object {
    
    if (self && object) {
        return  [self amount] == [object amount];
    }
    
    return NO;
}

- (NSUInteger)hash {
    
    return [self amount];
}


@end
