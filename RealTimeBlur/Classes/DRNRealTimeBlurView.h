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