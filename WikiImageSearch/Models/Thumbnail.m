//
//  Thumbnail.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "Thumbnail.h"
#import "Defines.h"

@interface Thumbnail()

@property (nonatomic, readwrite, strong) NSString *iconURLString;

@end

@implementation Thumbnail

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if (self) {
        self.iconURLString = dictionary[kResponseKeySource];
    }
    return self;
}



@end
