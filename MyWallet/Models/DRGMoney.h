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

@property (nonatomic, readonly) NSString *currency;

+ (id)euroWithAmount:(NSInteger)amount;
+ (id)dollarWithAmount:(NSInteger)amount;

- (instancetype)initWithAmount:(NSInteger)amount andCurrency:(NSString *)currency;

// Operations
- (DRGMoney *)times:(NSInteger)multiplier;
- (DRGMoney *)plus:(DRGMoney *)other;

@end
