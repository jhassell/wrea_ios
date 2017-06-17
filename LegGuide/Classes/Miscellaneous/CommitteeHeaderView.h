//
//  CommitteeHeaderView.h
//  LegGuide
//
//  Created by Matt Galloway on 1/26/14.
//  Copyright (c) 2014 Architactile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitteeHeaderView : UITableViewCell;

@property (strong, nonatomic) IBOutlet UILabel *chamberLabel;
@property (strong, nonatomic) IBOutlet UILabel *committeeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *meetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomLabel;
@property (strong, nonatomic) IBOutlet UILabel *committeeSubtypeLabel;


@property (strong, nonatomic) IBOutlet UILabel *meetsLabelLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomLabelLabel;




@end
