//
//  DRGDollar.h
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRGDollar : NSObject

- (instancetype)initWithAmount:(NSInteger)amount;
- (DRGDollar *)times:(NSInteger)multiplier;

@end
