//
//  DRGMoneyVC.h
//  MyWallet
//
//  Created by David Regatos on 07/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRGMoneyVC : UIViewController

@property (nonatomic, getter = isAdding) BOOL adding;

@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UITextField *inputTxtField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *currencyControl;

@end
