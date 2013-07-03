//
//  DRNRealTimeBlurView.h
//  LiveBlurView
//
//  Created by Alex Usbergo on 7/3/13.
//  Copyright (c) 2013 Alex Usbergo. All rights reserved.
//

#import <UIKit/UIKit.h>

//adjust jpeg quality (lower = higher perf)
#define kDRNRealTimeBlurViewScreenshotCompression 0.01

//the blur radius
#define kDRNRealTimeBlurViewBlurRadius 1

//the default corner radius for all the DRNRealTimeBlurViews
#define kDRNRealTimeBlurViewDefaultCornerRadius 20

//the view is rendered every kDRNRealTimeBlurViewRenderPeriod seconds
//tweak this value to have a smoother or a more perfomant rendering
#define kDRNRealTimeBlurViewRenderPeriod 0.01

#define kDNRRealTimeBlurTintColorAlpha 0.1

@interface DRNRealTimeBlurView : UIView

/* When renderStatic is YES, the view is not rendered every kDRNRealTimeBlurViewRenderPeriod seconds.
 * Useful when the view is presented modally and there's no interaction in the superview.
 * IMPORTANT: Always set the view as static before animating this view (you
 * can always set it back to non-static by calling setRenderStatic:NO in the completion block) */
@property (nonatomic, assign) BOOL renderStatic;
@property (nonatomic, strong) UIColor *tint;


@end