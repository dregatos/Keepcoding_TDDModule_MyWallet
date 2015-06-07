//
//  AppDelegate.m
//  MyWallet
//
//  Created by David Regatos on 01/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "AppDelegate.h"

#import "DRGWallet.h"
#import "DRGBroker.h"
#import "DRGWalletTableVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    DRGBroker *myBroker = [[DRGBroker alloc] init];
    // TODO: Add more currencies. For now only works with EUR, USD and GBP
    [myBroker addRate:1.11178 fromCurrency:@"EUR" toCurrency:@"USD"];
    [myBroker addRate:1.37364 fromCurrency:@"GBP" toCurrency:@"EUR"];
    [myBroker addRate:1.52722 fromCurrency:@"GBP" toCurrency:@"USD"];

    DRGWallet *myWallet = [[DRGWallet alloc] init];
//    [self addDummyDataToWallet:myWallet];
    
    DRGWalletTableVC *tableVC = [[DRGWalletTableVC alloc] initWithBroker:myBroker andWallet:myWallet];
    
    // Configure window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:tableVC];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helpers

- (void)addDummyDataToWallet:(DRGWallet *)aWallet {
    [aWallet addMoney:[[DRGMoney alloc] initWithAmount:10 andCurrency:@"EUR"]];
    [aWallet addMoney:[[DRGMoney alloc] initWithAmount:12.25 andCurrency:@"EUR"]];
    [aWallet addMoney:[[DRGMoney alloc] initWithAmount:2.05 andCurrency:@"EUR"]];
    [aWallet addMoney:[[DRGMoney alloc] initWithAmount:100 andCurrency:@"USD"]];
    [aWallet addMoney:[[DRGMoney alloc] initWithAmount:3.5 andCurrency:@"USD"]];
    [aWallet addMoney:[[DRGMoney alloc] initWithAmount:22.75 andCurrency:@"USD"]];
    [aWallet addMoney:[[DRGMoney alloc] initWithAmount:11 andCurrency:@"GBP"]];
    [aWallet addMoney:[[DRGMoney alloc] initWithAmount:6.45 andCurrency:@"GBP"]];
    [aWallet addMoney:[[DRGMoney alloc] initWithAmount:29 andCurrency:@"GBP"]];
}


@end
