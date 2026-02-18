//
//  PeopleListDelegate.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/26/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import "PeopleListDelegate.h"
#import "ListSection.h"
#import "NSDictionary+People.h"
#import "Definitions.h"
#import "CommitteeMember.h"
#import "PersonViewController.h"
#import "NSString+Stuff.h"
#import "SearchViewCell.h"
#import "AppDelegate.h"

#define CELL_HEADSHOT       ((UIImageView *)[cell viewWithTag:100])
#define CELL_NAME           ((UILabel *)[cell viewWithTag:101])
#define CELL_TITLE          ((UILabel *)[cell viewWithTag:102])
#define CELL_SUBTITLE       ((UILabel *)[cell viewWithTag:103])
#define CELL_DISTRICT       ((UILabel *)[cell viewWithTag:104])
#define CELL_PHOTO_NA       ((UIView *)[cell viewWithTag:105])

@interface PeopleListDelegate ()

@property (readonly) SearchViewCell *searchViewCell;
@property (nonatomic, strong) NSMutableArray *filteredSections;

-(void) buildDisplaySections;
-(void) buildDisplaySectionsWithFilterType:(int)filterType filterText:(NSString *) filterText;

@end

@implementation PeopleListDelegate

@synthesize sections=_sections;
@synthesize viewController=_viewController;
@synthesize searchViewCell=_searchViewCell;
@synthesize peopleTable=_peopleTable;
@synthesize filteredSections=_filteredSections;

