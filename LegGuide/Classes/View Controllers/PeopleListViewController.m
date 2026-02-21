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
@property (strong, nonatomic) IBOutlet UIImageView *backgroundArtworkImageView;
@property (strong, nonatomic) IBOutlet UIView *headerBackgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *headerLogoImageView;
@property (strong, nonatomic) IBOutlet UIButton *headerWebButton;
@property (strong, nonatomic) IBOutlet UIButton *headerBackButton;


- (IBAction)backButtonPushed:(id)sender;

@end

@implementation PeopleListViewController

static void OpenExternalURL(NSURL *url) {
    if (url == nil) {
        return;
    }
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

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
        OpenExternalURL([NSURL URLWithString:[NSString stringWithFormat:@"sms:/open?addresses=%@",cellPhones]]);
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Sorry, but I can't seem to figure out how to dial the phone on this device."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
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
    // Modernize legacy back badge to a simple chevron with larger tap target.
    [self.headerBackButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.headerBackButton setTitle:@"" forState:UIControlStateNormal];
    self.headerBackButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.88];
    self.headerBackButton.layer.cornerRadius = 10.0f;
    self.headerBackButton.layer.masksToBounds = YES;
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:24.0 weight:UIImageSymbolWeightHeavy];
        UIImage *chevron = [UIImage systemImageNamed:@"chevron.left" withConfiguration:symbolConfig];
        [self.headerBackButton setImage:chevron forState:UIControlStateNormal];
        [self.headerBackButton setTintColor:[UIColor colorWithRed:0.13 green:0.17 blue:0.22 alpha:1.0]];
    } else {
        [self.headerBackButton setTitle:@"<" forState:UIControlStateNormal];
        [self.headerBackButton setTitleColor:[UIColor colorWithRed:0.13 green:0.17 blue:0.22 alpha:1.0] forState:UIControlStateNormal];
        self.headerBackButton.titleLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    }
    self.headerBackButton.accessibilityLabel = @"Back";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat safeTop = 20.0f;
    if (@available(iOS 11.0, *)) {
        safeTop = self.view.safeAreaInsets.top;
    }
    
    CGFloat headerHeight = 52.0f;
    CGRect headerFrame = self.headerBackgroundView.frame;
    headerFrame.origin.y = safeTop;
    headerFrame.size.width = self.view.bounds.size.width;
    headerFrame.size.height = headerHeight;
    self.headerBackgroundView.frame = headerFrame;
    
    CGRect logoFrame = self.headerLogoImageView.frame;
    logoFrame.origin.y = safeTop;
    logoFrame.size.width = self.view.bounds.size.width;
    logoFrame.size.height = headerHeight;
    self.headerLogoImageView.frame = logoFrame;
    
    CGRect backgroundFrame = self.backgroundArtworkImageView.frame;
    backgroundFrame.origin.y = safeTop;
    backgroundFrame.size.width = self.view.bounds.size.width;
    backgroundFrame.size.height = self.view.bounds.size.height - safeTop;
    self.backgroundArtworkImageView.frame = backgroundFrame;
    
    CGRect webFrame = self.headerWebButton.frame;
    webFrame.origin.y = safeTop;
    webFrame.size.height = headerHeight;
    self.headerWebButton.frame = webFrame;
    
    CGRect backFrame = self.headerBackButton.frame;
    backFrame.origin.x = 8.0f;
    backFrame.origin.y = safeTop + 4.0f;
    backFrame.size.width = 44.0f;
    backFrame.size.height = 44.0f;
    self.headerBackButton.frame = backFrame;
    
    CGRect messageFrame = self.committeeMessageButton.frame;
    messageFrame.origin.y = safeTop + 7.0f;
    self.committeeMessageButton.frame = messageFrame;
    
    CGRect tableFrame = self.peopleTable.frame;
    tableFrame.origin.y = safeTop + headerHeight;
    tableFrame.size.height = self.view.bounds.size.height - tableFrame.origin.y;
    tableFrame.size.width = self.view.bounds.size.width;
    self.peopleTable.frame = tableFrame;
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



@end
