//
//  CRNetworkRequest.h
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRNetworkRequest : NSObject

// Execute the request immediately, calling completionBlock when finished.
// Probably a good idea to pass a status code to completionBlock, in case
// you want to retry failed requests or log outcomes.
- (void)performRequest:(void (^)())completionBlock;

@end
