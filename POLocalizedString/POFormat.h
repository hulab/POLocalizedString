// POFormat.h
//
// Created by Maxime Epain on 26/02/2018.
// Copyright © 2017 Hulab. All rights reserved.
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

#import <Foundation/Foundation.h>

/**
 POFormat protocol can be adopting by class used to convert positional arguments in format strings to objc-format.
 cf.: https://www.gnu.org/software/gettext/manual/gettext.html#Translators-for-other-Languages
 */
@protocol POFormat <NSObject>

/**
 Converts specific format arguments to objc-format.

 @param str The string to convert.
 @return The converted string.
 */
- (NSString *)convertString:(NSString *)str;

@end

/**
 Convert c-format arguments to objc-format.
 */
@interface CFormat : NSObject <POFormat>

@end

/**
 Convinient implementation. 
 */
@interface ObjCFormat : NSObject <POFormat>

@end

