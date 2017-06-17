//
//  VotingListViewController.h
//  OAECLegGuide
//
//  Created by User on 5/15/17.
//  Copyright © 2017 Architactile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Committee;

@interface VotingListViewController : UIViewController <UISearchBarDelegate>

@property (nonatomic, strong) NSArray *rc_sections;
@property (nonatomic, strong) Committee *rc_committee;

@end
