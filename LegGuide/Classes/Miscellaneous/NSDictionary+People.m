//
//  NSDictionary+People.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/27/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import "NSDictionary+People.h"
#import "Definitions.h"

@implementation NSDictionary (People)

-(NSString *) type {
    return [self objectForKey:@"Type"];
}

-(NSString *) photo {
    return [self objectForKey:@"Photo"];
}

-(NSString *) lastName {
    return [self objectForKey:@"Last Name"];
}

-(NSString *) firstName {
    return [self objectForKey:@"First Name"];
}

-(NSString *) districtNumber {
    return [self objectForKey:@"District #"];
}

-(NSString *) party {
    return [self objectForKey:@"Party"];
}

-(NSString *) titleLeadership {
    return [self objectForKey:@"Title/leadership"];
}

-(NSString *) email {
    return [self objectForKey:@"E-mail"];
}

-(NSString *) webpage {
    return [self objectForKey:@"Website"];
}

-(NSString *) twitter {
    return [self objectForKey:@"Twitter"];
}

-(NSString *) facebook {
    return [self objectForKey:@"Facebook"];
}

-(NSString *) linkedIn {
    return [self objectForKey:@"LinkedIn"];
}

-(NSString *) termLimit {
    return [self objectForKey:@"Term limit"];
}

-(NSString *) yearsServed {
    return [self objectForKey:@"Years Served"];
}

-(NSString *) countiesCovered {
    return [self objectForKey:@"Counties covered"];
}

-(NSString *) standingCommittee {
    return [self objectForKey:STANDING];
}

-(NSString *) appropriationsSubcommittee {
    return [self objectForKey:APPROPRIATIONS];
}

-(NSString *) officeAddress {
    return [self objectForKey:@"Office address"];
}

-(NSString *) officeCity {
    return [self objectForKey:@"Office city"];
}

-(NSString *) officeState {
    return [self objectForKey:@"Office state"];
}

-(NSString *) officeZip {
    return [self objectForKey:@"Office zip"];
}

-(NSString *) officeRmNumber {
    return [self objectForKey:@"Office Rm #"];
}

-(NSString *) officePhone {
    return [self objectForKey:@"Office Phone"];
}

-(NSString *) homePhone {
    return [self objectForKey:@"Home Phone"];
}

-(NSString *) cellPhone {
    return [self objectForKey:@"Cell Phone"];
}

-(NSString *) tollFreePhone {
    return [self objectForKey:@"Toll Free"];
}

-(NSString *) homeAddress {
    return [self objectForKey:@"Home address"];
}

-(NSString *) homeCity {
    return [self objectForKey:@"Home city"];
}

-(NSString *) homeState {
    return [self objectForKey:@"Home state"];
}

-(NSString *) homeZip {
    return [self objectForKey:@"Home zip"];
}

-(NSString *) laName {
    return [self objectForKey:@"LA name"];
}

-(NSString *) predecessor {
    return [self objectForKey:@"Predecessor"];
}

-(NSMutableArray *) committees {
    return [self objectForKey:COMMITTEES_ARRAY_KEY];
}

-(NSString *) coopName {
    return [self objectForKey:@"Cooperative Name"];
}

-(NSString *) coopLogoFilename {
    return [self objectForKey:@"Cooperative Logo Filename"];
}

-(NSString *) milesOfLines {
    return [self objectForKey:@"Miles of Line"];
}

-(NSString *) activeMeters {
    return [self objectForKey:@"Active Meters"];
}

-(NSString *) employees {
    return [self objectForKey:@"Employees"];
}

-(NSString *) activeMetersMiles {
    return [self objectForKey:@"Active Meters/Mile"];
}

-(NSString *) coopType {
    return [self objectForKey:@"Co-op Type"];
}

-(NSString *) coopRegionName {
    return [self objectForKey:@"Co-op Region Name"];
}

-(NSString *) bio {
    return [self objectForKey:@"Bio"];
}

-(NSString *) coopBoard {
    return [self objectForKey:@"Co-op Board"];
}



-(int) sortOrder {
    return [[self objectForKey:@"Sort Order"] intValue];
}

@end
