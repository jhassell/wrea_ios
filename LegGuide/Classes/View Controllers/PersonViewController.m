//
//  PersonViewController.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 8/2/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import "PersonViewController.h"
#import "NSDictionary+People.h"
#import "AppDelegate.h"
#import "NSString+Stuff.h"
#import "ListSection.h"
#import "Address.h"
#import "AddressViewCell.h"
#import "CommitteeViewCell.h"
#import "Committee.h"
#import "PeopleListViewController.h"
#import "MapsViewController.h"
#import "AddressLAViewCell.h"
#import "Definitions.h"
#import "RedButton.h"

#define SECTION_COUNTIES   @"Counties"
#define SECTION_COOP_PROFILE @"Co-op Profile"
#define SECTION_ADDRESSES  @"Addresses"
#define SECTION_COMMITTEE  @"Committee"
#define SECTION_NOTES      @"Notes"
#define SECTION_BIO     @"Bio Button"
#define SECTION_COOP_BOARD     @"Coop Board"

#define ASSISTANT       @"Assistant"
#define OFFICE_PHONE    @"Office"
#define HOME_PHONE      @"Home"
#define CELL_PHONE      @"Mobile"
#define TOLL_FREE_PHONE @"Toll Free"

#define ADDRESS_LINE_HEIGHT 38.0f
#define ADDRESS_LA_HEIGHT 55.0f;

@interface PersonViewController ()

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIView *personHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *officeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyAndDistrictLabel;
@property (strong, nonatomic) IBOutlet UILabel *termLimitLabel;

@property (strong, nonatomic) IBOutlet UIButton *mainEmailButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *linkedInButton;
@property (strong, nonatomic) IBOutlet UIButton *webpageButton;

@property (strong, nonatomic) IBOutlet UIView *photoNAView;
@property (strong, nonatomic) IBOutlet UIImageView *headshotView;
@property (strong, nonatomic) IBOutlet UITableViewCell *countiesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *committeeHeaderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *notesHeaderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *notesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *coopProfileCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *bioButtonCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *boardMembersCell;


@property (strong, nonatomic) IBOutlet UITextView *countiesListLabel;
@property (strong, nonatomic) IBOutlet UILabel *countiesListTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *countyMapButton;

@property (strong, nonatomic) IBOutlet UILabel *typeOfCoopLabel;
@property (strong, nonatomic) IBOutlet UILabel *milesOfLineLabel;
@property (strong, nonatomic) IBOutlet UILabel *activeMetersLabel;
@property (strong, nonatomic) IBOutlet UILabel *activeMetersPerMileLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfEmployeesLabel;

@property (strong, nonatomic) IBOutlet UIView *headshotModalView;
@property (strong, nonatomic) IBOutlet UIImageView *headshotImageView;
@property (strong, nonatomic) IBOutlet UIButton *headshotButton;

@property (strong, nonatomic) IBOutlet BlueButton *bioButton;

@property (strong, nonatomic) NSMutableArray *sections;

@property (strong, nonatomic) IBOutlet UIView *bioView;
@property (strong, nonatomic) IBOutlet UIWebView *bioWebView;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;

@property (strong, nonatomic) IBOutlet UILabel *boardMembersTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *boardMembersTextView;

- (IBAction)headshotButtonPressed:(id)sender;
- (IBAction)headshotModelCloseButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)linkedInButtonPressed:(id)sender;
- (IBAction)webButtonPressed:(id)sender;
- (IBAction)districtMapButtonPressed:(id)sender;
- (IBAction)bioButtonPressed:(id)sender;
- (IBAction)bioModalCloseButtonPressed:(id)sender;

@end

@implementation PersonViewController

@synthesize backButton=_backButton;
@synthesize table=_table;
@synthesize personHeaderView=_personHeaderView;
@synthesize officeLabel=_officeLabel;
@synthesize nameLabel=_nameLabel;
@synthesize titleLabel=_titleLabel;
@synthesize partyAndDistrictLabel=_partyAndDistrictLabel;
@synthesize termLimitLabel = _termLimitLabel;
@synthesize mainEmailButton=_mainEmailButton;
@synthesize facebookButton=_facebookButton;
@synthesize twitterButton=_twitterButton;
@synthesize linkedInButton=_linkedInButton;
@synthesize webpageButton=_webpageButton;
@synthesize photoNAView = _photoNAView;
@synthesize headshotView = _headshotView;
@synthesize countiesCell = _countiesCell;
@synthesize committeeHeaderCell = _committeeHeaderCell;
@synthesize notesHeaderCell = _notesHeaderCell;
@synthesize notesCell = _notesCell;
@synthesize countiesListLabel = _countiesListLabel;
@synthesize countiesListTitleLabel = _countiesListTitleLabel;
@synthesize countyMapButton = _countyMapButton;
@synthesize sections=_sections;

