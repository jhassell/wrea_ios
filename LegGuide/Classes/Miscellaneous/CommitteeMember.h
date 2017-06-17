//
//  CommitteeMember.h
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/30/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Committee.h"

@interface CommitteeMember : NSObject

@property (nonatomic, strong) NSDictionary *person;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *sortTitle;
@property (nonatomic, strong) Committee *committee;

@end
