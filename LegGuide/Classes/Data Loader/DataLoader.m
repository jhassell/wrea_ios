//
//  DataLoader.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/26/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import "DataLoader.h"
#import "CSVParser.h"
#import "Committee.h"
#import "CommitteeMember.h"
#import "NSDictionary+People.h"
#import "NSString+Stuff.h"
#import "Definitions.h"

@implementation DataLoader

+(NSArray *) loadCSVFile:(NSString *) csvPath {
    
    NSError *error;
	NSString *csvString = [NSString stringWithContentsOfFile:csvPath encoding:NSUTF8StringEncoding error:&error];
    
	if (!csvString)
	{
		printf("Couldn't read file at path %s\n. Error: %s",
               [csvPath UTF8String],
               [[error localizedDescription] ? [error localizedDescription] : [error description] UTF8String]);
        return nil;
	}
	
	
	CSVParser *parser =
    [[[CSVParser alloc]
      initWithString:csvString
      separator:@","
      hasHeader:YES
      fieldNames:nil]
     autorelease];
    
    NSArray *rows = [parser arrayOfParsedRows];
    
    for (NSDictionary *row in rows) {
        if (row.lastName!=nil) {
            [row setValue:row.lastName forKey:@"LastName"];
        }
        if (row.firstName!=nil) {
            [row setValue:row.firstName forKey:@"FirstName"];
        }
        if (row.countiesCovered !=nil) {
            [row setValue:row.countiesCovered forKey:@"CountiesCovered"];
        }
        if (row.districtNumber!=nil) {
            [row setValue:[row.districtNumber trim] forKey:@"DistrictNumber"];
        }
        
        if (row.coopRegionName!=nil) {
            [row setValue:[row.coopRegionName trim] forKey:@"CoopRegionName"];
        }
        
        if ([row valueForKey:@"Sort Order"]!=nil && [[[row valueForKey:@"Sort Order"] trim] length]>0 ) {
            [row setValue:[NSNumber numberWithInt:row.sortOrder] forKey:@"Sort Order Number"];
        } else {
            [row setValue:[NSNumber numberWithInt:99999] forKey:@"Sort Order Number"];
        }
    }
    
    NSSortDescriptor *sortByType = [[[NSSortDescriptor alloc] initWithKey:@"Type" ascending:YES] autorelease];
    NSSortDescriptor *sortBySortOrder = [[[NSSortDescriptor alloc] initWithKey:@"Sort Order Number" ascending:YES] autorelease];
    NSSortDescriptor *sortByLastName = [[[NSSortDescriptor alloc] initWithKey:@"Last Name" ascending:YES] autorelease];
    NSSortDescriptor *sortByFirstName = [[[NSSortDescriptor alloc] initWithKey:@"First Name" ascending:YES] autorelease];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortByType,sortBySortOrder,sortByLastName,sortByFirstName, nil];
    
    return [rows sortedArrayUsingDescriptors:sortDescriptors];
}

+ (NSString *) component:(int) componentIndex committeeString:(NSString *) committeeString {
    
    if (committeeString==nil || [committeeString length]==0) return nil;
    
    if (componentIndex!=1 && componentIndex!=2) return nil;
    
    NSString *regexString = @"(.*?)\\((.*?)\\)";
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error!=nil) {
        NSLog(@"Error parsing regex '%@' for '%@' :%@",regexString,committeeString,[error localizedDescription]);
    }
    
    NSArray *matches = [regex matchesInString:committeeString options:0 range:NSMakeRange(0, [committeeString length])];
    
    if (matches==nil || [matches count]!=1) return nil;
    
    NSTextCheckingResult *result = [matches objectAtIndex:0];
    
    if (result.numberOfRanges!=3) return nil;
    
    NSRange rangeOfMatch = [result rangeAtIndex:componentIndex];
    
    return [[committeeString substringWithRange:rangeOfMatch] trim];
}

