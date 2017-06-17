//
//  Committee.h
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/30/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Committee : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *dow;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *website;

@end
