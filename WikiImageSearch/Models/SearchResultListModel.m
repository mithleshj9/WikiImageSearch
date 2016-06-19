//
//  SearchResultModel.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "SearchResultListModel.h"
#import "WikiRecord.h"
#import "Thumbnail.h"

@implementation SearchResultListModel

@synthesize records;

- (NSInteger) numberOfSections {
    return 1;
}

- (NSInteger) numberOfRecordsInSection:(NSInteger)section {
    return self.records.count;
}

- (NSString *) titleForDataAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row >= self.records.count)
        return nil;
    
    WikiRecord *record = self.records[indexPath.row];
    return record.title;
}

- (NSString*) modelIdentifierAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row >= self.records.count)
        return nil;
    
    WikiRecord *record = self.records[indexPath.row];
    return record.identifier;
}


- (UIImage*) iconAtIndex:(NSIndexPath*)indexPath {
    if (indexPath.row >= self.records.count)
        return nil;
    WikiRecord *record = self.records[indexPath.row];
    return record.thumbnail.icon;
    
}

- (NSString*) urlStringForIconAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row >= self.records.count)
        return nil;
    WikiRecord *record = self.records[indexPath.row];
    return record.thumbnail.iconURLString;
}



@end