#pragma mark - Search Bar Delegate Stuff

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    // return NO to not become first responder
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // called when text starts editing
    searchBar.showsCancelButton=YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    // return NO to not resign first responder
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // called when text ends editing
    searchBar.showsCancelButton=NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // called when text changes (including clear)
    //[self buildDisplaySectionsWithFilterType:searchBar.selectedScopeButtonIndex filterText:[searchBar.text trim]];
    //[self.peopleTable reloadData];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // called before text changes
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // called when keyboard search button pressed
    
    if (searchBar.text!=nil && [searchBar.text length]>0) {
        [self buildDisplaySectionsWithFilterType:(int)searchBar.selectedScopeButtonIndex filterText:[searchBar.text trim]];
    } else {
        [self buildDisplaySections];
    }
    [self.peopleTable reloadData];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    // called when bookmark button pressed
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    // called when cancel button pressed
    [self buildDisplaySections];
    [self.peopleTable reloadData];

    if (self.peopleTable!=nil && self.filteredSections!=nil && [self.filteredSections count]>0) {
        [self.peopleTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    searchBar.text=@"";
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar { 
    // called when search results button pressed
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    if (searchBar.text!=nil && [searchBar.text length]>0) {
        [self buildDisplaySectionsWithFilterType:(int)searchBar.selectedScopeButtonIndex filterText:[searchBar.text trim]];
    } else {
        [self buildDisplaySections];
    }
    [self.peopleTable reloadData];
}

#pragma mark - Filter 

-(void)setSections:(NSArray *)sections {

    if (_sections!=nil) {
        _sections=nil; 
    }
    
    _sections = sections;
    [self buildDisplaySections];
}

-(void) buildDisplaySections {

    [self buildDisplaySectionsWithFilterType:99 filterText:nil];
}

-(void) buildDisplaySectionsWithFilterType:(int)filterType filterText:(NSString *) filterText {
    
    if (self.filteredSections==nil) {
        self.filteredSections = [NSMutableArray arrayWithCapacity:[self.sections count]];
    }
    [self.filteredSections removeAllObjects];
    
    if ([self.sections count]==0) return;
    
    for(ListSection *section in self.sections) {
        
        
        if (section.children!=nil && [section.children count]>0) {

            NSMutableArray *filteredChildren = [NSMutableArray arrayWithCapacity:[section.children count]];
            
            NSPredicate *filterPredicate=nil; 
            switch (filterType) {
  //              case 0:
  //                  filterPredicate = [NSPredicate predicateWithFormat:@"LastName contains[cd] %@",filterText];
  //                  break;
                case 0:
                    filterPredicate = [NSPredicate predicateWithFormat:@"FirstName contains[cd] %@ OR LastName contains[cd] %@",filterText,filterText];
                    break;
                case 1:
                    filterPredicate = [NSPredicate predicateWithFormat:@"CountiesCovered contains[cd] %@",filterText];
                    break;
                case 2:
                    filterPredicate = [NSPredicate predicateWithFormat:@"DistrictNumber = %@",filterText];
                    break;
                default:
                    filterPredicate=nil;
                    break;
            }
            
            if (filterPredicate==nil) {
                [filteredChildren addObjectsFromArray:section.children];
            } else if ([[section.children objectAtIndex:0] isKindOfClass:[CommitteeMember class]]) {
                for(CommitteeMember *member in section.children) {
                    if ([filterPredicate evaluateWithObject:member.person]) {
                        [filteredChildren addObject:member];
                    }
                }
            } else {
                [filteredChildren addObjectsFromArray:[section.children filteredArrayUsingPredicate:filterPredicate]];
            }
            
            if (filteredChildren!=nil && [filteredChildren count]>0) {
                ListSection *filteredListSection = [[ListSection alloc] init];
                
                filteredListSection.title = section.title;
                filteredListSection.rowHeight = section.rowHeight;
                filteredListSection.firstRowHeight = section.firstRowHeight;
                
                filteredListSection.children = [NSMutableArray arrayWithArray: filteredChildren];
                
                [self.filteredSections addObject:filteredListSection];
            }
        }
    }
    
}

#pragma mark - Search View Property

-(SearchViewCell *) searchViewCell {
    
    if (_searchViewCell==nil) {
        _searchViewCell = [[[NSBundle mainBundle] loadNibNamed:@"PeopleListSearchCell-iPhone" owner:self options:nil] objectAtIndex:0];
        _searchViewCell.searchBar.delegate=self;
        _searchViewCell.searchBar.showsCancelButton=NO;
        _searchViewCell.searchBar.showsScopeBar = YES;
        [_searchViewCell.searchBar sizeToFit];

        // Keep the scope controls visible on modern iOS where sizeToFit can shrink this view.
        CGRect searchBarFrame = _searchViewCell.searchBar.frame;
        searchBarFrame.origin.y = 0.0f;
        searchBarFrame.size.width = _searchViewCell.contentView.bounds.size.width;
        searchBarFrame.size.height = SEARCH_VIEW_HEIGHT;
        _searchViewCell.searchBar.frame = searchBarFrame;
    }
    
    return _searchViewCell;
}

#pragma mark - Table view data source

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.filteredSections==nil) return nil;

    if (section==0) return nil;
    
    if ([self.filteredSections count]<=(section-1)) return nil;
    ListSection *listSection = [self.filteredSections objectAtIndex:(section-1)];
    return listSection.title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.filteredSections==nil) return 0;
    return [self.filteredSections count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filteredSections!=nil && section==0) return 1; // Search View Cell
    if (self.filteredSections==nil || [self.filteredSections count]<=(section-1)) return 0;

    ListSection *listSection = [self.filteredSections objectAtIndex:(section-1)];

    if ([self.filteredSections count]+1==2) {
        if ([listSection.children count]<5) {
            return 5;
        }
    }
    
    if ([listSection.title isEqualToString:FEDERAL_HOUSE]) {
        return 3;
    }
    
    return [listSection.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0 && indexPath.row==0) {
        return self.searchViewCell;
    }

    ListSection *section = [self.filteredSections objectAtIndex:(indexPath.section-1)];

    
    if (indexPath.row >= [section.children count]) {
        
        static NSString *BlankCellIdentifier = @"BlankCell";
        UITableViewCell *blankCell = [tableView dequeueReusableCellWithIdentifier:BlankCellIdentifier];

        if (blankCell==nil) {
            blankCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BlankCellIdentifier];
            blankCell.selectionStyle=UITableViewCellSelectionStyleNone;
            blankCell.backgroundColor=[UIColor clearColor];
        }
        return blankCell;
        
    }
    
    CommitteeMember *member = nil;
    NSDictionary *person = nil;
    
    if ( [[section.children objectAtIndex:indexPath.row] isKindOfClass:[CommitteeMember class]]) {
        
        member = [section.children objectAtIndex:indexPath.row];
        person = member.person;
    } else {
        person = [section.children objectAtIndex:indexPath.row];
    }
    

    
    static NSString *CellIdentifier = @"PeopleListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"PeopleListCell-iPhone" owner:nil options:nil] objectAtIndex:0];
    }
    


    
    if ([@"vacant" caseInsensitiveCompare:person.firstName]==NSOrderedSame) {
        CELL_NAME.text = @"Seat Vacant";
    } else {
        CELL_NAME.text = [NSString stringWithFormat:@"%@ %@",person.firstName,person.lastName];
    }
    
    CELL_TITLE.text=@"";
    CELL_SUBTITLE.text=@"";
    CELL_DISTRICT.text=@"";
    CELL_DISTRICT.textColor=CELL_NAME.textColor;
    
    if ([person.party isEqualToString:@"R"]) CELL_DISTRICT.textColor=[UIColor redColor];
    if ([person.party isEqualToString:@"D"]) CELL_DISTRICT.textColor=[UIColor blueColor];
    
    CELL_TITLE.frame = CGRectMake(CELL_TITLE.frame.origin.x, CELL_TITLE.frame.origin.y, 124.0f, CELL_TITLE.frame.size.height);
    
    if ([person.type isEqualToString:STATE_HOUSE]) {
        CELL_TITLE.text=STATE_REPRESENTATIVE_TITLE;
        CELL_SUBTITLE.text=person.titleLeadership;
        CELL_DISTRICT.text = [NSString stringWithFormat:@"%@%@District %@",((person.party==nil || [[person.party trim] length]==0)?@"":person.party),((person.party==nil || [[person.party trim] length]==0)?@"":@"-"),person.districtNumber];
    } else if ([person.type isEqualToString:STATE_SENATE]) {
        CELL_TITLE.text=STATE_SENATOR_TITLE;
        CELL_SUBTITLE.text=person.titleLeadership;
        CELL_DISTRICT.text = [NSString stringWithFormat:@"%@%@District %@",((person.party==nil || [[person.party trim] length]==0)?@"":person.party),((person.party==nil || [[person.party trim] length]==0)?@"":@"-"),person.districtNumber];
    } else if ([person.type isEqualToString:STATEWIDE]) {
        CELL_TITLE.frame = CGRectMake(CELL_TITLE.frame.origin.x, CELL_TITLE.frame.origin.y, 175.0f, CELL_TITLE.frame.size.height);
        CELL_TITLE.text=person.titleLeadership;
        CELL_DISTRICT.text = person.party;
    } else if ([person.type isEqualToString:JUDICIARY1] || [person.type isEqualToString:JUDICIARY2]) {
//        CELL_TITLE.frame = CGRectMake(CELL_TITLE.frame.origin.x, CELL_TITLE.frame.origin.y, 175.0f, CELL_TITLE.frame.size.height);
        CELL_TITLE.text=person.titleLeadership;
        CELL_DISTRICT.text = person.districtNumber;
    } else if ([person.type isEqualToString:FEDERAL_HOUSE]) {
        CELL_TITLE.text=@"US Representative";
        CELL_SUBTITLE.text=person.titleLeadership;
        CELL_DISTRICT.text = [NSString stringWithFormat:@"%@%@District %@",((person.party==nil || [[person.party trim] length]==0)?@"":person.party),((person.party==nil || [[person.party trim] length]==0)?@"":@"-"),person.districtNumber];
    } else if ([person.type isEqualToString:FEDERAL_SENATE]) {
        CELL_TITLE.text=@"US Senator";
        CELL_SUBTITLE.text=person.titleLeadership;
        CELL_DISTRICT.text = person.party;
    } else if ([person.type isEqualToString:WREA_MEMBER]) {
        CELL_TITLE.frame = CGRectMake(CELL_TITLE.frame.origin.x, CELL_TITLE.frame.origin.y, 222.0f, CELL_TITLE.frame.size.height);
        CELL_TITLE.text=person.coopName;
        CELL_SUBTITLE.text=person.titleLeadership;
    } else if ([person.type isEqualToString:LEGISLATIVE_CONTACT]) {
        CELL_TITLE.frame = CGRectMake(CELL_TITLE.frame.origin.x, CELL_TITLE.frame.origin.y, 222.0f, CELL_TITLE.frame.size.height);
        CELL_TITLE.text=person.coopName;
        CELL_SUBTITLE.text=person.titleLeadership;
    }
    
    if (member!=nil) {
        if (member.title!=nil) {
            CELL_SUBTITLE.text = member.title;
        } else {
            CELL_SUBTITLE.text = @"";
        }
    }
    
    
    BOOL hasPhoto=NO;
    if (person.photo!=nil && [person.photo length]>0) {
        
        CELL_HEADSHOT.image=[UIImage imageNamed:person.photo];
        
        //NSLog(@"Attempt to load photo %@ %@",person.photo,(CELL_HEADSHOT.image==nil?@"FAILED":@"SUCCEEDED"));
        
        if (CELL_HEADSHOT.image==nil)
        {
            //Attempt retrieve for photo in device Documents folder (extracted from photos.zip)
            NSArray *dirPaths;
            NSString *docsDir;
            dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            docsDir = [dirPaths objectAtIndex:0];
            NSString *docsPhotoFilename = [NSString stringWithFormat:@"%@/%@", docsDir, person.photo];
            CELL_HEADSHOT.image=[UIImage imageWithContentsOfFile:docsPhotoFilename];
        }

        if (CELL_HEADSHOT.image!=nil) hasPhoto=YES;
    }
    
    if (hasPhoto) {
        CELL_HEADSHOT.hidden=NO;
        CELL_PHOTO_NA.hidden=YES;
    } else {
        CELL_HEADSHOT.hidden=YES;
        CELL_HEADSHOT.image=nil;
        CELL_PHOTO_NA.hidden=NO;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0 && indexPath.row==0) {
        return SEARCH_VIEW_HEIGHT;
    }
    return 104.0f;
}

-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) return nil;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ListSection *section = [self.filteredSections objectAtIndex:(indexPath.section-1)];
    CommitteeMember *member = nil;
    NSDictionary *person = nil;
    
    if (indexPath.row>=[section.children count]) return;
    
    if ( [[section.children objectAtIndex:indexPath.row] isKindOfClass:[CommitteeMember class]]) {
        member = [section.children objectAtIndex:indexPath.row];
        person = member.person;
    } else {
        person = [section.children objectAtIndex:indexPath.row];
    }

    PersonViewController *pvc = [[PersonViewController alloc] initWithNibName:@"PersonView-iPhone" bundle:nil];
    
    pvc.person=person;
    
    [self.viewController.navigationController pushViewController:pvc animated:YES];

}

- (void)dealloc
{
    if (_searchViewCell!=nil) _searchViewCell.searchBar.delegate=nil;
}

@end
