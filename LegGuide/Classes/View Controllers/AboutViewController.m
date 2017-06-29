//
//  AboutViewController.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/21/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"
#import "PeopleListViewController.h"
#import "ListSection.h"
#import "Definitions.h"

@interface AboutViewController () {
    BOOL firstLaunch;
}

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;


@property (strong, nonatomic) IBOutlet UIButton *websiteButton;
@property (strong, nonatomic) IBOutlet UIButton *electedOfficialsButton;
@property (strong, nonatomic) IBOutlet UIButton *ourMembersButton;
@property (strong, nonatomic) IBOutlet UIButton *ourStaffButton;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)legislatureButtonPressed:(id)sender;
- (IBAction)memberSystemsButtonPressed:(id)sender;
- (IBAction)legContactsButtonPressed:(id)sender;
- (IBAction)websiteButtonPressed:(id)sender;
- (IBAction)phoneNumberButtonPressed:(id)sender;
- (IBAction)mixMattersButtonPressed:(id)sender;

@end

@implementation AboutViewController

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)legislatureButtonPressed:(id)sender {
    //UINavigationController *nc = [self.tabBarController.viewControllers objectAtIndex:1];
    //[nc popToRootViewControllerAnimated:NO];
    [self.tabBarController setSelectedIndex:1];
}

-(IBAction) weblink {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] weblink];
}

- (IBAction)memberSystemsButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:OAEC_MEMBER, nil]];
    
    [self.navigationController pushViewController:plvc animated:YES];
    
}

- (IBAction)legContactsButtonPressed:(id)sender {
        
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:LEGISLATIVE_CONTACT, nil]];
    
    [self.navigationController pushViewController:plvc animated:YES];
    
}

- (IBAction)websiteButtonPressed:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] weblink];
}

- (IBAction)phoneNumberButtonPressed:(id)sender {
    
    UIButton *phoneButton = (UIButton *) sender;
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneButton.titleLabel.text]]];
    }
}

- (IBAction)mixMattersButtonPressed:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] otherLink1];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.websiteButton.backgroundColor=[UIColor clearColor];
    self.ourMembersButton.backgroundColor=[UIColor clearColor];
    self.ourStaffButton.backgroundColor=[UIColor clearColor];
    self.electedOfficialsButton.backgroundColor=[UIColor clearColor];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (firstLaunch) {
        firstLaunch=NO;
        AppDelegate *ap = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [ap loadBoundaries];
    }
}

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
    firstLaunch=YES;
}

- (void)viewDidUnload
{
    [self setBackgroundImage:nil];
    [self setElectedOfficialsButton:nil];
    [self setOurMembersButton:nil];
    [self setOurStaffButton:nil];
    [self setWebsiteButton:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
