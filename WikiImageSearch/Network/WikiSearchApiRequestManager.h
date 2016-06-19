//
//  WikiSearchApiRequestManager.h
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 19/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

typedef void(^WikiThumbnailSearchCompletionHandler)(NSArray *records, NSError* error);

#import <Foundation/Foundation.h>

@interface WikiSearchApiRequestManager : NSObject

- (void) sendRequestToSearchThumbnailsForSearchText:(NSString*)searchText completionHandler:(WikiThumbnailSearchCompletionHandler)completionHandler;

- (BOOL) isParsing;
- (void) cancelCurrentRequest;

@end
