//
//  VotingListViewController.m
//  OAECLegGuide
//
//  Created by User on 5/15/17.
//  Copyright © 2017 Architactile LLC. All rights reserved.
//





#import "VotingListViewController.h"
#import "RollCallListDelegate.h"
#import "AppDelegate.h"
#import "Committee.h"

#import <Realm/Realm.h>



@interface VotingListViewController ()

@property (nonatomic, strong) RollCallListDelegate *rollCallListDelegate;
@property (strong, nonatomic) IBOutlet UITableView *rc_peopleTable;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundArtworkImageView;
@property (strong, nonatomic) IBOutlet UIView *headerBackgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *headerLogoImageView;
@property (strong, nonatomic) IBOutlet UIButton *headerWebButton;
@property (strong, nonatomic) IBOutlet UIButton *headerBackButton;

- (IBAction)backButtonPushed:(id)sender;

@end

@implementation VotingListViewController

//@synthesize rollCallListDelegate=_rollCallListDelegate;
//@synthesize rc_peopleTable=_rc_peopleTable;
//@synthesize rc_sections=_rc_sections;
//@synthesize rc_committee=_rc_committee;




#pragma mark - UI Hooks


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


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.rc_peopleTable.indexPathForSelectedRow!=nil) {
        [self.rc_peopleTable deselectRowAtIndexPath:self.rc_peopleTable.indexPathForSelectedRow animated:YES];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.rollCallListDelegate==nil) {
        self.rollCallListDelegate = [[RollCallListDelegate alloc] init];
        self.rollCallListDelegate.rc_viewController = self;
        self.rollCallListDelegate.rc_committee=self.rc_committee;
        self.rollCallListDelegate.rc_sections = self.rc_sections;
        self.rc_peopleTable.delegate=self.rollCallListDelegate;
        self.rc_peopleTable.dataSource=self.rollCallListDelegate;
        self.rc_peopleTable.contentOffset = CGPointMake(0, SEARCH_VIEW_HEIGHT);
        self.rollCallListDelegate.rc_peopleTable=self.rc_peopleTable;
        
    }
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
    
    CGRect backgroundFrame = self.backgroundArtworkImageView.frame;
    backgroundFrame.origin.y = safeTop;
    backgroundFrame.size.width = self.view.bounds.size.width;
    backgroundFrame.size.height = self.view.bounds.size.height - safeTop;
    self.backgroundArtworkImageView.frame = backgroundFrame;
    
    CGRect tableFrame = self.rc_peopleTable.frame;
    tableFrame.origin.y = safeTop + headerHeight;
    tableFrame.size.height = self.view.bounds.size.height - tableFrame.origin.y;
    tableFrame.size.width = self.view.bounds.size.width;
    self.rc_peopleTable.frame = tableFrame;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



@end
