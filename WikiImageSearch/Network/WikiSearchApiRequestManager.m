//
//  WikiSearchApiRequestManager.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 19/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "WikiSearchApiRequestManager.h"
#import "WikiSearchJsonResponseParser.h"


typedef void(^RequestCompletionBlock)(NSData *data, NSURLResponse *response, NSError *error);

@interface WikiSearchApiRequestManager()

@property (nonatomic, strong) id <IWikiSearchResponseParser> parser;
@property (nonatomic, copy) WikiThumbnailSearchCompletionHandler completionHandler;
@property (nonatomic, strong) NSURLSessionDataTask *requestSesstionTask;


@end

@implementation WikiSearchApiRequestManager

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (RequestCompletionBlock) requestCompletionBlock {
    RequestCompletionBlock rcb = ^(NSData *data, NSURLResponse *response, NSError *error) {
    };
    return rcb;
}

- (void) toggleNetworkActivityIndicator:(BOOL)showIndicator {
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = showIndicator;
    }];
}

- (NSString *) urlStringForThumbnailSearchRequest:(NSString*)searchText{
    if (searchText == nil)
        searchText = @"";
    searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestURLString = [NSString stringWithFormat:@"https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=thumbnail&pithumbsize=50&pilimit=50&generator=prefixsearch&gpssearch=%@", searchText];
    return requestURLString;
}

- (void) sendRequest:(NSURLRequest*)request completionBlock:(RequestCompletionBlock)completionBlock {
    
    NSURLSessionDataTask *sessionTask =
    [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
                                             
         [self toggleNetworkActivityIndicator:NO];
                                        
         if (completionBlock)
             completionBlock(data, response, error);
        
     }];

    [self toggleNetworkActivityIndicator:YES];
    [sessionTask resume];
    self.requestSesstionTask = sessionTask;
}


- (void) sendRequestToSearchThumbnailsForSearchText:(NSString*)searchText completionHandler:(WikiThumbnailSearchCompletionHandler)completionHandler {
   
    NSURL *url = [NSURL URLWithString:[self urlStringForThumbnailSearchRequest:searchText]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak WikiSearchApiRequestManager *weakSelf = self;
    
    [self sendRequest:request completionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            WikiSearchJsonResponseParser *responseParser = [[WikiSearchJsonResponseParser alloc] init];
            weakSelf.parser = responseParser;
            [responseParser parseWikiSearchResponse:data withCompletionBlock:^(NSArray *array, NSError *error) {
                weakSelf.parser = nil;
                if (completionHandler)
                    completionHandler(array, error);
            }];
        } else {
            if (completionHandler)
                completionHandler(nil, error);
        }
    }];
}

- (BOOL) isParsing {
    return (self.parser != nil);
}

- (void) cancelCurrentRequest {
    [self.requestSesstionTask cancel];
    _requestSesstionTask = nil;
    
    
}

@end
