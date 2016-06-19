//
//  ListModel.h
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IListModel <NSObject>

@property (nonatomic, strong) NSArray* records;

@required
- (NSInteger) numberOfSections;
- (NSInteger) numberOfRecordsInSection:(NSInteger)section;
- (NSString *) titleForDataAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*) modelIdentifierAtIndexPath:(NSIndexPath*)indexPath;

@optional
- (UIImage*) iconAtIndex:(NSIndexPath*)indexPath;
- (NSString*) urlStringForIconAtIndexPath:(NSIndexPath*)indexPath;

@end
