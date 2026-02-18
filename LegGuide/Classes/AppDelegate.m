//
//  AppDelegate.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 7/21/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "DataLoader.h"
#import "Boundary.h"
#import "ModalAlert.h"
#import "NSDictionary+People.h"
#import "NSString+Stuff.h"
#import "Definitions.h"
#import "SSZipArchive.h"

@implementation AppDelegate

@synthesize window = _window;


@synthesize all=_all; 
@synthesize stateSenate=_stateSenate; 
@synthesize stateHouse=_stateHouse; 
@synthesize federalSenate=_federalSenate; 
@synthesize federalHouse=_federalHouse; 
@synthesize statewide=_statewide;
@synthesize oaecMembers=_oaecMembers;
@synthesize legislativeContacts=_legislativeContacts;
@synthesize judiciary1=_judiciary1;
@synthesize judiciary2=_judiciary2;

@synthesize stateSenateStandingCommittees=_stateSenateStandingCommittees;
@synthesize stateHouseStandingCommittees=_stateHouseStandingCommittees;
@synthesize stateSenateAppropriationsSubcommittees=_stateSenateAppropriationsSubcommittees;
@synthesize stateHouseAppropriationsSubcommittees=_stateHouseAppropriationsSubcommittees;
@synthesize countyBoundaries=_countyBoundaries;
@synthesize municipalBoundaries=_municipalBoundaries;
@synthesize congressionalBoundaries=_congressionalBoundaries;
@synthesize stateSenateBoundaries=_stateSenateBoundaries;
@synthesize stateHouseBoundaries=_stateHouseBoundaries;
@synthesize coopBoundaries=_coopBoundaries;
@synthesize alertView=_alertView;


- (void)weblink {
    NSURL *url = [NSURL URLWithString:WEB_ADDRESS];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void)otherLink1 {
    NSURL *url = [NSURL URLWithString:OTHER_WEB_1];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    return YES;
}

- (void)downloadImmediateData {
    [self downloadSpreadsheet];
    [self downloadPhotosZipFile];
}

