//
//  PeopleListViewController.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/29/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import "PeopleListViewController.h"
#import "PeopleListDelegate.h"
#import "AppDelegate.h"
#import "ListSection.h"
#import "CommitteeMember.h"


@interface PeopleListViewController ()

@property (nonatomic, strong) PeopleListDelegate *peopleListDelegate;
@property (strong, nonatomic) IBOutlet UITableView *peopleTable;


- (IBAction)backButtonPushed:(id)sender;

@end

@implementation PeopleListViewController

@synthesize peopleListDelegate=_peopleListDelegate;
@synthesize peopleTable=_peopleTable;
@synthesize sections=_sections;

#pragma mark - UI Hooks


- (IBAction)message:(id)sender {
    NSArray *committeeMembers = ((ListSection*)self.sections[0]).children;
    
    NSMutableString *cellPhones = [[NSMutableString alloc]init];
    for (CommitteeMember *member in committeeMembers) {
        NSMutableString *membersCell = member.person[@"Cell Phone"];
        if ([membersCell length] > 0) {
            membersCell = (NSMutableString*)[membersCell stringByReplacingOccurrencesOfString:@"(" withString:@""];
            membersCell = (NSMutableString*)[membersCell stringByReplacingOccurrencesOfString:@")" withString:@"-"];
            membersCell = (NSMutableString*)[membersCell stringByReplacingOccurrencesOfString:@" " withString:@""];
            [cellPhones appendString:membersCell];
            [cellPhones appendString:@","];
        }
    }

    if ([cellPhones length] > 0) {
        cellPhones = (NSMutableString*)[cellPhones substringToIndex:[cellPhones length] - 1];
    }
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:/open?addresses=%@",cellPhones]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Sorry, but I can't seem to figure out how to dial the phone on this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}




-(IBAction) weblink {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] weblink];
}


- (IBAction)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Lifecycle Stuff

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.peopleTable.indexPathForSelectedRow!=nil) {
        [self.peopleTable deselectRowAtIndexPath:self.peopleTable.indexPathForSelectedRow animated:YES];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ListSection *lsection = self.sections[0];
    NSString *sectionTitle = lsection.title;
    
    if ([sectionTitle isEqualToString:@"Statewide"] ||
        [sectionTitle isEqualToString:@"Wyoming Senate"] ||
        [sectionTitle isEqualToString:@"Wyoming House"]
        ) {
        _committeeMessageButton.hidden = YES;
    } else {
        _committeeMessageButton.hidden = NO;
    }

    if (self.peopleListDelegate==nil) {
        self.peopleListDelegate = [[PeopleListDelegate alloc] init];
        self.peopleListDelegate.viewController = self;
        self.peopleListDelegate.sections = self.sections;   
        self.peopleTable.delegate=self.peopleListDelegate;
        self.peopleTable.dataSource=self.peopleListDelegate;
        self.peopleTable.contentOffset = CGPointMake(0, SEARCH_VIEW_HEIGHT);
        self.peopleListDelegate.peopleTable=self.peopleTable;

    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
