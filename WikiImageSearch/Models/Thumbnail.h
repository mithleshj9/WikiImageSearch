//
//  Thumbnail.h
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Thumbnail : NSObject

@property (nonatomic, readonly, strong) NSString *iconURLString;
@property (nonatomic, strong) UIImage *icon;

- (instancetype) initWithDictionary:(NSDictionary*)dictionary;

@end
