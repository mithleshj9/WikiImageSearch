//
//  ControllerProtocols.h
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ESearchContrllerStatus) {
    eSearchControllerStatusIdle = 0,
    eSearchControllerStatusSendingRequest,
    eSearchControllerStatusParsingResponse
};


@protocol IListModel;

@protocol UIControllerModelUpdateListener <NSObject>

- (void) datasetUpdated;
- (void) datasetUpdationFailedWithError:(NSError*)error;
- (void) iconLoadedAtIndexpath:(NSIndexPath*)indexPath;

@end

@protocol IAppUIController <NSObject>

@property (nonatomic, weak) id <UIControllerModelUpdateListener> modelObserver;
@property (nonatomic, readonly, strong) id <IListModel> listModel;

@end

@protocol IWikiSearchController <NSObject>

@property (nonatomic, readonly) ESearchContrllerStatus status;
@property (nonatomic, readonly) NSString *searchText;

- (void) filterSearchResultsForSearchText:(NSString*)searchText;

@end


@protocol IIconDownloadController <NSObject>

- (BOOL) iconDownloadingAtIndexPath:(NSIndexPath*)indexPath;
- (BOOL) startDownloadingIconAtIndexPath:(NSIndexPath*)indexPath;

// Pass nil to cancel all icon downloads
- (void) cancelIconDownloadAtIndexPath:(NSIndexPath*)indexPath;

@end

