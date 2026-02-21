//
//  CommitteeListViewController.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/31/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import "CommitteeListViewController.h"
#import "ListSection.h"
#import "Committee.h"
#import "PeopleListViewController.h"
#import "CommitteeListViewCell.h"
#import "AppDelegate.h"
#import "NSDictionary+People.h"
#import "NSString+Stuff.h"

@interface CommitteeListViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *backgroundArtworkImageView;
@property (strong, nonatomic) IBOutlet UIView *headerBackgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *headerLogoImageView;
@property (strong, nonatomic) IBOutlet UIButton *headerWebButton;
@property (strong, nonatomic) IBOutlet UIButton *headerBackButton;

- (IBAction)backButtonPushed:(id)sender;

@end

@implementation CommitteeListViewController
@synthesize table=_table;
@synthesize sections=_sections;


-(IBAction) weblink {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] weblink];
}

- (IBAction)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.table.indexPathForSelectedRow!=nil) {
        [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    }
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
    
    CGRect tableFrame = self.table.frame;
    tableFrame.origin.y = safeTop + headerHeight;
    tableFrame.size.height = self.view.bounds.size.height - tableFrame.origin.y;
    tableFrame.size.width = self.view.bounds.size.width;
    self.table.frame = tableFrame;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor=[UIColor whiteColor];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.sections==nil) return nil;
    if ([self.sections count]<=section) return nil;
    ListSection *listSection = [self.sections objectAtIndex:section];
    return [NSString stringWithFormat:@"%@s",listSection.title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.sections==nil) return 0;
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sections==nil) return 0;
    if (section >= [self.sections count]) return 0;
    ListSection *listSection = [self.sections objectAtIndex:section];
    if (listSection.children==nil) return 0;
    return [listSection.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommitteeListViewCell";
    CommitteeListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell==nil) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"CommitteeListCell-iPhone" owner:nil options:nil] objectAtIndex:0];
    }
    
    ListSection *listSection = [self.sections objectAtIndex:indexPath.section];
    Committee *committee = [listSection.children objectAtIndex:indexPath.row];
    
    cell.committeeNameLabel.text = committee.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ListSection *listSection = [self.sections objectAtIndex:indexPath.section];
    Committee *committee = [listSection.children objectAtIndex:indexPath.row];
    
    PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
    
    ListSection *ls1 = [[ListSection alloc] init];
    
    ls1.title = committee.name;
    ls1.children = committee.members;
    
    plvc.sections = [NSArray arrayWithObject:ls1];
    
    [self.navigationController pushViewController:plvc animated:YES];

}

@end