@synthesize person=_person;

#pragma mark - Miscellaneous

-(NSString *) addNewLineForStates:(NSString *)countiesConvered {
    
    NSString *newString = [NSString stringWithString:countiesConvered];
    
    newString = [newString stringByReplacingOccurrencesOfString:@"AL:" withString:@"\nAL:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"AK:" withString:@"\nAK:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"AZ:" withString:@"\nAZ:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"AR:" withString:@"\nAR:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"CA:" withString:@"\nCA:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"CO:" withString:@"\nCO:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"CT:" withString:@"\nCT:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"DE:" withString:@"\nDE:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"FL:" withString:@"\nFL:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"GA:" withString:@"\nGA:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"HI:" withString:@"\nHI:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"ID:" withString:@"\nID:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"IL:" withString:@"\nIL:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"IN:" withString:@"\nIN:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"IA:" withString:@"\nIA:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"KS:" withString:@"\nKS:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"KY:" withString:@"\nKY:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"LA:" withString:@"\nLA:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"ME:" withString:@"\nME:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"MD:" withString:@"\nMD:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"MA:" withString:@"\nMA:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"MI:" withString:@"\nMI:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"MN:" withString:@"\nMN:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"MS:" withString:@"\nMS:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"MO:" withString:@"\nMO:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"MT:" withString:@"\nMT:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"NE:" withString:@"\nNE:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"NV:" withString:@"\nNV:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"NH:" withString:@"\nNH:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"NJ:" withString:@"\nNJ:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"NM:" withString:@"\nNM:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"NY:" withString:@"\nNY:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"NC:" withString:@"\nNC:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"ND:" withString:@"\nND:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"OH:" withString:@"\nOH:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"OK:" withString:@"\nOK:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"OR:" withString:@"\nOR:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"PA:" withString:@"\nPA:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"RI:" withString:@"\nRI:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"SC:" withString:@"\nSC:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"SD:" withString:@"\nSD:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"TN:" withString:@"\nTN:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"TX:" withString:@"\nTX:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"UT:" withString:@"\nUT:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"VT:" withString:@"\nVT:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"VA:" withString:@"\nVA:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"WA:" withString:@"\nWA:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"WV:" withString:@"\nWV:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"WI:" withString:@"\nWI:"];
    newString = [newString stringByReplacingOccurrencesOfString:@"WY:" withString:@"\nWY:"];
    
    if ([@"\n" isEqualToString:[newString substringToIndex:1]]) {
        
        newString = [newString substringFromIndex:1];
    
    }
    
    return newString;
    
}

-(IBAction) weblink {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] weblink];
}

#pragma mark - Mailer Delegate Stuff

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UI Hooks

- (IBAction)headshotButtonPressed:(id)sender {
    
    self.headshotModalView.alpha=0.0;
    self.headshotModalView.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.headshotModalView.alpha = 1.0;
    
    [UIView commitAnimations];
    
}

-(void) hideHeadhotModal {
    self.headshotModalView.hidden=YES;
}