+ (NSString *) committeeNameFromCommitteeString:(NSString *) committeeString {
    NSString *tempCommittee =  [DataLoader component:1 committeeString:committeeString];
    if (tempCommittee==nil) return committeeString;
    return tempCommittee;
}

+ (NSString *) committeePositionFromCommitteeString:(NSString *) committeeString {
    NSString *tempPosition = [DataLoader component:2 committeeString:committeeString];
    if (tempPosition==nil) return @"";
    return tempPosition;
}

+(NSArray *) buildCommitteesFromPeople:(NSArray *) people committeeKey:(NSString *) committeeKey {
    
    NSMutableDictionary *committees=[NSMutableDictionary dictionaryWithCapacity:10];
        
    for (NSDictionary *person  in people) {
        
        NSString *committeeListString = [person objectForKey:committeeKey];
        
        NSArray *committeeList = [committeeListString componentsSeparatedByString:@"~"];
        
        NSMutableArray *committeeArray = [NSMutableArray arrayWithCapacity:1];
        
        for (NSString *committeeString in committeeList) {
            
            NSString *trimmedCommitteeString = [[DataLoader committeeNameFromCommitteeString:[committeeString trim]] trim];
            NSString *position = [DataLoader committeePositionFromCommitteeString:[committeeString trim]];
            
            if (trimmedCommitteeString!=nil && [trimmedCommitteeString length]>0) {
                
                NSString *committeeDictKeyString = [NSString stringWithFormat:@"%@-%@-%@",person.type,committeeKey,trimmedCommitteeString];
                
                Committee *committee = [committees objectForKey:committeeDictKeyString];
                
                if (committee == nil ) {
                    committee = [[[Committee alloc] init] autorelease];
                    committee.name=trimmedCommitteeString;
                    committee.body=person.type;
                    committee.type=committeeKey;
                    [committees setObject:committee forKey:committeeDictKeyString];
                }    
                
                CommitteeMember *member = [[[CommitteeMember alloc] init] autorelease];
        
                member.committee = committee;
                member.person = person;
                member.title = position;
                if (member.title!=nil && [member.title caseInsensitiveCompare:@"alternate"]==NSOrderedSame) {
                    member.sortTitle=@"ZZZZZZZZZZZZ"; // Sort alternates after regular members
                } else if (member.title!=nil && [[member.title trim] length]>0) {
                    member.sortTitle=member.title;
                } else {
                    member.sortTitle=@"ZZZZZZZZZZZY"; // The Y at the end keeps these folks ahead of alternates
                }
                
                [committee.members addObject:member];
                
                [committeeArray addObject:committee];
            }
        }
        NSMutableArray *currentArray = [person valueForKey:COMMITTEES_ARRAY_KEY];
        
        if (currentArray==nil) {
            [person setValue:committeeArray forKey:COMMITTEES_ARRAY_KEY];
        } else {
            [person setValue:[currentArray arrayByAddingObjectsFromArray:committeeArray] forKey:COMMITTEES_ARRAY_KEY];
        }
        
    }
    
    NSArray *committeeArray = [committees allValues];

    NSSortDescriptor *sortByTitle = [[[NSSortDescriptor alloc] initWithKey:@"sortTitle" ascending:YES] autorelease];
    NSSortDescriptor *sortByLastName = [[[NSSortDescriptor alloc] initWithKey:@"person.lastName" ascending:YES] autorelease];
    NSSortDescriptor *sortByFirstName = [[[NSSortDescriptor alloc] initWithKey:@"person.firstName" ascending:YES] autorelease];
    
    NSArray *memberSortDescriptors = [NSArray arrayWithObjects:sortByTitle,sortByLastName,sortByFirstName, nil];
    
    for (Committee *c in committeeArray) {
        [c.members sortUsingDescriptors:memberSortDescriptors];
    }

    NSSortDescriptor *sortByCommitteeName = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortByCommitteeName, nil];
    
    return [committeeArray sortedArrayUsingDescriptors:sortDescriptors];
}

@end
