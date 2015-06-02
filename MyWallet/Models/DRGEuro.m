//
//  DRGEuro.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGEuro.h"

@interface DRGEuro ()

@property (nonatomic,readwrite) NSInteger amount;

@end

@implementation DRGEuro

- (instancetype)initWithAmount:(NSInteger)amount {

    if (self = [super init]) {
        _amount = amount;
    }
    return self;
}

- (void)times:(NSInteger)multiplier {
    self.amount *= multiplier;
}


@end
