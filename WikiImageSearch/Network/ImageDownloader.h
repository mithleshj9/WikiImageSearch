//
//  ImageDownloader.h
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 19/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject

@property (nonatomic) CGSize desiredSize;

@property (nonatomic, copy) void (^completionHandler)(UIImage* image, NSError* error);

- (void)startDownloadImageAtURL:(NSString*)imageURLString;
- (void)cancelDownload;



@end
