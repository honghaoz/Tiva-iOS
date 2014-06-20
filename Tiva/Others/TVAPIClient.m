//
//  TVAPIClient.m
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVAPIClient.h"
#import <AFHTTPRequestOperation.h>

NSString * const kTraktAPIKey = @"1894bbe16b75b5058e5a00cb64462023";
NSString * const kTraktBaseURLString = @"http://api.trakt.tv";

@implementation TVAPIClient {
    NSString * const kTraktAPIKey;
    NSString * const kTraktBaseURLString;
}

+ (TVAPIClient *)sharedClient {
    static TVAPIClient *_sharedClient = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kTraktBaseURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}



@end
