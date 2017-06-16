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
- (IBAction)judicialButtonPressed:(id)sender;
- (IBAction)voteTallyButtonPressed:(id)sender;

@end

@implementation StateTabViewController

-(IBAction) weblink {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] weblink];
}


- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)statewideButtonPressed:(id)sender {
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil] autorelease];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:STATEWIDE, nil]];    
    
    [self.navigationController pushViewController:plvc animated:YES];

}

- (IBAction)judiciaryButtonPressed:(id)sender {
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil] autorelease];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:JUDICIARY1, JUDICIARY2, nil]];
    
    [self.navigationController pushViewController:plvc animated:YES];
}

- (IBAction)senateButtonPressed:(id)sender {
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil] autorelease];
    plvc.sections = [ListSection buildSectionsFrom:ad.stateSenate dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:STATE_SENATE, nil]];
    
    [self.navigationController pushViewController:plvc animated:YES];

}

- (IBAction)senateVoteButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    VotingListViewController *vlvc = [[[VotingListViewController alloc] initWithNibName:@"VoteListView-iPhone" bundle:nil] autorelease];
    vlvc.rc_sections = [ListSection buildSectionsFrom:ad.stateSenate dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:STATE_SENATE, nil]];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"BackgroundLight.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:vlvc.view.frame];
    backgroundImageView.image=backgroundImage;
    [vlvc.view insertSubview:backgroundImageView atIndex:0];
    
    [self.navigationController pushViewController:vlvc animated:YES];
    
}

- (IBAction)houseVoteButtonPressed:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    VotingListViewController *vlvc = [[[VotingListViewController alloc] initWithNibName:@"VoteListView-iPhone" bundle:nil] autorelease];
    vlvc.rc_sections = [ListSection buildSectionsFrom:ad.stateHouse dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects:STATE_HOUSE, nil]];
    
    [self.navigationController pushViewController:vlvc animated:YES];
    
}

- (IBAction)senateLeadershipButtonPressed:(id)sender {
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil] autorelease];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects: STATE_SENATE, nil] withTitlesOnly:YES];    
    
    [self.navigationController pushViewController:plvc animated:YES];
}

- (IBAction)senateCommitteesButtonPressed:(id)sender {
    
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    
    CommitteeListViewController *clvc = [[[CommitteeListViewController alloc] initWithNibName:@"CommitteeListView-iPhone" bundle:nil] autorelease];
    
    ListSection *ls1 = [[[ListSection alloc] init] autorelease];
    ls1.title=STANDING;
    ls1.children=[[NSArray arrayWithArray:ad.stateSenateStandingCommittees] mutableCopy];
    
    ListSection *ls2 = [[[ListSection alloc] init] autorelease];
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
    
    CommitteeVoteListViewController *clvc = [[[CommitteeVoteListViewController alloc] initWithNibName:@"CommitteeListView-iPhone" bundle:nil] autorelease];
    
    ListSection *ls1 = [[[ListSection alloc] init] autorelease];
    ls1.title=STANDING;
    ls1.children=[[NSArray arrayWithArray:ad.stateSenateStandingCommittees] mutableCopy];
    
    ListSection *ls2 = [[[ListSection alloc] init] autorelease];
    ls2.title=APPROPRIATIONS;
    ls2.children=[[NSArray arrayWithArray:ad.stateSenateAppropriationsSubcommittees] mutableCopy];
    
    clvc.sections = [NSArray arrayWithObjects:ls1,ls2,nil];
    
    [self.navigationController pushViewController:clvc animated:YES];
    
}





- (IBAction)houseButtonPressed:(id)sender {
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil] autorelease];
    plvc.sections = [ListSection buildSectionsFrom:ad.stateHouse dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects: STATE_HOUSE, nil]];
    
    [self.navigationController pushViewController:plvc animated:YES];

}

- (IBAction)houseLeadershipButtonPressed:(id)sender {
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil] autorelease];
    plvc.sections = [ListSection buildSectionsFrom:ad.all dividedBy:@"Type" catchAllKey:nil includeKeys:[NSArray arrayWithObjects: STATE_HOUSE, nil] withTitlesOnly:YES];    
    
    [self.navigationController pushViewController:plvc animated:YES];

}

- (IBAction)houseCommitteesButtonpressed:(id)sender {
    
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    
    CommitteeListViewController *clvc = [[[CommitteeListViewController alloc] initWithNibName:@"CommitteeListView-iPhone" bundle:nil] autorelease];
    
    ListSection *ls1 = [[[ListSection alloc] init] autorelease];
    ls1.title=STANDING;
    ls1.children=[[NSArray arrayWithArray:ad.stateHouseStandingCommittees] mutableCopy];

    ListSection *ls2 = [[[ListSection alloc] init] autorelease];
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
    
    CommitteeVoteListViewController *clvc = [[[CommitteeVoteListViewController alloc] initWithNibName:@"CommitteeListView-iPhone" bundle:nil] autorelease];
    
    ListSection *ls1 = [[[ListSection alloc] init] autorelease];
    ls1.title=STANDING;
    ls1.children=[[NSArray arrayWithArray:ad.stateHouseStandingCommittees] mutableCopy];
    
    ListSection *ls2 = [[[ListSection alloc] init] autorelease];
    ls2.title=APPROPRIATIONS;
    ls2.children=[[NSArray arrayWithArray:ad.stateHouseAppropriationsSubcommittees] mutableCopy];
    
    clvc.sections = [NSArray arrayWithObjects:ls1,ls2,nil];
    
    [self.navigationController pushViewController:clvc animated:YES];
    
}



- (IBAction)allButtonPressed:(id)sender {
    
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    
    PeopleListViewController *plvc = [[[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil] autorelease];
    
    ListSection *ls1 = [[[ListSection alloc] init] autorelease];
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
    
    ListSection *ls1 = [[[ListSection alloc] init] autorelease];
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
    
    ListSection *ls1 = [[[ListSection alloc] init] autorelease];
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
