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
- (IBAction)quizButtonPressed:(id)sender;
- (IBAction)legContactsButtonPressed:(id)sender;
- (IBAction)websiteButtonPressed:(id)sender;
- (IBAction)phoneNumberButtonPressed:(id)sender;
- (IBAction)mixMattersButtonPressed:(id)sender;
- (void)configurePrimaryActionButtons;
- (void)layoutPrimaryActionButtons;

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
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:WREA_MEMBER, nil]];
    
    [self.navigationController pushViewController:plvc animated:YES];
    
}

- (IBAction)quizButtonPressed:(UITapGestureRecognizer *)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.proprofs.com/quiz-school/ugc/story.php?title=wreas-knowyourlegislator-quiz"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
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
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneButton.titleLabel.text]];
        [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:nil];
    }
}

- (IBAction)mixMattersButtonPressed:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] otherLink1];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configurePrimaryActionButtons];
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
    [self configurePrimaryActionButtons];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutPrimaryActionButtons];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)configurePrimaryActionButtons
{
    NSMutableArray<UIButton *> *buttons = [NSMutableArray array];
    NSMutableArray<NSString *> *titles = [NSMutableArray array];
    if (self.electedOfficialsButton != nil) {
        [buttons addObject:self.electedOfficialsButton];
        [titles addObject:@"Elected Officials"];
    }
    if (self.ourMembersButton != nil) {
        [buttons addObject:self.ourMembersButton];
        [titles addObject:@"Our Members"];
    }
    if (self.quizButtonPressed != nil) {
        [buttons addObject:self.quizButtonPressed];
        [titles addObject:@"Quiz"];
    }
    UIColor *buttonColor = [UIColor colorWithRed:0.36 green:0.18 blue:0.07 alpha:1.0];
    
    // Keep legacy tappable overlays non-visual.
    self.websiteButton.backgroundColor = [UIColor clearColor];
    [self.websiteButton setTitle:@"" forState:UIControlStateNormal];
    self.ourStaffButton.hidden = YES;
    self.ourStaffButton.backgroundColor = [UIColor clearColor];
    
    for (NSInteger idx = 0; idx < buttons.count; idx++) {
        UIButton *button = buttons[idx];
        if (button == nil) {
            continue;
        }
        [button setTitle:titles[idx] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
        button.backgroundColor = buttonColor;
        button.layer.cornerRadius = 8.0f;
        button.layer.masksToBounds = YES;
        button.alpha = 0.95f;
        [self.view bringSubviewToFront:button];
    }
    for (UIButton *button in buttons) {
        [self.view bringSubviewToFront:button];
    }
}

- (void)layoutPrimaryActionButtons
{
    NSMutableArray<UIButton *> *buttons = [NSMutableArray array];
    if (self.electedOfficialsButton != nil) [buttons addObject:self.electedOfficialsButton];
    if (self.ourMembersButton != nil) [buttons addObject:self.ourMembersButton];
    if (self.quizButtonPressed != nil) [buttons addObject:self.quizButtonPressed];
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat width = MIN(220.0f, viewWidth * 0.56f);
    CGFloat height = 52.0f;
    CGFloat spacing = 12.0f;
    CGFloat x = viewWidth - width - 24.0f;
    CGFloat startY = self.view.bounds.size.height * 0.44f;
    
    for (NSInteger idx = 0; idx < buttons.count; idx++) {
        UIButton *button = buttons[idx];
        if (button == nil) {
            continue;
        }
        CGFloat y = startY + ((height + spacing) * idx);
        button.frame = CGRectMake(x, y, width, height);
    }
}


@end
