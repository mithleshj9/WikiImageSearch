//
//  ControllerFactory.h
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IAppUIController,IIconDownloadController,IWikiSearchController;

@interface ControllerFactory : NSObject

+ (instancetype) sharedInstance;

- (id <IAppUIController, IWikiSearchController, IIconDownloadController>) createSearchUIController;

@end
