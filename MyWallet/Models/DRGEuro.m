//
//  DRGEuro.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGEuro.h"

@interface DRGEuro ()

@property (nonatomic) NSInteger amount;

@end

@implementation DRGEuro

- (instancetype)initWithAmount:(NSInteger)amount {

    if (self = [super init]) {
        _amount = amount;
    }
    return self;
}

- (DRGEuro *)times:(NSInteger)multiplier {
    DRGEuro *newEuro = [[DRGEuro alloc] initWithAmount:self.amount * multiplier];
    return newEuro;
}


#pragma mark - Overwritten

- (BOOL)isEqual:(id)object {
    
    if (self && object) {
        return  [self amount] == [object amount];
    }
    
    return NO;
}


@end
