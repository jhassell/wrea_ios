//
//  StateTabViewController.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/21/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import <Realm/Realm.h>
#import "StateTabViewController.h"
#import "PeopleListViewController.h"
#import "VotingListViewController.h"
#import "AppDelegate.h"
#import "ListSection.h"
#import "CommitteeListViewController.h"
#import "CommitteeVoteListViewController.h"
#import "ListSection.h"
#import "Definitions.h"

@interface StateTabViewController ()
- (IBAction)statewideButtonPressed:(id)sender;
- (IBAction)judiciaryButtonPressed:(id)sender;
- (IBAction)senateButtonPressed:(id)sender;
- (IBAction)senateVoteButtonPressed:(id)sender;
- (IBAction)senateLeadershipButtonPressed:(id)sender;
- (IBAction)senateCommitteesButtonPressed:(id)sender;
- (IBAction)houseButtonPressed:(id)sender;
- (IBAction)houseVoteButtonPressed:(id)sender;
- (IBAction)houseLeadershipButtonPressed:(id)sender;
- (IBAction)houseCommitteesButtonpressed:(id)sender;
- (IBAction)houseVoteCommitteesButtonPressed:(id)sender;
- (IBAction)allButtonPressed:(id)sender;
- (IBAction)allVoteButtonPressed:(id)sender;
- (IBAction)voteTallyButtonPressed:(id)sender;
@property (nonatomic, strong) UIScrollView *modernStateScrollView;
@property (nonatomic, strong) UIView *modernStateContentView;
@property (nonatomic, assign) BOOL modernStateUIBuilt;
- (BOOL)isStateLandingScreen;
- (void)setupModernStateLandingUIIfNeeded;
- (UIView *)modernSectionViewWithTitle:(NSString *)title rows:(NSArray<UIView *> *)rows;
- (UIButton *)modernRowButtonWithBadgeText:(NSString *)badgeText
                                badgeColor:(UIColor *)badgeColor
                                     title:(NSString *)title
                                  subtitle:(NSString *)subtitle
                                    action:(SEL)action;
- (void)openVoteTallyScreenFromModernLayout:(id)sender;
- (void)openSenateSeatingFromModernLayout:(id)sender;
- (void)openHouseSeatingFromModernLayout:(id)sender;

@end

@implementation StateTabViewController

-(IBAction) weblink {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] weblink];
}


- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)statewideButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:STATEWIDE, nil]];    
    
    [self.navigationController pushViewController:plvc animated:YES];

}

- (IBAction)judiciaryButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:JUDICIARY1, JUDICIARY2, nil]];
    
    [self.navigationController pushViewController:plvc animated:YES];
}

- (IBAction)senateButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    plvc.sections = [ListSection buildSectionsFrom:ad.stateSenate dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:STATE_SENATE, nil]];
    
    [self.navigationController pushViewController:plvc animated:YES];

}

- (IBAction)senateVoteButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    VotingListViewController *vlvc = [[VotingListViewController alloc] initWithNibName:@"VoteListView-iPhone" bundle:nil];
    vlvc.rc_sections = [ListSection buildSectionsFrom:ad.stateSenate dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:STATE_SENATE, nil]];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"BackgroundLight.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:vlvc.view.frame];
    backgroundImageView.image=backgroundImage;
    [vlvc.view insertSubview:backgroundImageView atIndex:0];
    
    [self.navigationController pushViewController:vlvc animated:YES];
    
}

- (IBAction)houseVoteButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    VotingListViewController *vlvc = [[VotingListViewController alloc] initWithNibName:@"VoteListView-iPhone" bundle:nil];
    vlvc.rc_sections = [ListSection buildSectionsFrom:ad.stateHouse dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:STATE_HOUSE, nil]];
    
    [self.navigationController pushViewController:vlvc animated:YES];
    
}

- (IBAction)senateLeadershipButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects: STATE_SENATE, nil] withTitlesOnly:YES];    
    
    [self.navigationController pushViewController:plvc animated:YES];
}

