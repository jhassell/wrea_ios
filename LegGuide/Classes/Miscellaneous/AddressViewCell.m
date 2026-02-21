//
//  AddressViewCell.m
//  OAECLegGuide
//
//  Created by Matt Galloway on 8/3/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import "AddressViewCell.h"

@implementation AddressViewCell

static void OpenExternalURL(NSURL *url) {
    if (url == nil) {
        return;
    }
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

static UIViewController *OwningViewController(UIView *view) {
    UIResponder *responder = view;
    while (responder != nil) {
        responder = [responder nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

static void ShowUnsupportedDeviceAlert(UIView *view) {
    UIViewController *viewController = OwningViewController(view);
    if (viewController == nil) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Sorry, but I can't seem to figure out how to dial the phone on this device."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@synthesize name;
@synthesize addressLine1;
@synthesize addressLine2;
@synthesize phoneNumber;
@synthesize emailAddress;
@synthesize phoneInvisibleButton;
@synthesize emailInvisibleButton;
@synthesize phoneButton;
@synthesize emailButton;
@synthesize mapButton;
@synthesize pvc;
@synthesize phoneNumberToDial=_phoneNumberToDial;


- (IBAction)dial:(id)sender {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        OpenExternalURL([NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumberToDial]]);
    } else {
        ShowUnsupportedDeviceAlert(self);
    }
}


- (IBAction)message:(id)sender {
    UIDevice *device = [UIDevice currentDevice];
    NSString *phoneString = [(NSString *)self.phoneNumberToDial stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@")" withString:@"-"];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        OpenExternalURL([NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", phoneString]]);
    } else {
        ShowUnsupportedDeviceAlert(self);
    }
}


- (IBAction)email:(id)sender {
    [pvc emailButtonPressed:sender];
}

- (IBAction)mapButtonPressed:(id)sender {
    
    NSString *provider = @"google";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)
    {
        provider = @"apple";
    }
    
    
    NSString *addrurl = [NSString stringWithFormat:@"http://maps.%@.com/maps?q=%@, %@",provider,addressLine1.text,addressLine2.text];
    NSLog(@"addurl = %@",addrurl);
    
    NSString *encodedURLString = [addrurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedURLString];
    OpenExternalURL(url);

}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
