//
//  ImageDownloader.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 19/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "ImageDownloader.h"

#define kDefaultThumbnailSize 50

@interface ImageDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end


#pragma mark -

@implementation ImageDownloader

- (void)startDownloadImageAtURL:(NSString*)imageURLString
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:
    ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            if (self.completionHandler != NULL) {
                self.completionHandler(nil, error);
            }
        }
       
       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
           
           UIImage *image = [[UIImage alloc] initWithData:data];
           if (self.desiredSize.width == 0) {
               self.desiredSize = CGSizeMake(kDefaultThumbnailSize, kDefaultThumbnailSize);
           }
           if (image.size.width != self.desiredSize.width || image.size.height != self.desiredSize.height)
           {
               UIGraphicsBeginImageContextWithOptions(_desiredSize, NO, 0.0f);
               CGRect imageRect = CGRectMake(0.0, 0.0, _desiredSize.width, _desiredSize.height);
               [image drawInRect:imageRect];
               if (self.completionHandler != NULL) {
                   self.completionHandler(UIGraphicsGetImageFromCurrentImageContext(), error);
               }
               UIGraphicsEndImageContext();
           }
           else
           {
               if (self.completionHandler != NULL) {
                   self.completionHandler(image, error);
               }
           }

       }];
   }];

    [self.sessionTask resume];
}


- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}

@end


