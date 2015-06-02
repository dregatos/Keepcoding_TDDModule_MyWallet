//
//  DRGMoney.h
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

/** THIS IS AN ABSTRACT CLASS. A SUPERCLASS TO CREATE */

@interface DRGMoney : NSObject

- (instancetype)initWithAmount:(NSInteger)amount;
- (DRGMoney *)times:(NSInteger)multiplier;

@end
