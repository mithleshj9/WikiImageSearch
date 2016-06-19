//
//  IWikiSearchResponseParser.h
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 19/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WikiSearchResponseCompletionBlock)(NSArray* WikiRecords, NSError* error);

@protocol IWikiSearchResponseParser <NSObject>

- (NSArray*) parseWikiSearchResponse:(NSData*)response error:(NSError**)error;

- (void) parseWikiSearchResponse:(NSData*)response
             withCompletionBlock:(WikiSearchResponseCompletionBlock)completionBlock;
- (void) cancel;

@end