- (IBAction)senateCommitteesButtonPressed:(id)sender {
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommitteeListViewController *clvc = [[CommitteeListViewController alloc] initWithNibName:@"CommitteeListView-iPhone" bundle:nil];
    
    ListSection *ls1 = [[ListSection alloc] init];
    ls1.title=STANDING;
    ls1.children=[[NSArray arrayWithArray:ad.stateSenateStandingCommittees] mutableCopy];
    
    ListSection *ls2 = [[ListSection alloc] init];
    ls2.title=APPROPRIATIONS;
    ls2.children=[[NSArray arrayWithArray:ad.stateSenateAppropriationsSubcommittees] mutableCopy];
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:2];
    
    if ([ls1.children count]>0) [sections addObject:ls1];
    if ([ls2.children count]>0) [sections addObject:ls2];
    
    clvc.sections = [NSArray arrayWithArray:sections];
    
    [self.navigationController pushViewController:clvc animated:YES];
    

}


- (IBAction)senateVoteCommitteesButtonPressed:(id)sender {
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommitteeVoteListViewController *clvc = [[CommitteeVoteListViewController alloc] initWithNibName:@"CommitteeListView-iPhone" bundle:nil];
    
    ListSection *ls1 = [[ListSection alloc] init];
    ls1.title=STANDING;
    ls1.children=[[NSArray arrayWithArray:ad.stateSenateStandingCommittees] mutableCopy];
    
    ListSection *ls2 = [[ListSection alloc] init];
    ls2.title=APPROPRIATIONS;
    ls2.children=[[NSArray arrayWithArray:ad.stateSenateAppropriationsSubcommittees] mutableCopy];
    
    clvc.sections = [NSArray arrayWithObjects:ls1,ls2,nil];
    
    [self.navigationController pushViewController:clvc animated:YES];
    
}





- (IBAction)houseButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    plvc.sections = [ListSection buildSectionsFrom:ad.stateHouse dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects: STATE_HOUSE, nil]];
    
    [self.navigationController pushViewController:plvc animated:YES];

}

- (IBAction)houseLeadershipButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects: STATE_HOUSE, nil] withTitlesOnly:YES];    
    
    [self.navigationController pushViewController:plvc animated:YES];

}

- (IBAction)houseCommitteesButtonpressed:(id)sender {
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommitteeListViewController *clvc = [[CommitteeListViewController alloc] initWithNibName:@"CommitteeListView-iPhone" bundle:nil];
    
    ListSection *ls1 = [[ListSection alloc] init];
    ls1.title=STANDING;
    ls1.children=[[NSArray arrayWithArray:ad.stateHouseStandingCommittees] mutableCopy];

    ListSection *ls2 = [[ListSection alloc] init];
    ls2.title=APPROPRIATIONS;
    ls2.children=[[NSArray arrayWithArray:ad.stateHouseAppropriationsSubcommittees] mutableCopy];
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:2];
    
    if ([ls1.children count]>0) [sections addObject:ls1];
    if ([ls2.children count]>0) [sections addObject:ls2];
    
    clvc.sections = [NSArray arrayWithArray:sections];
    
    [self.navigationController pushViewController:clvc animated:YES];

}

- (IBAction)houseVoteCommitteesButtonPressed:(id)sender {
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommitteeVoteListViewController *clvc = [[CommitteeVoteListViewController alloc] initWithNibName:@"CommitteeListView-iPhone" bundle:nil];
    
    ListSection *ls1 = [[ListSection alloc] init];
    ls1.title=STANDING;
    ls1.children=[[NSArray arrayWithArray:ad.stateHouseStandingCommittees] mutableCopy];
    
    ListSection *ls2 = [[ListSection alloc] init];
    ls2.title=APPROPRIATIONS;
    ls2.children=[[NSArray arrayWithArray:ad.stateHouseAppropriationsSubcommittees] mutableCopy];
    
    clvc.sections = [NSArray arrayWithObjects:ls1,ls2,nil];
    
    [self.navigationController pushViewController:clvc animated:YES];
    
}



- (IBAction)allButtonPressed:(id)sender {
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    
    ListSection *ls1 = [[ListSection alloc] init];
    ls1.title=[NSString stringWithFormat:@"All %@",STATE_NAME];
    
    NSMutableArray *all = [NSMutableArray arrayWithArray:ad.stateHouse];
    [all addObjectsFromArray:ad.stateSenate];
    [all addObjectsFromArray:ad.statewide];
    [all addObjectsFromArray:ad.judiciary1];
    [all addObjectsFromArray:ad.judiciary2];
    
    NSSortDescriptor *lastSort = [NSSortDescriptor sortDescriptorWithKey:@"Last Name" ascending:YES];
    NSSortDescriptor *firstSort = [NSSortDescriptor sortDescriptorWithKey:@"First Name" ascending:YES];
    
    [all sortUsingDescriptors:[NSArray arrayWithObjects:lastSort,firstSort,nil]];
    
    ls1.children=[[NSArray arrayWithArray:all] mutableCopy];
    
    plvc.sections = [NSArray arrayWithObject:ls1];
    
    //NSLog(@"%i sections",[plvc.sections count]);
    
    // for (ListSection *section in plvc.sections) {
        
        //NSLog(@"Section %@ has %i children",section.title,[section.children count]);
        
    // }
    
    [self.navigationController pushViewController:plvc animated:YES];

}

