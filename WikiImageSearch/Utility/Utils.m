//
//  Utils.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 19/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"

@implementation Utils

+ (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         
                                                     }];
    
    [alert addAction:OKAction];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
