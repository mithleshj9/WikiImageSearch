//
//  IconsListController.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "WikiSearchResultsListController.h"
#import "SearchResultListModel.h"
#import "WikiSearchApiRequestManager.h"
#import "WikiRecord.h"
#import "Thumbnail.h"
#import "ImageDownloader.h"

@interface WikiSearchResultsListController()

@property (nonatomic, readwrite, strong) id <IListModel> listModel;
@property (nonatomic, readwrite) ESearchContrllerStatus status;
@property (nonatomic, readwrite, strong) NSString *searchText;
@property (nonatomic, readwrite, strong) NSMutableDictionary *iconDownloadsInProgress;
@property (nonatomic, readwrite, strong) WikiSearchApiRequestManager *requestManager;

@end

@implementation WikiSearchResultsListController

@synthesize modelObserver;

- (instancetype) init {
    self = [super init];
    if (self) {
        self.listModel = [[SearchResultListModel alloc] init];
        self.iconDownloadsInProgress = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void) cancelCurrentDownloads {
    if (self.requestManager != nil) {
        [self.requestManager cancelCurrentRequest];
        self.requestManager = nil;
    }
    [self cancelIconDownloadAtIndexPath:nil];
}

- (void) filterSearchResultsForSearchText:(NSString*)searchText {
    if ([self.searchText isEqualToString:searchText]) {
        return;
    }
    
    self.searchText = searchText;
    self.listModel.records = nil;
    [self cancelCurrentDownloads];
    
    WikiSearchApiRequestManager *rm = [[WikiSearchApiRequestManager alloc] init];
    [rm sendRequestToSearchThumbnailsForSearchText:searchText completionHandler:
     ^(NSArray*array, NSError *error) {
         self.requestManager = nil;
         if (error == nil) {
             NSMutableArray *wikiRecords = [NSMutableArray new];
             for (NSDictionary *dictionary in array) {
                 if ([dictionary isKindOfClass:[NSDictionary class]]) {
                     WikiRecord *record = [[WikiRecord alloc] initWithDictionary:dictionary];
                     [wikiRecords addObject:record];
                 }
             }
             
             if ([self.searchText isEqualToString:searchText]) {
                 self.listModel.records = [wikiRecords copy];
                 self.status = eSearchControllerStatusIdle;
                 [self.modelObserver datasetUpdated];
             }
             
         } else {
             if ([self.searchText isEqualToString:searchText]) {
                 self.status = eSearchControllerStatusIdle;
                 self.listModel.records = nil;
                 [self.modelObserver datasetUpdationFailedWithError:error];
             }
         }
    }];
    
    self.requestManager = rm;
    
}

- (ESearchContrllerStatus) status {
    if (self.requestManager != nil) {
        if ([self.requestManager isParsing]) {
            _status = eSearchControllerStatusParsingResponse;
        } else {
            _status = eSearchControllerStatusSendingRequest;
        }
    } else {
        _status = eSearchControllerStatusIdle;
    }
    
    return _status;
}

- (BOOL) iconDownloadingAtIndexPath:(NSIndexPath*)indexPath {
    ImageDownloader *iconDownloader = (self.iconDownloadsInProgress)[indexPath];
    return (iconDownloader == nil);
}

- (BOOL) startDownloadingIconAtIndexPath:(NSIndexPath*)indexPath {
    ImageDownloader *iconDownloader = (self.iconDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        NSString *iconURL = [self.listModel urlStringForIconAtIndexPath:indexPath];
        if (iconURL != nil) {
            iconDownloader = [[ImageDownloader alloc] init];
            [iconDownloader setCompletionHandler:^(UIImage *image, NSError *error){
                if (image != nil) {
                    WikiRecord *model =  self.listModel.records[indexPath.row];
                    model.thumbnail.icon = image;
                    [[self modelObserver] iconLoadedAtIndexpath:indexPath];
                } else {
                    NSLog(@"Error loading icon at indexpath %@", indexPath.description);
                }
                
            }];
            [iconDownloader startDownloadImageAtURL:iconURL];
        } else {
            return NO;
        }
        
        (self.iconDownloadsInProgress)[indexPath] = iconDownloader;
        
    }
    
    return YES;
}

// Pass nil to cancel all icon downloads
- (void) cancelIconDownloadAtIndexPath:(NSIndexPath*)indexPath {

    if (indexPath == nil) {
        NSArray *allDownloads = [self.iconDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
        
        [self.iconDownloadsInProgress removeAllObjects];
    } else {
        ImageDownloader *iconDownloader = (self.iconDownloadsInProgress)[indexPath];
        [iconDownloader cancelDownload];
    }
}

@end