- (IBAction)allVoteButtonPressed:(id)sender {
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    VotingListViewController *vlvc = [[VotingListViewController alloc] initWithNibName:@"VoteListView-iPhone" bundle:nil];
    
    ListSection *ls1 = [[ListSection alloc] init];
    ls1.title=@"All Wyoming";
    
    NSMutableArray *all = [NSMutableArray arrayWithArray:ad.stateHouse];
    [all addObjectsFromArray:ad.stateSenate];
    [all addObjectsFromArray:ad.statewide];
    
    NSSortDescriptor *lastSort = [NSSortDescriptor sortDescriptorWithKey:@"Last Name" ascending:YES];
    NSSortDescriptor *firstSort = [NSSortDescriptor sortDescriptorWithKey:@"First Name" ascending:YES];
    
    [all sortUsingDescriptors:[NSArray arrayWithObjects:lastSort,firstSort,nil]];
    
    ls1.children=[[NSArray arrayWithArray:all] mutableCopy];
    
    vlvc.rc_sections = [NSArray arrayWithObject:ls1];
    
    //NSLog(@"%i sections",[plvc.sections count]);
    
    // for (ListSection *section in plvc.sections) {
    
    //NSLog(@"Section %@ has %i children",section.title,[section.children count]);
    
    // }
    
    [self.navigationController pushViewController:vlvc animated:YES];
    
}



