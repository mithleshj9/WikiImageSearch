//
//  ControllerFactory.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "ControllerFactory.h"
#import "WikiSearchResultsListController.h"

@implementation ControllerFactory

+ (instancetype) sharedInstance {
    static ControllerFactory *factory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        factory = [[ControllerFactory alloc] init];
    });
    
    return factory;
}

- (id <IAppUIController, IWikiSearchController, IIconDownloadController>) createSearchUIController {
    WikiSearchResultsListController *vc = [[WikiSearchResultsListController alloc] init];
    return vc;
}



@end
