//
//  TVEpisode.h
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVEpisode : NSObject

@property (nonatomic, assign) NSInteger season;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDate *airedDateUTC;
@property (nonatomic, strong) NSDate *airedDateLocal;
@property (nonatomic, strong) NSURL *screenImageURL;
@property (nonatomic, strong) UIImage *screenImage;
//@property (nonatomic, strong)

@end
