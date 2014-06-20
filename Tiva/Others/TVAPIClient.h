//
//  TVAPIClient.h
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

@interface TVAPIClient : AFHTTPSessionManager

+ (TVAPIClient *)sharedClient;

@end
