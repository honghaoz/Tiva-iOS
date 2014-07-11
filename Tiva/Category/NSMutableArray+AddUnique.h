//
//  NSMutableArray+AddUnique.h
//  Tiva
//
//  Created by Honghao on 7/11/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (AddUnique)

- (BOOL)addUniqueObject:(id)object usingUniqueComparator:(NSComparator)uniqueComparator;

- (BOOL)addUniqueObject:(id)object usingUniqueComparator:(NSComparator)uniqueComparator orderComparator:(NSComparator)orderComparator;

@end
