//
//  DRGDollar.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGDollar.h"

@interface DRGDollar ()

@property (nonatomic) NSInteger amount;

@end

@implementation DRGDollar

- (instancetype)initWithAmount:(NSInteger)amount {
    
    if (self = [super init]) {
        _amount = amount;
    }
    return self;
}

- (DRGDollar *)times:(NSInteger)multiplier {
    DRGDollar *newDollar = [[DRGDollar alloc] initWithAmount:self.amount * multiplier];
    return newDollar;
}


#pragma mark - Overwritten

- (BOOL)isEqual:(id)object {
    
    if (self && object) {
        return  [self amount] == [object amount];
    }
    
    return NO;
}


@end
