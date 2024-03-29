//
// NSString+VTSubstringOccurrences.m
//
// Copyright (c) 2014 Vincent Tourraine (http://www.vtourraine.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSString+VTSubstringOccurrences.h"

@implementation NSString (VTSubstringOccurrences)

- (NSUInteger)vt_numberOfOccurrencesForSubstring:(NSString *)substring
{
    return [self vt_numberOfOccurrencesForSubstring:substring
                                            options:kNilOptions];
}

- (NSUInteger)vt_numberOfOccurrencesForSubstring:(NSString *)substring
                                         options:(NSStringCompareOptions)options
{
    NSUInteger count  = 0;
    NSUInteger length = self.length;
    NSRange    range  = NSMakeRange(0, length);

    while(range.location != NSNotFound) {
        range = [self rangeOfString:substring
                            options:options
                              range:range];
        if(range.location != NSNotFound) {
            range = NSMakeRange(range.location + range.length,
                                length - (range.location + range.length));
            count++;
        }
    }

    return count;
}

@end
