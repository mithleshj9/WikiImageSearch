//
//  WikiSearchJsonResponseParser.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 19/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "WikiSearchJsonResponseParser.h"
#import "Defines.h"

@interface WikiSearchJsonResponseParser()

@property (nonatomic) BOOL cancelParser;

@end

@implementation WikiSearchJsonResponseParser

+ (NSError *) errorObjectWithFailureReason:(NSString *__nonnull)failureReason description:(NSString *__nonnull)errorMessage errorCode:(NSInteger)errorCode {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:errorMessage, NSLocalizedFailureReasonErrorKey:failureReason };
    NSError *localErrorObject = [NSError errorWithDomain:ErrorDomainResponseParser code:errorCode userInfo:userInfo];
    
    return localErrorObject;
}

- (NSArray*) parseWikiSearchResponse:(NSData*)response error:(NSError**)outError {
    if (response == nil)
        return nil;
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:response options:0 error:outError];
    if (responseDictionary == nil || self.cancelParser)
        return nil;
    
    NSString *errorMessage = nil;
    NSString *failureReason = nil;
    
    if(![responseDictionary isKindOfClass:[NSDictionary class]]) {
        NSString *formattedError = [NSString stringWithFormat:
                                    NSLocalizedString(@"Response json is of type %@ whereas the expected type is NSDictionary", @""),
                                    NSStringFromClass([responseDictionary class])];
        if(outError != nil) {
            errorMessage = formattedError;
            failureReason = NSLocalizedString(@"Invalid response json", @"");
            NSError *error = [WikiSearchJsonResponseParser errorObjectWithFailureReason:failureReason description:errorMessage errorCode:0];
            *outError = error;
        } else {
            NSLog(@"Error parsing wiki search json \n%@", formattedError);
        }
        
        return nil;
    }
    
    NSArray *allValues = [responseDictionary[kResponseKeyQuery][kResponseKeyPages] allValues];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:kResponseKeyIndex  ascending:YES];
    allValues = [allValues sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    return allValues;
}

- (void) parseWikiSearchResponse:(NSData*)response
             withCompletionBlock:(WikiSearchResponseCompletionBlock)completionBlock {
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        NSError *error = nil;
        NSArray *records = [self parseWikiSearchResponse:response error:&error];
        if (completionBlock) {
            completionBlock(records, error);
        }
    });
}

- (void) cancel {
    self.cancelParser = YES;
}


@end