- (IBAction)voteTallyButtonPressed:(id)sender {
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    VotingListViewController *vlvc = [[VotingListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    
    ListSection *ls1 = [[ListSection alloc] init];
    ls1.title=@"All Wyoming";
    
    NSMutableArray *all = [NSMutableArray arrayWithArray:ad.stateHouse];
    [all addObjectsFromArray:ad.stateSenate];
    [all addObjectsFromArray:ad.statewide];
    
    NSSortDescriptor *lastSort = [NSSortDescriptor sortDescriptorWithKey:@"Last Name" ascending:YES];
    NSSortDescriptor *firstSort = [NSSortDescriptor sortDescriptorWithKey:@"First Name" ascending:YES];
    
    [all sortUsingDescriptors:[NSArray arrayWithObjects:lastSort,firstSort,nil]];
    
    ls1.children=[[NSArray arrayWithArray:all] mutableCopy];
    
    vlvc.rc_sections = [NSArray arrayWithObject:ls1];
    
    
    [self.navigationController pushViewController:vlvc animated:YES];
    
}

- (BOOL)isStateLandingScreen
{
    NSArray *buttons = [self allButtonsInView:self.view];
    for (UIButton *button in buttons) {
        NSArray<NSString *> *actions = [button actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if ([actions containsObject:@"statewideButtonPressed:"]) {
            return YES;
        }
    }
    return NO;
}

- (void)openVoteTallyScreenFromModernLayout:(id)sender
{
    UIViewController *voteTallyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StateVoteTallyViewController"];
    [self.navigationController pushViewController:voteTallyVC animated:YES];
}

- (void)openSenateSeatingFromModernLayout:(id)sender
{
    UIViewController *senateSeatingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SenateSeatingViewController"];
    [self.navigationController pushViewController:senateSeatingVC animated:YES];
}

- (void)openHouseSeatingFromModernLayout:(id)sender
{
    UIViewController *houseSeatingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HouseSeatingViewController"];
    [self.navigationController pushViewController:houseSeatingVC animated:YES];
}

- (UIButton *)modernRowButtonWithBadgeText:(NSString *)badgeText
                                badgeColor:(UIColor *)badgeColor
                                     title:(NSString *)title
                                  subtitle:(NSString *)subtitle
                                    action:(SEL)action
{
    UIButton *row = [UIButton buttonWithType:UIButtonTypeCustom];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.88];
    row.layer.cornerRadius = 15.0;
    row.layer.borderWidth = 1.0;
    row.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.95].CGColor;
    row.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    row.layer.shadowOpacity = 0.08;
    row.layer.shadowRadius = 6.0;
    row.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    [row.heightAnchor constraintEqualToConstant:56.0].active = YES;
    [row addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *badge = [[UIView alloc] init];
    badge.translatesAutoresizingMaskIntoConstraints = NO;
    badge.backgroundColor = badgeColor;
    badge.layer.cornerRadius = 14.0;
    [row addSubview:badge];
    
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    badgeLabel.text = badgeText;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = [UIFont boldSystemFontOfSize:12.0];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    [badge addSubview:badgeLabel];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:0.12 green:0.14 blue:0.18 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold];
    [row addSubview:titleLabel];
    
    UILabel *subtitleLabel = nil;
    if (subtitle.length > 0) {
        subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        subtitleLabel.text = subtitle;
        subtitleLabel.textColor = [UIColor colorWithWhite:0.35 alpha:1.0];
        subtitleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
        subtitleLabel.textAlignment = NSTextAlignmentRight;
        [row addSubview:subtitleLabel];
    }
    
    UILabel *chevron = [[UILabel alloc] init];
    chevron.translatesAutoresizingMaskIntoConstraints = NO;
    chevron.text = @"›";
    chevron.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    chevron.font = [UIFont systemFontOfSize:28.0 weight:UIFontWeightRegular];
    chevron.textAlignment = NSTextAlignmentCenter;
    [row addSubview:chevron];
    
    [NSLayoutConstraint activateConstraints:@[
        [badge.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:14.0],
        [badge.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [badge.widthAnchor constraintEqualToConstant:28.0],
        [badge.heightAnchor constraintEqualToConstant:28.0],
        
        [badgeLabel.leadingAnchor constraintEqualToAnchor:badge.leadingAnchor],
        [badgeLabel.trailingAnchor constraintEqualToAnchor:badge.trailingAnchor],
        [badgeLabel.topAnchor constraintEqualToAnchor:badge.topAnchor],
        [badgeLabel.bottomAnchor constraintEqualToAnchor:badge.bottomAnchor],
        
        [chevron.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-12.0],
        [chevron.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [chevron.widthAnchor constraintEqualToConstant:12.0],
        
        [titleLabel.leadingAnchor constraintEqualToAnchor:badge.trailingAnchor constant:12.0],
        [titleLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
    ]];
    
    if (subtitleLabel) {
        [NSLayoutConstraint activateConstraints:@[
            [subtitleLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
            [subtitleLabel.trailingAnchor constraintEqualToAnchor:chevron.leadingAnchor constant:-12.0],
            [subtitleLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:titleLabel.trailingAnchor constant:8.0],
        ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:chevron.leadingAnchor constant:-12.0],
        ]];
    }
    
    return row;
}

- (UIView *)modernSectionViewWithTitle:(NSString *)title rows:(NSArray<UIView *> *)rows
{
    UIView *section = [[UIView alloc] init];
    section.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:0.15 green:0.18 blue:0.22 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:34.0 weight:UIFontWeightSemibold];
    [section addSubview:titleLabel];
    
    UIStackView *rowsStack = [[UIStackView alloc] initWithArrangedSubviews:rows];
    rowsStack.translatesAutoresizingMaskIntoConstraints = NO;
    rowsStack.axis = UILayoutConstraintAxisVertical;
    rowsStack.spacing = 10.0;
    [section addSubview:rowsStack];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:section.topAnchor],
        [titleLabel.leadingAnchor constraintEqualToAnchor:section.leadingAnchor],
        [titleLabel.trailingAnchor constraintEqualToAnchor:section.trailingAnchor],
        
        [rowsStack.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10.0],
        [rowsStack.leadingAnchor constraintEqualToAnchor:section.leadingAnchor],
        [rowsStack.trailingAnchor constraintEqualToAnchor:section.trailingAnchor],
        [rowsStack.bottomAnchor constraintEqualToAnchor:section.bottomAnchor],
    ]];
    
    return section;
}

