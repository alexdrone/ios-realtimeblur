// Copyright (c) 2013 Alex Usbergo
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//
//  DRNRealTimeBlurView.h
//  LiveBlurView
//
//  Created by Alex Usbergo on 7/3/13.
//  Copyright (c) 2013 Alex Usbergo. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kDRNRealTimeBlurViewScreenshotCompression = 0.01;

//the blur radius
static const CGFloat kDRNRealTimeBlurViewBlurRadius = 1.f;

//the default corner radius for all the DRNRealTimeBlurViews
static const CGFloat kDRNRealTimeBlurViewDefaultCornerRadius = 20.f;

//the view is rendered every kDRNRealTimeBlurViewRenderPeriod seconds
//tweak this value to have a smoother or a more perfomant rendering
static const CGFloat kDRNRealTimeBlurViewRenderFps = 30.f;

//the alpha component of the tint color
static const CGFloat kDNRRealTimeBlurTintColorAlpha = 0.1f;

@interface DRNRealTimeBlurView : UIView

/* When renderStatic is YES, the view is not rendered every kDRNRealTimeBlurViewRenderPeriod seconds.
 * Useful when the view is presented modally and there's no interaction in the superview.
 * IMPORTANT: Always set the view as static before animating this view (you
 * can always set it back to non-static by calling setRenderStatic:NO in the completion block) */
@property (nonatomic, assign) BOOL renderStatic;
@property (nonatomic, strong) UIColor *tint;


@end