- (void)populateSpreadsheetData {
    
    NSLog(@"start load");
    
    self.stateSenate    = [self.all filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type=%@",STATE_SENATE]];
    self.stateHouse     = [self.all filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type=%@",STATE_HOUSE]];
    self.federalSenate  = [self.all filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type=%@",FEDERAL_SENATE]];
    self.federalHouse   = [self.all filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type=%@",FEDERAL_HOUSE]];
    self.statewide      = [self.all filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type=%@",STATEWIDE]];
    self.judiciary1     = [self.all filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type=%@",JUDICIARY1]];
    self.judiciary2     = [self.all filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type=%@",JUDICIARY2]];
    
    self.oaecMembers     = [self.all filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type=%@",WREA_MEMBER]];
    self.legislativeContacts = [self.all filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type=%@",LEGISLATIVE_CONTACT]];

    // alpha order senate, house
    
    NSSortDescriptor *sortByLastName = [[NSSortDescriptor alloc] initWithKey:@"Last Name" ascending:YES];
    NSSortDescriptor *sortByFirstName = [[NSSortDescriptor alloc] initWithKey:@"First Name" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortByLastName,sortByFirstName, nil];
    
    self.stateSenate = [self.stateSenate sortedArrayUsingDescriptors:sortDescriptors];
    self.stateHouse = [self.stateHouse sortedArrayUsingDescriptors:sortDescriptors];
    
    NSLog(@"all count %lu",(unsigned long)[self.all count]);
    NSLog(@"state senate count %lu",(unsigned long)[self.stateSenate count]);
    
    
    self.stateSenateStandingCommittees = [DataLoader buildCommitteesFromPeople:self.stateSenate committeeKey:STANDING];
    self.stateHouseStandingCommittees  = [DataLoader buildCommitteesFromPeople:self.stateHouse committeeKey:STANDING];
    self.stateSenateAppropriationsSubcommittees  = [DataLoader buildCommitteesFromPeople:self.stateSenate committeeKey:APPROPRIATIONS];
    self.stateHouseAppropriationsSubcommittees = [DataLoader buildCommitteesFromPeople:self.stateHouse committeeKey:APPROPRIATIONS];
   
    // Resort OAEC Member Systems by company name then contact name

    NSSortDescriptor *sortOrderSort = [NSSortDescriptor sortDescriptorWithKey:@"Sort Order Number" ascending:YES];
    NSSortDescriptor *companySort = [NSSortDescriptor sortDescriptorWithKey:@"Cooperative Name" ascending:YES];
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"Last Name" ascending:YES];
    NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"First Name" ascending:YES];
    
    sortDescriptors = [NSArray arrayWithObjects:sortOrderSort,companySort,lastNameSort,firstNameSort,nil];
    
    self.oaecMembers = [self.oaecMembers sortedArrayUsingDescriptors:sortDescriptors];
    
}



- (void)downloadSpreadsheet {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dirPaths;
    NSString *docsDir;
    
    
    NSURL *URL = [NSURL URLWithString:@"https://www.dropbox.com/s/rm99ldi2pyyyea5/data.csv?raw=1"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSString *csvFilename = [NSString stringWithFormat:@"%@/%@", docsDir, @"data.csv"];
    if ([fileManager fileExistsAtPath:csvFilename ] == YES)
    {
        NSError *error;
        [fileManager removeItemAtPath:csvFilename error:&error];
        NSLog (@"File deleted");
    }
    else
    {
        NSLog (@"File not found");
    }
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        mapDataLoaded = NO;
        NSString *harddataFilename = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"csv"];
        NSString *previousDataFilename = [NSString stringWithFormat:@"%@/%@", docsDir, @"previousdata.csv"];
        NSString *csvFilename = [NSString stringWithFormat:@"%@/%@", docsDir, @"data.csv"];
        if (location != nil) {
            NSURL *destURL = [NSURL fileURLWithPath:csvFilename];
            [fileManager removeItemAtURL:destURL error:nil];
            [fileManager copyItemAtURL:location toURL:destURL error:nil];
        }
        if ([fileManager fileExistsAtPath:csvFilename] == YES) {
            // Load from recently downloaded csvFilename
            self.all = [DataLoader loadCSVFile:csvFilename];
            // Remove previousDataFilename
            [fileManager removeItemAtPath:previousDataFilename error:&error];
            // Copy recently downloaded csvFilename to previousDataFilename
            [fileManager copyItemAtPath:csvFilename toPath:previousDataFilename error:&error];
            // Remove csvFilename in preparation for next download
            [fileManager removeItemAtPath:csvFilename error:&error];
        } else if ([fileManager fileExistsAtPath:previousDataFilename]) {
            self.all = [DataLoader loadCSVFile:previousDataFilename];
        } else {
            self.all = [DataLoader loadCSVFile:harddataFilename];
        }
        [self populateSpreadsheetData];
    }];
    [downloadTask resume];
    
}


- (void)downloadPhotosZipFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Extract bundled photos immediately so they're available before async download completes.
    // This fixes missing photos on first launch, when network is slow, or when previousPhotos is stale.
    NSString *bundledPhotosPath = [[NSBundle mainBundle] pathForResource:@"photos" ofType:@"zip"];
    if (bundledPhotosPath != nil) {
        [DataLoader loadPhotosFile:bundledPhotosPath];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Download photos
    NSURL *PHOTOS_URL = [NSURL URLWithString:@"https://www.dropbox.com/s/91facx85r9llxh9/photos.zip?raw=1"];
    
    NSURLRequest *photo_file_request = [NSURLRequest requestWithURL:PHOTOS_URL];
    
    NSString *photosFilename = [NSString stringWithFormat:@"%@/%@", docsDir, @"photos.zip"];
    if ([fileManager fileExistsAtPath:photosFilename ] == YES)
    {
        NSError *error;
        [fileManager removeItemAtPath:photosFilename error:&error];
        NSLog (@"File deleted");
    }
    else
    {
        NSLog (@"File not found");
    }
    
    NSURLSessionDownloadTask *photosDownloadTask = [session downloadTaskWithRequest:photo_file_request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSString *hardphotosFilename = [[NSBundle mainBundle] pathForResource:@"photos" ofType:@"zip"];
        NSString *previousPhotosFilename = [NSString stringWithFormat:@"%@/%@", docsDir, @"previousphotos.zip"];
        NSString *photosFilename = [NSString stringWithFormat:@"%@/%@", docsDir, @"photos.zip"];
        if (location != nil) {
            NSURL *destURL = [NSURL fileURLWithPath:photosFilename];
            [fileManager removeItemAtURL:destURL error:nil];
            [fileManager copyItemAtURL:location toURL:destURL error:nil];
        }
        if ([fileManager fileExistsAtPath:photosFilename] == YES) {
            // Load from recently downloaded csvFilename
            [DataLoader loadPhotosFile:photosFilename];
            // Remove previousDataFilename
            [fileManager removeItemAtPath:previousPhotosFilename error:&error];
            // Copy recently downloaded csvFilename to previousDataFilename
            [fileManager copyItemAtPath:photosFilename toPath:previousPhotosFilename error:&error];
            // Remove csvFilename in preparation for next download
            [fileManager removeItemAtPath:photosFilename error:&error];
        } else if ([fileManager fileExistsAtPath:previousPhotosFilename]) {
            [DataLoader loadPhotosFile:previousPhotosFilename];
        } else {
            [DataLoader loadPhotosFile:hardphotosFilename];
        }
        
    }];
    [photosDownloadTask resume];
    
}

-(void) realLoadBoundaries {
    NSLog(@"Load boundaries");
    
    self.countyBoundaries        = [Boundary buildBoundaryDictionaryWithJSONFile:[[NSBundle mainBundle] pathForResource:@"Counties" ofType:@"json"]]; // TULSA
    //self.municipalBoundaries     = [Boundary buildBoundaryDictionaryWithJSONFile:[[NSBundle mainBundle] pathForResource:@"Municipalities" ofType:@"json"]]; // Tulsa
    //self.congressionalBoundaries = [Boundary buildBoundaryDictionaryWithJSONFile:[[NSBundle mainBundle] pathForResource:@"CongressionalDistricts" ofType:@"json"]]; // 01
    self.stateSenateBoundaries   = [Boundary buildBoundaryDictionaryWithJSONFileFromQGISExport:[[NSBundle mainBundle] pathForResource:@"StateSenateDistricts2023" ofType:@"json"] andDistrictType:@"State Senate District" ];
    self.stateHouseBoundaries    = [Boundary buildBoundaryDictionaryWithJSONFileFromQGISExport:[[NSBundle mainBundle] pathForResource:@"StateHouseDistricts2023" ofType:@"json"] andDistrictType:@"State House District" ];
    self.coopBoundaries          = [Boundary buildBoundaryDictionaryWithJSONFile:[[NSBundle mainBundle] pathForResource:@"MemberSystems" ofType:@"json"]];
    
    NSLog(@"stop load");
    
    
    // Data Integrity Test
    
    if (YES) {
        
        for(NSDictionary *person in self.all) {
            
            NSDictionary *districtBoundaries=nil;
            NSString *districtNumber=nil;
            
            if ([person.type isEqualToString:STATE_HOUSE]) {
                districtNumber = [NSString stringWithFormat:@"%i",[person.districtNumber intValue]];
                districtBoundaries=self.stateHouseBoundaries;
            } else if ([person.type isEqualToString:STATE_SENATE]) {
                districtNumber = [NSString stringWithFormat:@"%i",[person.districtNumber intValue]];
                districtBoundaries=self.stateSenateBoundaries;
            } else if ([person.type isEqualToString:STATEWIDE]) {
            } else if ([person.type isEqualToString:FEDERAL_HOUSE]) {
                districtNumber = [NSString stringWithFormat:@"%02i",[person.districtNumber intValue]];
                districtBoundaries=self.congressionalBoundaries;
            } else if ([person.type isEqualToString:FEDERAL_SENATE]) {
            }   
            
            if (districtBoundaries!=nil) {
                Boundary *districtBoundary = [districtBoundaries objectForKey:districtNumber];
                if (districtBoundary==nil) {
                    NSLog(@"%@ %@ %@ District NOT found: %@",person.type,person.firstName,person.lastName,districtNumber);
                }
            }
            
            NSArray *counties = [person.countiesCovered componentsSeparatedByString:@"~"];
            for (NSString *county in counties) {
                Boundary *countyBoundary = [self.countyBoundaries objectForKey:[[county uppercaseString] trim]];
                if (county!=nil && [county length]>0 && countyBoundary==nil) {
                    NSLog(@"%@ %@ %@ County NOT found: %@",person.type,person.firstName,person.lastName,[[county uppercaseString] trim]);
                }
            }
        }
        
    }
    
    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
    self.alertView=nil;
}

-(void) loadBoundaries {
    if (mapDataLoaded) return;

    mapDataLoaded = YES;
    self.alertView = [ModalAlert noButtonAlertWithTitle:@"Loading Map Data" message:@"Please wait..."];
    [self performSelector:@selector(realLoadBoundaries) withObject:nil afterDelay:0.01];
}

-(void) displayMessage:(NSTimer *)theTimer {
    NSLog(@"Now?");
    if (!mapDataLoaded || self.alertView!=nil) return;
    
    
    NSLog(@"Fire!");
    [theTimer invalidate];
    
    NSString *messageTitle = [self.message objectAtIndex:0];
    NSString *messageText = [self.message objectAtIndex:1];
    NSString *messageURL = [self.message objectAtIndex:2];
    NSString *buttonText = [self.message objectAtIndex:3];
    
    NSString *button2Text = @"Cancel";
    
    if (messageText==nil || [messageText length]==0) {
        buttonText=nil;
        button2Text=@"Ok";
    }
    
    int answer = (int)[ModalAlert queryWith:messageText title:messageTitle button1:buttonText button2:button2Text];
    
    NSLog(@"Answer == %i",answer);

    if (answer==0 && buttonText!=nil) {
        NSURL *url = [NSURL URLWithString:messageURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void) startTheTimer {
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(displayMessage:) userInfo:nil repeats:YES];
}

-(void) checkForUpdateMessage {
    
    NSLog(@"Check");
    
    
    NSString *filename = [NSString stringWithFormat:@"updatemessage.%@.json", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    NSString *stringURL = [NSString stringWithFormat:@"http://architactile.com/OAECMessage/%@/%@",[[NSBundle mainBundle] bundleIdentifier],filename];
    
    NSLog(@"Url = %@",stringURL);
    
    NSURL  *url = [NSURL URLWithString:stringURL];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = (int)[httpResponse statusCode];
    
    if (code==200) {
        
        NSLog(@"Yulp.");
        error = nil;
        self.message = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        

        if (error == nil && self.message !=nil && [self.message count]==4) {
        
            NSLog(@"Yulp!");

            [self performSelectorOnMainThread:@selector(startTheTimer) withObject:nil waitUntilDone:NO];
        }
        
    }
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    NSLog(@"Did become active");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self downloadImmediateData];
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