- (void)setupModernStateLandingUIIfNeeded
{
    if (self.modernStateUIBuilt || ![self isStateLandingScreen]) {
        return;
    }
    
    self.modernStateUIBuilt = YES;
    for (UIView *subview in self.view.subviews) {
        subview.hidden = YES;
    }
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.modernStateScrollView = scrollView;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:contentView];
    self.modernStateContentView = contentView;
    
    UIView *heroView = [[UIView alloc] init];
    heroView.translatesAutoresizingMaskIntoConstraints = NO;
    heroView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
    heroView.layer.cornerRadius = 18.0;
    heroView.layer.masksToBounds = YES;
    [contentView addSubview:heroView];
    
    UIImageView *heroImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    heroImage.translatesAutoresizingMaskIntoConstraints = NO;
    heroImage.contentMode = UIViewContentModeScaleAspectFill;
    heroImage.alpha = 0.52;
    [heroView addSubview:heroImage];
    
    UILabel *wyomingLabel = [[UILabel alloc] init];
    wyomingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    wyomingLabel.text = @"Wyoming\nState\nGovernment";
    wyomingLabel.textColor = [UIColor colorWithRed:0.36 green:0.18 blue:0.07 alpha:1.0];
    wyomingLabel.font = [UIFont systemFontOfSize:32.0 weight:UIFontWeightSemibold];
    wyomingLabel.textAlignment = NSTextAlignmentCenter;
    wyomingLabel.numberOfLines = 3;
    [heroView addSubview:wyomingLabel];
    
    
    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 20.0;
    [contentView addSubview:stack];
    
    UIView *peopleSection = [self modernSectionViewWithTitle:@"People" rows:@[
        [self modernRowButtonWithBadgeText:@"O" badgeColor:[UIColor colorWithRed:0.73 green:0.56 blue:0.20 alpha:1.0] title:@"Statewide Officials" subtitle:nil action:@selector(statewideButtonPressed:)],
        [self modernRowButtonWithBadgeText:@"S" badgeColor:[UIColor colorWithRed:0.20 green:0.47 blue:0.67 alpha:1.0] title:@"Senate" subtitle:nil action:@selector(senateButtonPressed:)],
        [self modernRowButtonWithBadgeText:@"H" badgeColor:[UIColor colorWithRed:0.35 green:0.57 blue:0.36 alpha:1.0] title:@"House" subtitle:nil action:@selector(houseButtonPressed:)],
    ]];
    
    UIView *committeesSection = [self modernSectionViewWithTitle:@"Committees" rows:@[
        [self modernRowButtonWithBadgeText:@"SC" badgeColor:[UIColor colorWithRed:0.20 green:0.47 blue:0.67 alpha:1.0] title:@"Senate Committees" subtitle:nil action:@selector(senateCommitteesButtonPressed:)],
        [self modernRowButtonWithBadgeText:@"HC" badgeColor:[UIColor colorWithRed:0.35 green:0.57 blue:0.36 alpha:1.0] title:@"House Committees" subtitle:nil action:@selector(houseCommitteesButtonpressed:)],
    ]];
    
    UIView *toolsSection = [self modernSectionViewWithTitle:@"Tools" rows:@[
        [self modernRowButtonWithBadgeText:@"V" badgeColor:[UIColor colorWithRed:0.73 green:0.56 blue:0.20 alpha:1.0] title:@"Vote Tally" subtitle:nil action:@selector(openVoteTallyScreenFromModernLayout:)],
        [self modernRowButtonWithBadgeText:@"S" badgeColor:[UIColor colorWithRed:0.20 green:0.47 blue:0.67 alpha:1.0] title:@"Seating Charts" subtitle:@"Senate" action:@selector(openSenateSeatingFromModernLayout:)],
        [self modernRowButtonWithBadgeText:@"H" badgeColor:[UIColor colorWithRed:0.35 green:0.57 blue:0.36 alpha:1.0] title:@"Seating Charts" subtitle:@"House" action:@selector(openHouseSeatingFromModernLayout:)],
    ]];
    
    [stack addArrangedSubview:peopleSection];
    [stack addArrangedSubview:committeesSection];
    [stack addArrangedSubview:toolsSection];
    
    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [contentView.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.widthAnchor],
        
        [heroView.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:10.0],
        [heroView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:12.0],
        [heroView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-12.0],
        [heroView.heightAnchor constraintEqualToConstant:195.0],
        
        [heroImage.topAnchor constraintEqualToAnchor:heroView.topAnchor],
        [heroImage.leadingAnchor constraintEqualToAnchor:heroView.leadingAnchor],
        [heroImage.trailingAnchor constraintEqualToAnchor:heroView.trailingAnchor],
        [heroImage.bottomAnchor constraintEqualToAnchor:heroView.bottomAnchor],
        
        [wyomingLabel.centerXAnchor constraintEqualToAnchor:heroView.centerXAnchor],
        [wyomingLabel.centerYAnchor constraintEqualToAnchor:heroView.centerYAnchor],
        [wyomingLabel.leadingAnchor constraintEqualToAnchor:heroView.leadingAnchor constant:20.0],
        [wyomingLabel.trailingAnchor constraintEqualToAnchor:heroView.trailingAnchor constant:-20.0],
        
        [stack.topAnchor constraintEqualToAnchor:heroView.bottomAnchor constant:18.0],
        [stack.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:12.0],
        [stack.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-12.0],
        [stack.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-18.0],
    ]];
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
    [self setupModernStateLandingUIIfNeeded];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (void)collectButtonsFromView:(UIView *)view into:(NSMutableArray *)buttons
{
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [buttons addObject:subview];
        }
        if ([subview.subviews count] > 0) {
            [self collectButtonsFromView:subview into:buttons];
        }
    }
}

