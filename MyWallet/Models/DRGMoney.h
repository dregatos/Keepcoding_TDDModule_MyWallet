//
//  DRGMoney.h
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRGMoney;
@class DRGBroker;

@protocol DRGMoney <NSObject>

- (id)initWithAmount:(double)amount andCurrency:(NSString *)currency;
- (id<DRGMoney>)times:(double)multiplier;
- (id<DRGMoney>)plus:(DRGMoney *)other;
- (DRGMoney *)reduceToCurrency:(NSString *)currency withBroker:(DRGBroker *)broker;

@end

@interface DRGMoney : NSObject <DRGMoney>

@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, readonly) NSNumber *amount;

+ (id)euroWithAmount:(double)amount;
+ (id)dollarWithAmount:(double)amount;

@end
