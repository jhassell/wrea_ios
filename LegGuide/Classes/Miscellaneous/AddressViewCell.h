//
//  AddressViewCell.h
//  OAECLegGuide
//
//  Created by Matt Galloway on 8/3/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonViewController.h"

@interface AddressViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *addressLine1;
@property (strong, nonatomic) IBOutlet UILabel *addressLine2;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *emailAddress;

@property (strong, nonatomic) IBOutlet UIButton *phoneInvisibleButton;
@property (strong, nonatomic) IBOutlet UIButton *emailInvisibleButton;
@property (strong, nonatomic) IBOutlet UIButton *phoneButton;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;

@property (strong, nonatomic) NSString *phoneNumberToDial;

@property (nonatomic, weak) PersonViewController *pvc;

- (IBAction)dial:(id)sender;
- (IBAction)email:(id)sender;
- (IBAction)mapButtonPressed:(id)sender;

@end