- (NSArray *)allButtonsInView:(UIView *)view
{
    NSMutableArray *buttons = [NSMutableArray array];
    [self collectButtonsFromView:view into:buttons];
    return buttons;
}

- (void)styleSeatingRowButton:(UIButton *)button title:(NSString *)title fontSize:(CGFloat)fontSize
{
    NSString *styledTitle = title;
    const CGFloat leftPadding = 10.0f;
    const CGFloat rightPadding = 8.0f;
    [button setTitle:styledTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.titleLabel.lineBreakMode = NSLineBreakByClipping;
    button.titleLabel.adjustsFontSizeToFitWidth = NO;
    
    // Expand legacy fixed-width button so full title fits (avoid truncation),
    // but keep the left edge fixed so it doesn't encroach on the chair icon.
    CGSize textSize = [styledTitle sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    CGFloat targetWidth = MAX(142.0, ceil(textSize.width) + leftPadding + rightPadding);
    CGRect frame = button.frame;
    CGFloat leftEdge = frame.origin.x;
    frame.size.width = targetWidth;
    frame.origin.x = leftEdge;
    
    // Keep full row inside panel bounds.
    UIView *container = button.superview;
    if (container) {
        CGFloat rightMargin = 2.0;
        CGFloat maxWidth = CGRectGetWidth(container.bounds) - frame.origin.x - rightMargin;
        frame.size.width = MIN(frame.size.width, maxWidth);
    }
    button.frame = frame;
    
    button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.78];
    button.layer.cornerRadius = 14.0;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.95].CGColor;
    button.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    button.layer.shadowOpacity = 0.14;
    button.layer.shadowRadius = 6.0;
    button.layer.shadowOffset = CGSizeMake(0.0, 2.0);
}

- (void)styleSeatingIconButton:(UIButton *)iconButton alignedTo:(UIButton *)rowButton
{
    if (!iconButton || !rowButton) {
        return;
    }
    
    CGRect frame = iconButton.frame;
    frame.origin.y = rowButton.frame.origin.y - 1.0;
    frame.size.width = 32.0;
    frame.size.height = 32.0;
    iconButton.frame = frame;
    
    iconButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.78];
    iconButton.layer.cornerRadius = 16.0;
    iconButton.layer.borderWidth = 1.0;
    iconButton.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.95].CGColor;
    iconButton.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    iconButton.layer.shadowOpacity = 0.12;
    iconButton.layer.shadowRadius = 4.0;
    iconButton.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    [iconButton.superview bringSubviewToFront:iconButton];
}

- (UIButton *)nearestIconButtonForRow:(UIButton *)rowButton fromButtons:(NSArray *)buttons
{
    UIButton *best = nil;
    CGFloat bestDistance = CGFLOAT_MAX;
    
    for (UIButton *candidate in buttons) {
        if (candidate == rowButton) {
            continue;
        }
        
        CGRect frame = candidate.frame;
        BOOL looksLikeIcon = frame.size.width <= 50.0 && frame.size.height <= 50.0 && frame.origin.x < rowButton.frame.origin.x;
        if (!looksLikeIcon) {
            continue;
        }
        
        CGFloat yDistance = fabs(CGRectGetMidY(frame) - CGRectGetMidY(rowButton.frame));
        if (yDistance < bestDistance) {
            bestDistance = yDistance;
            best = candidate;
        }
    }
    
    return bestDistance <= 14.0 ? best : nil;
}

