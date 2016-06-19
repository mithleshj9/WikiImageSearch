//
//  WikiRecord.h
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Thumbnail;

@interface WikiRecord : NSObject

@property (nonatomic, readonly, strong) NSString *title;
@property (nonatomic, readonly, strong) NSString *identifier;

@property (nonatomic, strong) Thumbnail *thumbnail;

- (instancetype) initWithDictionary:(NSDictionary*)dictionary;

@end
