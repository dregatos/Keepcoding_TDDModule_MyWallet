//
//  DRGWalletTableVC.h
//  MyWallet
//
//  Created by David Regatos on 05/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRGWallet;
@class DRGBroker;

@interface DRGWalletTableVC : UITableViewController

- (instancetype)initWithBroker:(DRGBroker *)aBroker andWallet:(DRGWallet *)aWallet;

@end