- (void)styleSeatingRows
{
    NSArray *buttons = [self allButtonsInView:self.view];
    UIButton *senateRow = nil;
    UIButton *houseRow = nil;
    UIButton *voteTallyRow = nil;
    
    for (UIButton *button in buttons) {
        NSString *title = [button titleForState:UIControlStateNormal];
        if (!title) {
            continue;
        }
        if ([title rangeOfString:@"Senate Seating"].location != NSNotFound) {
            senateRow = button;
        } else if ([title rangeOfString:@"House Seating"].location != NSNotFound) {
            houseRow = button;
        } else if ([title rangeOfString:@"Vote Tally"].location != NSNotFound) {
            voteTallyRow = button;
        }
    }
    
    CGFloat seatingFontSize = 16.0;
    if (voteTallyRow.titleLabel.font.pointSize > 0.0) {
        seatingFontSize = voteTallyRow.titleLabel.font.pointSize;
    }
    
    if (senateRow) {
        UIButton *senateIcon = [self nearestIconButtonForRow:senateRow fromButtons:buttons];
        [self styleSeatingRowButton:senateRow title:@"Senate Seating" fontSize:seatingFontSize];
        [self styleSeatingIconButton:senateIcon alignedTo:senateRow];
        if (senateIcon) {
            CGRect rowFrame = senateRow.frame;
            CGFloat minRowX = CGRectGetMaxX(senateIcon.frame) + 4.0;
            rowFrame.origin.x = MAX(rowFrame.origin.x, minRowX);
            UIView *container = senateRow.superview;
            if (container) {
                CGFloat rightMargin = 2.0;
                rowFrame.size.width = MIN(rowFrame.size.width, CGRectGetWidth(container.bounds) - rowFrame.origin.x - rightMargin);
            }
            senateRow.frame = rowFrame;
        }
    }
    if (houseRow) {
        UIButton *houseIcon = [self nearestIconButtonForRow:houseRow fromButtons:buttons];
        [self styleSeatingRowButton:houseRow title:@"House Seating" fontSize:seatingFontSize];
        [self styleSeatingIconButton:houseIcon alignedTo:houseRow];
        if (houseIcon) {
            CGRect rowFrame = houseRow.frame;
            CGFloat minRowX = CGRectGetMaxX(houseIcon.frame) + 4.0;
            rowFrame.origin.x = MAX(rowFrame.origin.x, minRowX);
            UIView *container = houseRow.superview;
            if (container) {
                CGFloat rightMargin = 2.0;
                rowFrame.size.width = MIN(rowFrame.size.width, CGRectGetWidth(container.bounds) - rowFrame.origin.x - rightMargin);
            }
            houseRow.frame = rowFrame;
        }
    }
    
    if (voteTallyRow) {
        [voteTallyRow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [voteTallyRow setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
}

- (void)styleVoteTallyActionButtonsIfNeeded
{
    BOOL isVoteTallyScreen = NO;
    for (UIView *subview in self.view.subviews) {
        for (UIView *nested in subview.subviews) {
            if ([nested isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)nested;
                if ([label.text isEqualToString:@"Vote Tally"]) {
                    isVoteTallyScreen = YES;
                    break;
                }
            }
        }
        if (isVoteTallyScreen) break;
    }
    if (!isVoteTallyScreen) {
        return;
    }
    
    NSArray *buttons = [self allButtonsInView:self.view];
    NSMutableArray<UIButton *> *voteActionButtons = [NSMutableArray array];
    UIButton *backButton = nil;
    CGFloat safeTop = 20.0f;
    if (@available(iOS 11.0, *)) {
        safeTop = self.view.safeAreaInsets.top;
    }
    
    for (UIButton *button in buttons) {
        NSArray<NSString *> *actions = [button actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if (actions.count == 0) {
            continue;
        }
        NSString *action = actions.firstObject;
        if ([action isEqualToString:@"backButtonPressed:"]) {
            backButton = button;
            continue;
        }
        BOOL isVoteAction = (
            [action isEqualToString:@"senateVoteButtonPressed:"] ||
            [action isEqualToString:@"senateVoteCommitteesButtonPressed:"] ||
            [action isEqualToString:@"houseVoteButtonPressed:"] ||
            [action isEqualToString:@"houseVoteCommitteesButtonPressed:"] ||
            [action isEqualToString:@"allVoteButtonPressed:"]
        );
        if (!isVoteAction) {
            continue;
        }
        [voteActionButtons addObject:button];
        
        button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.82];
        button.layer.cornerRadius = 14.0f;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.96].CGColor;
        button.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
        button.layer.shadowOpacity = 0.14f;
        button.layer.shadowRadius = 5.0f;
        button.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    }
    
    // Replace legacy "State" back badge with the same modern chevron treatment.
    if (backButton) {
        [backButton setBackgroundImage:nil forState:UIControlStateNormal];
        [backButton setTitle:@"" forState:UIControlStateNormal];
        backButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.88];
        backButton.layer.cornerRadius = 10.0f;
        backButton.layer.masksToBounds = YES;
        if (@available(iOS 13.0, *)) {
            UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:24.0 weight:UIImageSymbolWeightHeavy];
            UIImage *chevron = [UIImage systemImageNamed:@"chevron.left" withConfiguration:symbolConfig];
            [backButton setImage:chevron forState:UIControlStateNormal];
            [backButton setTintColor:[UIColor colorWithRed:0.13 green:0.17 blue:0.22 alpha:1.0]];
        } else {
            [backButton setTitle:@"<" forState:UIControlStateNormal];
            [backButton setTitleColor:[UIColor colorWithRed:0.13 green:0.17 blue:0.22 alpha:1.0] forState:UIControlStateNormal];
            backButton.titleLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        }
        backButton.accessibilityLabel = @"Back";
        CGRect frame = backButton.frame;
        frame.origin.x = 8.0f;
        frame.origin.y = safeTop + 4.0f;
        frame.size.width = 44.0f;
        frame.size.height = 44.0f;
        backButton.frame = frame;
    }
    
    // Move vote tally action buttons down by ~5% of screen height.
    if (voteActionButtons.count > 0) {
        [voteActionButtons sortUsingComparator:^NSComparisonResult(UIButton *a, UIButton *b) {
            if (a.frame.origin.y < b.frame.origin.y) return NSOrderedAscending;
            if (a.frame.origin.y > b.frame.origin.y) return NSOrderedDescending;
            return NSOrderedSame;
        }];
        CGFloat offsetY = floor(self.view.bounds.size.height * 0.05f);
        CGFloat maxBottom = CGRectGetHeight(self.view.bounds) - 14.0f;
        if (self.tabBarController && !self.tabBarController.tabBar.hidden) {
            CGRect tabBarFrameInSelf = [self.view convertRect:self.tabBarController.tabBar.frame fromView:self.tabBarController.view];
            maxBottom = CGRectGetMinY(tabBarFrameInSelf) - 8.0f;
        }
        
        for (UIButton *button in voteActionButtons) {
            CGRect frame = button.frame;
            frame.origin.y += offsetY;
            button.frame = frame;
        }
        
        UIButton *lastButton = [voteActionButtons lastObject];
        CGFloat overflow = CGRectGetMaxY(lastButton.frame) - maxBottom;
        if (overflow > 0.0f) {
            for (UIButton *button in voteActionButtons) {
                CGRect frame = button.frame;
                frame.origin.y -= overflow;
                button.frame = frame;
            }
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setupModernStateLandingUIIfNeeded];
    if ([self isStateLandingScreen]) {
        return;
    }
    
    // The legacy storyboard uses fixed frames. Keep the large State content panels
    // above the tab bar across device sizes by shifting/compressing as needed.
    CGFloat availableBottom = CGRectGetHeight(self.view.bounds);
    if (self.tabBarController && !self.tabBarController.tabBar.hidden) {
        CGRect tabBarFrameInSelf = [self.view convertRect:self.tabBarController.tabBar.frame
                                                 fromView:self.tabBarController.view];
        availableBottom = MIN(availableBottom, CGRectGetMinY(tabBarFrameInSelf));
    }
    
    CGFloat desiredBottom = availableBottom - 8.0;
    CGFloat minimumTop = 52.0;
    
    for (UIView *subview in self.view.subviews) {
        CGRect frame = subview.frame;
        BOOL isStateContentPanel = (
            frame.size.height > 540.0 &&
            frame.size.width > 300.0 &&
            frame.origin.x >= 20.0 &&
            frame.origin.x <= 40.0
        );
        
        if (!isStateContentPanel) {
            continue;
        }
        
        CGFloat overlap = CGRectGetMaxY(frame) - desiredBottom;
        if (overlap > 0.0) {
            frame.origin.y -= overlap;
        }
        
        // If we hit the top guardrail, trim panel height a bit to preserve bottom clearance.
        if (frame.origin.y < minimumTop) {
            CGFloat extra = minimumTop - frame.origin.y;
            frame.origin.y = minimumTop;
            frame.size.height = MAX(400.0, frame.size.height - extra);
        }
        
        subview.frame = frame;
    }
    
    [self styleSeatingRows];
    [self styleVoteTallyActionButtonsIfNeeded];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
