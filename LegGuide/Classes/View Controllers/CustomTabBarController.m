//
//  CustomTabBarController.m
//  LegGuide
//
//  Created by Matt Galloway on 12/10/13.
//  Copyright (c) 2013 Architactile LLC. All rights reserved.
//

#import "CustomTabBarController.h"
#import "IOS7AdjustmentViewController.h"

@interface CustomTabBarController ()

@property (nonatomic,strong) NSMutableArray *navControllers;

@end

@implementation CustomTabBarController

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    if (self.selectedViewController==viewController) {
        [((IOS7AdjustmentViewController *)viewController) popToRootViewControllerAnimated:YES];
    }
    
    return YES;
    
}

-(void) viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    
    UIColor *wyomingBrown = [UIColor colorWithRed:0.36 green:0.18 blue:0.07 alpha:1.0];
    self.tabBar.tintColor = wyomingBrown;
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = wyomingBrown;
    }
    
    self.navControllers = [NSMutableArray arrayWithCapacity:5];
    
    for (IOS7AdjustmentViewController *vc in self.viewControllers) {
        UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:vc.tabBarItem.title];
        [vc setContentController:nc];
    }
}


@end