- (IBAction)headshotModelCloseButtonPressed:(id)sender {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.headshotModalView.alpha = 0.0;
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideHeadhotModal) withObject:nil afterDelay:0.6];
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)emailButtonPressed:(id)sender {
    
    if ([[[[self.person.email trim] lowercaseString] substringToIndex:4] isEqualToString:@"http"]) {
        NSURL *url = [NSURL URLWithString:[self.person.email trim]];
        if (![[UIApplication sharedApplication] openURL:url])
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        return;
    } else if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@""];
        NSArray *toRecipients = [NSArray arrayWithObjects:[self.person.email trim], nil];
        [mailer setToRecipients:toRecipients];
        
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
//        [self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Send Mail"
                                                        message:@"Sorry, your device doesn't support sending email."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)facebookButtonPressed:(id)sender {
    NSURL *url = [NSURL URLWithString:[self.person.facebook trim]];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (IBAction)twitterButtonPressed:(id)sender {
    NSURL *url = [NSURL URLWithString:[self.person.twitter trim]];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (IBAction)linkedInButtonPressed:(id)sender {
    NSURL *url = [NSURL URLWithString:[self.person.linkedIn trim]];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (IBAction)webButtonPressed:(id)sender {
    NSURL *url = [NSURL URLWithString:[self.person.webpage trim]];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (IBAction)districtMapButtonPressed:(id)sender {
    
    //NSLog(@"district map button pressed");
    
    MapsViewController *mvp = [[MapsViewController alloc] initWithNibName:@"MapView-iPhone" bundle:nil];
    
    mvp.person = self.person;
    
    [self.navigationController pushViewController:mvp animated:YES];
    
}

- (IBAction)bioButtonPressed:(id)sender {

    UIButton *bioButton = (UIButton *) sender;
    
    CGRect buttonFrame = [self.view convertRect:bioButton.frame fromView:bioButton.superview];
    
    self.bioLabel.text = [NSString stringWithFormat:@"%@ %@'s Bio",self.person.firstName,self.person.lastName];
    
    NSString *html = [self.person.bio stringByReplacingOccurrencesOfString:@"<br" withString:@"<br /><br" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self.person.bio length]-1)];
    html = [html stringByReplacingOccurrencesOfString:@"â€™" withString:@"'"];
    
    [self.bioWebView loadHTMLString:[NSString stringWithFormat:@"<html>%@</html>",html] baseURL:nil];

    [self.view addSubview:self.bioView];
    self.bioView.frame=buttonFrame;
    self.bioView.alpha=0.0f;
    self.bioWebView.frame = CGRectMake(self.bioWebView.frame.origin.x,
                                       self.bioWebView.frame.origin.y,
                                       self.bioWebView.frame.size.width,
                                       0.0f);
    
    
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.bioView.frame=self.view.frame;
                         self.bioView.alpha=1.0f;
                         
                         self.bioWebView.frame = CGRectMake(self.bioWebView.frame.origin.x,
                                                            self.bioWebView.frame.origin.y,
                                                            self.bioWebView.frame.size.width,
                                                            self.view.frame.size.height-self.bioWebView.frame.origin.y-15.0f);

                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
}

- (IBAction)bioModalCloseButtonPressed:(id)sender {
        
    CGRect buttonFrame = [self.view convertRect:self.bioButton.frame fromView:self.bioButton.superview];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.bioView.frame=buttonFrame;
                         self.bioView.alpha=0.0f;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self.bioView removeFromSuperview];
                     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.sections==nil) return 0;
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sections==nil) return 0;
    ListSection *listSection = [self.sections objectAtIndex:section];
    if (listSection.children==nil) return 0;

    return [listSection.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell=nil;
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    ListSection *listSection = [self.sections objectAtIndex:indexPath.section];
    
    if ([listSection.title isEqualToString:SECTION_COUNTIES]) {
        cell=self.countiesCell;
        self.countiesListLabel.text = [self addNewLineForStates:[self.person.countiesCovered stringByReplacingOccurrencesOfString:@"~" withString:@","]];

    } else if ([listSection.title isEqualToString:SECTION_COOP_PROFILE]) {

        NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
        numberFormat.usesGroupingSeparator = YES;
        numberFormat.groupingSeparator = @",";
        numberFormat.groupingSize = 3;
        
        cell=self.coopProfileCell;
        self.typeOfCoopLabel.text=self.person.coopType;
        self.milesOfLineLabel.text= [numberFormat stringFromNumber:[NSNumber numberWithInt:[self.person.milesOfLines intValue]]];
        self.numberOfEmployeesLabel.text=[numberFormat stringFromNumber:[NSNumber numberWithInt:[self.person.employees intValue]]];
        self.activeMetersLabel.text=[numberFormat stringFromNumber:[NSNumber numberWithInt:[self.person.activeMeters intValue]]];
        self.activeMetersPerMileLabel.text=self.person.activeMetersMiles;
        
    } else if ([listSection.title isEqualToString:SECTION_ADDRESSES] && [[listSection.children objectAtIndex:indexPath.row] isKindOfClass:[Address class]] ) {

        Address *address = [listSection.children objectAtIndex:indexPath.row];
                
        static NSString *AddressCellIdentifier = @"AddressCell";
        AddressViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:AddressCellIdentifier];
        
        if (addressCell == nil) {
            addressCell = [[[NSBundle mainBundle] loadNibNamed:@"PersonViewAddressCell-iPhone" owner:nil options:nil] objectAtIndex:0];
        }
        
        CGFloat baseHeight = 165.0f;
        
        if (address.phone==nil || [[address.phone trim] length]==0) {
            baseHeight-=ADDRESS_LINE_HEIGHT;
        }
        
        if (address.email==nil || [[address.email trim] length]==0) {
            baseHeight-=ADDRESS_LINE_HEIGHT;
        }
        
        addressCell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, baseHeight);
        
        addressCell.pvc=self;
        addressCell.name.text = address.name;
        addressCell.addressLine1.text = [NSString stringWithFormat:@"%@%@%@",address.address,([NSString isBlankOrNil:address.roomNumber]?@"":@", "),([NSString isBlankOrNil:address.roomNumber]?@"":address.roomNumber)];
        
        if (address.city==nil || [[address.city trim] length]==0) {
            addressCell.addressLine2.text = [NSString stringWithFormat:@"%@ %@",address.state,address.zip];
        } else {
            addressCell.addressLine2.text = [NSString stringWithFormat:@"%@, %@ %@",address.city,address.state,address.zip];
        }
        
        if ([NSString isBlankOrNil:address.email]) {
            addressCell.emailAddress.text=nil;
            addressCell.emailAddress.hidden=YES;
            addressCell.emailButton.hidden=YES;
            addressCell.emailInvisibleButton.hidden=YES;
        } else {
            addressCell.emailAddress.text=address.email;
            addressCell.emailAddress.hidden=NO;
            addressCell.emailButton.hidden=NO;
            addressCell.emailInvisibleButton.hidden=NO;
        }

        if ([NSString isBlankOrNil:address.phone]) {
            addressCell.phoneNumber.text=nil;
            addressCell.phoneNumber.hidden=YES;
            addressCell.phoneButton.hidden=YES;
            addressCell.phoneInvisibleButton.hidden=YES;
        } else {
            addressCell.phoneNumber.text=address.phone;
            addressCell.phoneNumberToDial = address.phone;
            addressCell.phoneNumber.hidden=NO;
            addressCell.phoneButton.hidden=NO;
            addressCell.phoneInvisibleButton.hidden=NO;
        }
        
        addressCell.emailAddress.textColor=[UIColor blueColor];
        
        UIDevice *device = [UIDevice currentDevice];
        
        if (![[device model] isEqualToString:@"iPhone"] ) {
            addressCell.phoneButton.hidden=YES;
            addressCell.phoneInvisibleButton.hidden=YES;
            addressCell.phoneNumber.textColor=[UIColor blackColor];
        } else {
            addressCell.phoneNumber.textColor=addressCell.emailAddress.textColor;
        }
        
        cell=addressCell;
    } else if ([listSection.title isEqualToString:SECTION_ADDRESSES] && [[listSection.children objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]]
               && [[(NSArray *)[listSection.children objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:ASSISTANT] ) {
        
        static NSString *AddressLACellIdentifier = @"AddressLACell";
       AddressLAViewCell *laCell = [tableView dequeueReusableCellWithIdentifier:AddressLACellIdentifier];

        if (laCell == nil) {
            laCell = [[[NSBundle mainBundle] loadNibNamed:@"PersonViewAddressLACell-iPhone" owner:nil options:nil] objectAtIndex:0];
        }
        
        laCell.laNameLabel.text = [[listSection.children objectAtIndex:indexPath.row] objectAtIndex:1];
        
        if ([self.person.type isEqualToString:STATE_SENATE]) {
            laCell.assistantTitleLabel.text = @"Executive Assistant";
        }

        cell=laCell;
        
    } else if ([listSection.title isEqualToString:SECTION_ADDRESSES] && [[listSection.children objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]]
               && ([[(NSArray *)[listSection.children objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:HOME_PHONE] ||
                   [[(NSArray *)[listSection.children objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:CELL_PHONE] ||
                   [[(NSArray *)[listSection.children objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:TOLL_FREE_PHONE] ||
                   [[(NSArray *)[listSection.children objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:OFFICE_PHONE])) {
                   
                   static NSString *PhoneNumberCellIdentifier = @"PhoneNumberCell";
                   AddressViewCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:PhoneNumberCellIdentifier];
                   
                   if (phoneCell == nil) {
                       phoneCell = [[[NSBundle mainBundle] loadNibNamed:@"PersonViewPhoneCell-iPhone" owner:nil options:nil] objectAtIndex:0];
                   }
                   
                   NSString *phoneType = [[listSection.children objectAtIndex:indexPath.row] objectAtIndex:0];
                   NSString *phoneString = [[listSection.children objectAtIndex:indexPath.row] objectAtIndex:1];
                   
                   phoneCell.phoneNumber.text = [NSString stringWithFormat:@"%@ (%@)",phoneString,phoneType];
                   phoneCell.phoneNumberToDial = phoneString;
                   
                   UIDevice *device = [UIDevice currentDevice];
                   
                   if (![[device model] isEqualToString:@"iPhone"] ) {
                       phoneCell.phoneButton.hidden=YES;
                       phoneCell.phoneInvisibleButton.hidden=YES;
                       phoneCell.phoneNumber.textColor=[UIColor blackColor];
                   } else {
                       phoneCell.phoneNumber.textColor=[UIColor blueColor];
                   }
                   
                   cell=phoneCell;
                   
                   
    } else if ([listSection.title isEqualToString:SECTION_COMMITTEE] && indexPath.row==0) {

        cell=self.committeeHeaderCell;
        
    } else if ([listSection.title isEqualToString:SECTION_COMMITTEE]) {
        
        Committee *committee = [listSection.children objectAtIndex:indexPath.row];
        
        static NSString *CommitteeCellIdentifier = @"CommitteeCell";
        CommitteeViewCell *committeeCell = [tableView dequeueReusableCellWithIdentifier:CommitteeCellIdentifier];
        
        if (committeeCell == nil) {
            committeeCell = [[[NSBundle mainBundle] loadNibNamed:@"PersonViewCommitteeCell-iPhone" owner:nil options:nil] objectAtIndex:0];
        }
    
        committeeCell.titleLabel.text = [NSString stringWithFormat:@"%@ on",committee.type];
        committeeCell.committeeNameLabel.text = committee.name;
        
        
        if (indexPath.row % 2 != 0) {
            committeeCell.grayBarView.hidden = YES;
        //    committeeCell.titleLabel.textColor=[UIColor whiteColor];
        //    committeeCell.committeeNameLabel.textColor=self.nameLabel.textColor;
        } else {
            committeeCell.grayBarView.hidden = NO;
        //    committeeCell.titleLabel.textColor=self.nameLabel.textColor;
        //    committeeCell.committeeNameLabel.textColor=[UIColor whiteColor];
        }
        committeeCell.titleLabel.alpha=0.50;
        committeeCell.titleLabel.textColor=self.nameLabel.textColor;
        committeeCell.committeeNameLabel.textColor=self.nameLabel.textColor;
        
        cell=committeeCell;
    } else if ([listSection.title isEqualToString:SECTION_BIO]) {
        cell=self.bioButtonCell;
        
        self.bioButton.titleLabel.textAlignment=NSTextAlignmentCenter;

        [self.bioButton setTitle:[NSString stringWithFormat:@"%@ %@'s Bio",self.person.firstName,self.person.lastName] forState:UIControlStateNormal];
    } else if ([listSection.title isEqualToString:SECTION_COOP_BOARD]) {
        cell=self.boardMembersCell;
        NSArray *members = [self.person.coopBoard componentsSeparatedByString:@"~"];
        NSMutableString *memberText = [NSMutableString stringWithString:@""];
        for (NSString *member in members) {
            if ([memberText length]>0) [memberText appendString:@"\n"];
            [memberText appendString:[member trim]];
        }
        self.boardMembersTextView.text=memberText;
        
    }
    
    return cell;
}

#pragma mark - Table view delegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListSection *listSection = [self.sections objectAtIndex:indexPath.section];
    
    if (indexPath.row==0 && listSection.firstRowHeight>0.5) {
        return listSection.firstRowHeight;
    } else if ([listSection.title isEqualToString:SECTION_ADDRESSES] && [[listSection.children objectAtIndex:indexPath.row] isKindOfClass:[Address class]]) {
        
        CGFloat baseHeight = listSection.rowHeight;
        
        Address *address = [listSection.children objectAtIndex:indexPath.row];
        
        if (address.phone==nil || [[address.phone trim] length]==0) {
            baseHeight-=ADDRESS_LINE_HEIGHT;
        }
        
        if (address.email==nil || [[address.email trim] length]==0) {
            baseHeight-=ADDRESS_LINE_HEIGHT;
        }
        
        return baseHeight;
    } else if ([listSection.title isEqualToString:SECTION_ADDRESSES] && ![[listSection.children objectAtIndex:indexPath.row] isKindOfClass:[Address class]]) {
        
        // This is a phone cell
        return 40.0;
        
    } else if ([listSection.title isEqualToString:SECTION_ADDRESSES]) {
        return ADDRESS_LA_HEIGHT;
    }
    
    return listSection.rowHeight;
}


-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListSection *listSection = [self.sections objectAtIndex:indexPath.section];
    
    if ([listSection.title isEqualToString:SECTION_COMMITTEE] && indexPath.row>0) return indexPath;
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ListSection *listSection = [self.sections objectAtIndex:indexPath.section];
    
    if ([listSection.title isEqualToString:SECTION_COMMITTEE] && indexPath.row>0) {
        
        Committee *committee = [listSection.children objectAtIndex:indexPath.row];
        
        PeopleListViewController *plvc = [[PeopleListViewController alloc] initWithNibName:@"PeopleListView-iPhone" bundle:nil];
        
        ListSection *ls1 = [[ListSection alloc] init];
        
        ls1.title = committee.name;
        ls1.children = committee.members;
        
        plvc.sections = [NSArray arrayWithObject:ls1];
        
        [self.navigationController pushViewController:plvc animated:YES];
        
    }
    
}



#pragma mark - Life Cycle Stuff

-(void) setButton:(UIButton *) button forValue:(NSString *)value {
    if (value==nil || [[value trim] length]==0) {
        button.enabled=NO;
        button.alpha=0.30f;
    } else {
        button.enabled=YES;
        button.alpha=1.00f;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.table.tableHeaderView=self.personHeaderView;
    
    if ([@"VACANT" caseInsensitiveCompare:[self.person.firstName trim]]==NSOrderedSame) {
         self.nameLabel.text  = @"Seat Vacant";
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.person.firstName,self.person.lastName];
    }
    
    [self setButton:self.mainEmailButton forValue:self.person.email];
    [self setButton:self.facebookButton forValue:self.person.facebook];
    [self setButton:self.twitterButton forValue:self.person.twitter];
    [self setButton:self.linkedInButton forValue:self.person.linkedIn];
    [self setButton:self.webpageButton forValue:self.person.webpage];

    self.officeLabel.text=@"";
    self.titleLabel.text=@"";
    self.partyAndDistrictLabel.text=@"";
    self.partyAndDistrictLabel.textColor=[UIColor darkGrayColor];
    self.termLimitLabel.text=@"";
    
    self.partyAndDistrictLabel.textColor=[UIColor whiteColor];
    self.partyAndDistrictLabel.backgroundColor = [UIColor clearColor];
    
    if ([self.person.party isEqualToString:@"R"]) {
        self.partyAndDistrictLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        
    } else if ([self.person.party isEqualToString:@"D"]) {
        self.partyAndDistrictLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
    } else {
        self.partyAndDistrictLabel.textColor=self.nameLabel.textColor;
    }
    
    self.termLimitLabel.textColor = self.partyAndDistrictLabel.textColor;

    if (self.person.termLimit!=nil && [[self.person.termLimit trim] length]>0) {
        self.termLimitLabel.text=[NSString stringWithFormat:@"Term Limit %@",self.person.termLimit];
    } else if (self.person.yearsServed!=nil && [[self.person.yearsServed trim] length]>0) {
        self.termLimitLabel.text=[NSString stringWithFormat:@"%@ Years Served",[self.person.yearsServed trim]];
    }


    
    NSString *workAddressName = LEGISLATIVE_OFFICE_DEFAULT_TITLE;
    NSString *homeAddressName = HOME_OFFICE_DEFAULT_TITLE;
    
    self.countyMapButton.hidden=NO;
    
    
    if ([self.person.type isEqualToString:STATE_HOUSE]) {
        self.officeLabel.text=STATE_REPRESENTATIVE_TITLE;
        self.titleLabel.text=self.person.titleLeadership;
        self.partyAndDistrictLabel.text = [NSString stringWithFormat:@"%@%@District %@",((self.person.party==nil || [[self.person.party trim] length]==0)?@"":self.person.party),((self.person.party==nil || [[self.person.party trim] length]==0)?@"":@"-"),self.person.districtNumber];
        self.countiesListTitleLabel.text = [NSString stringWithFormat:@"District %@ Counties",self.person.districtNumber];
    } else if ([self.person.type isEqualToString:STATE_SENATE]) {
        self.officeLabel.text=STATE_SENATOR_TITLE;
        self.titleLabel.text=self.person.titleLeadership;
        self.partyAndDistrictLabel.text = [NSString stringWithFormat:@"%@%@District %@",((self.person.party==nil || [[self.person.party trim] length]==0)?@"":self.person.party),((self.person.party==nil || [[self.person.party trim] length]==0)?@"":@"-"),self.person.districtNumber];
        self.countiesListTitleLabel.text = [NSString stringWithFormat:@"District %@ Counties",self.person.districtNumber];
    } else if ([self.person.type isEqualToString:STATEWIDE]) {
        workAddressName = @"Office";
        homeAddressName = @"Office";
        self.officeLabel.text=self.person.titleLeadership;
        self.partyAndDistrictLabel.text = self.person.party;
    } else if ([self.person.type isEqualToString:JUDICIARY1] || [self.person.type isEqualToString:JUDICIARY2]) {
        workAddressName = @"Office";
        homeAddressName = @"Office";
        self.officeLabel.text=self.person.titleLeadership;
        self.partyAndDistrictLabel.text = self.person.districtNumber;
    } else if ([self.person.type isEqualToString:FEDERAL_HOUSE]) {
        self.officeLabel.text=@"US Representative";
        self.titleLabel.text=self.person.titleLeadership;
        self.partyAndDistrictLabel.text = [NSString stringWithFormat:@"%@%@District %@",((self.person.party==nil || [[self.person.party trim] length]==0)?@"":self.person.party),((self.person.party==nil || [[self.person.party trim] length]==0)?@"":@"-"),self.person.districtNumber];
        self.countiesListTitleLabel.text = [NSString stringWithFormat:@"District %@ Counties",self.person.districtNumber];
    } else if ([self.person.type isEqualToString:FEDERAL_SENATE]) {
        self.officeLabel.text=@"US Senator";
        self.titleLabel.text=self.person.titleLeadership;
        self.partyAndDistrictLabel.text = self.person.party;
    } else if ([self.person.type isEqualToString:WREA_MEMBER]) {
        workAddressName = @"Contact Info";
        self.countiesListTitleLabel.text=@"Counties Covered";
        self.countyMapButton.hidden=YES;
        self.titleLabel.text=self.person.titleLeadership;
        self.officeLabel.text = self.person.coopName;
    } else if ([self.person.type isEqualToString:LEGISLATIVE_CONTACT]) {
        workAddressName = @"Contact Info";
        self.countyMapButton.hidden=YES;
        self.titleLabel.text=self.person.titleLeadership;
        self.officeLabel.text = self.person.coopName;
    }
    
    BOOL hasPhoto=NO;
    
    if (self.person.photo!=nil && [self.person.photo length]>0) {
        self.headshotView.image=[UIImage imageNamed:self.person.photo];
        if (self.headshotView.image!=nil) {
                hasPhoto=YES;
                self.headshotImageView.image=[UIImage imageNamed:self.person.photo];
                self.headshotButton.enabled=YES;
        } else {
            self.headshotButton.enabled=NO;
        }
    }
    
    if (hasPhoto) {
        self.headshotView.hidden=NO;
        self.photoNAView.hidden=YES;
    } else {
        self.headshotView.hidden=YES;
        self.headshotView.image=nil;
        self.photoNAView.hidden=NO;
    }
    
    self.sections=[NSMutableArray arrayWithCapacity:5];
    
    if ([self.person.type isEqualToString:WREA_MEMBER] && COOP_PROFILE) {
        ListSection *section = [[ListSection alloc] init];
        section.title = SECTION_COOP_PROFILE;
        section.children = [NSMutableArray arrayWithCapacity:1];
        [section.children addObject:SECTION_COOP_PROFILE];
        section.rowHeight=140.0f;
        section.firstRowHeight=0.0f;
        
        [self.sections addObject:section];
    }

    if ([self.person.type isEqualToString:WREA_MEMBER] && self.person.coopBoard!=nil && [self.person.coopBoard length]>0) {
        ListSection *section = [[ListSection alloc] init];
        section.title = SECTION_COOP_BOARD;
        section.children = [NSMutableArray arrayWithCapacity:1];
        [section.children addObject:self.person.coopBoard];
        section.rowHeight=165.0f;
        section.firstRowHeight=0.0f;
        
        [self.sections addObject:section];
    }
    
    if (self.person.countiesCovered!=nil && [[self.person.countiesCovered trim] length]>0) {
        
        ListSection *section = [[ListSection alloc] init];
        
        section.title = SECTION_COUNTIES;
        section.children = [NSMutableArray arrayWithCapacity:1];
        [section.children addObject:[NSString stringWithString:self.person.countiesCovered]];
        section.rowHeight=165.0f;
        section.firstRowHeight=0.0f;
        
        [self.sections addObject:section];
    }
    
    if (self.person.bio!=nil && [[self.person.bio trim] length]>0) {
        ListSection *bioButtonSection = [[ListSection alloc] init];
        bioButtonSection.title = SECTION_BIO;
        bioButtonSection.rowHeight=55.0f;
        bioButtonSection.firstRowHeight=55.0f;
        bioButtonSection.children = [NSMutableArray arrayWithCapacity:1];
        [bioButtonSection.children addObject:SECTION_BIO];
        [self.sections addObject:bioButtonSection];
    }
    
    NSString *email = nil;
    
    if (![NSString isBlankOrNil:self.person.email]) {
        email = [self.person.email trim];
    }

    ListSection *addressSection = [[ListSection alloc] init];
    
    addressSection.title = SECTION_ADDRESSES;
    addressSection.children = [NSMutableArray arrayWithCapacity:1];
    addressSection.rowHeight=165.0f;
    addressSection.firstRowHeight=0.0f;
    
    Address *address1 = [[Address alloc] init];
    
    address1.name = workAddressName;
    address1.address = self.person.officeAddress;
    address1.roomNumber = self.person.officeRmNumber;
    address1.city = self.person.officeCity;
    address1.state = self.person.officeState;
    address1.zip = self.person.officeZip;
    if (self.person.officePhone!=nil && [self.person.officePhone trim].length>0) {
        address1.phone = [NSString stringWithFormat:@"%@ (%@)",self.person.officePhone,OFFICE_PHONE];
    } else {
        address1.phone=@"";
    }
    address1.email = email;

    BOOL address1IsEmpty = YES;
    
    if (![address1 isEmpty]) {
        address1IsEmpty = NO;
        [addressSection.children addObject:address1];
        
        if (self.person.tollFreePhone !=nil && [[self.person.tollFreePhone trim] length]>0) {
            [addressSection.children addObject:[NSArray arrayWithObjects:TOLL_FREE_PHONE,self.person.tollFreePhone,nil]];
        }
        
        if (self.person.laName!=nil && [[self.person.laName trim] length]>0) {
            [addressSection.children addObject:[NSArray arrayWithObjects:ASSISTANT,self.person.laName,nil]];
        }

    }
    
    
    if (!address1IsEmpty &&  self.person.cellPhone!=nil && [[self.person.cellPhone trim] length]>0) {
        [addressSection.children addObject:[NSArray arrayWithObjects:CELL_PHONE,self.person.cellPhone,nil]];
    }


    Address *address2 = [[Address alloc] init];

    address2.name = homeAddressName;
    address2.address = self.person.homeAddress;
    address2.roomNumber = nil;
    address2.city = self.person.homeCity;
    address2.state = self.person.homeState;
    address2.zip = self.person.homeZip;
    address2.phone = nil;
    address2.email = email;
    
    if (![address2 isEmpty]) {
        if (self.person.homePhone!=nil && [self.person.homePhone trim].length>0) {
            address2.phone = [NSString stringWithFormat:@"%@ (%@)",self.person.homePhone,HOME_PHONE];
        } else {
            address2.phone = @"";
        }
        [addressSection.children addObject:address2];
        
        // No address1 so add cell phone here
        if (address1IsEmpty && self.person.cellPhone!=nil && [[self.person.cellPhone trim] length]>0) {
            [addressSection.children addObject:[NSArray arrayWithObjects:CELL_PHONE,self.person.cellPhone,nil]];
        }
        if (address1IsEmpty && self.person.officePhone !=nil && [[self.person.officePhone trim] length]>0) {
            [addressSection.children addObject:[NSArray arrayWithObjects:OFFICE_PHONE,self.person.officePhone,nil]];
        }

    } else {
        // No address 2 so add home phone afer address1
        if (self.person.homePhone!=nil && [[self.person.homePhone trim] length]>0) {
            [addressSection.children addObject:[NSArray arrayWithObjects:HOME_PHONE,self.person.homePhone,nil]];
        }
    }
    
    

    if ([addressSection.children count]>0) {
        [self.sections addObject:addressSection];
    }
    
    if (self.person.committees!=nil && [self.person.committees count]>0) {
        ListSection *committeeSection = [[ListSection alloc] init];
        
        committeeSection.title = SECTION_COMMITTEE;
        committeeSection.children = [NSMutableArray arrayWithCapacity:1];
        committeeSection.rowHeight=85.0f;
        committeeSection.firstRowHeight=50.0;
        
        [committeeSection.children addObject:COMMITTEES_ARRAY_KEY];
        
        for(Committee *committee in self.person.committees) {
            [committeeSection.children addObject:committee];
        }
        
        [self.sections addObject:committeeSection];
    }
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setBioButtonCell:nil];
    [self setBioButton:nil];
    [self setBioView:nil];
    [self setBioWebView:nil];
    [self setBioLabel:nil];
    [self setBoardMembersCell:nil];
    [self setBoardMembersTitleLabel:nil];
    [self setBoardMembersTextView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
