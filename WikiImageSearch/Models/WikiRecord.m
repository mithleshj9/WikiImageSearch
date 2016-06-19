//
//  WikiRecord.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "WikiRecord.h"
#import "Defines.h"
#import "Thumbnail.h"

@interface WikiRecord()

@property (nonatomic, readwrite, strong) NSString *title;
@property (nonatomic, readwrite, strong) NSString *identifier;

@end

@implementation WikiRecord

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if (self) {
        self.title = dictionary[kResponseKeyTitle];
        self.identifier = dictionary[kResponseKeyPageId];
        
        NSDictionary *thumbnailDict = dictionary[kResponseKeyThumbnail];
        Thumbnail *thm = [[Thumbnail alloc] initWithDictionary:thumbnailDict];
        self.thumbnail = thm;
    }
    return self;
}

@end
