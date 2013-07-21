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
//  DRNRealTimeBlurView.m
//  LiveBlurView
//
//  Created by Alex Usbergo on 7/3/13.
//  Copyright (c) 2013 Alex Usbergo. All rights reserved.
//

#import "DRNRealTimeBlurView.h"
#import "UIImage+BoxBlur.h"
#import <QuartzCore/QuartzCore.h>

/* In order to optimize the number of calls to renderLayerWithView in DRNRealTimeBlurView
 * this centralized manager register and deregister the views and makes sure that they're 
 * refreshed when is needed */
@interface DRNRealTimeBlurViewManager : NSObject

@property (nonatomic, strong) NSMutableArray *views;

/* Returns the global instance */
+ (id)sharedManager;

/* Register and deregister views */
- (void)registerView:(DRNRealTimeBlurView*)view;
- (void)deregisterView:(DRNRealTimeBlurView*)view;

@end

@interface DRNRealTimeBlurView ()

/* The background layer with the tint color */
@property (nonatomic, strong) CALayer *tintLayer;

/* Private layer rendering method */
- (void)renderLayerWithView:(UIView*)superview;

@end

@implementation DRNRealTimeBlurView

#pragma mark - Constructors


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.tintLayer = [[CALayer alloc] init];
        self.tintLayer.frame = self.bounds;
        self.tintLayer.opacity = kDNRRealTimeBlurTintColorAlpha;
        
        //default tint
        //TODO: Use tintColor on iOS 7
        self.tint = [UIColor clearColor];
        
        [self.layer addSublayer:self.tintLayer];
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = kDRNRealTimeBlurViewDefaultCornerRadius;
    }
    return self;
}

- (void)dealloc
{
    [[DRNRealTimeBlurViewManager sharedManager] deregisterView:self];
}

#pragma mark - Properties

/* When renderStatic is YES, the view is not rendered every kDRNRealTimeBlurViewRenderPeriod seconds.
 * Useful when the view is presented modally and there's no interaction in the superview.
 * IMPORTANT: Always set the view as static before animating this view (you
 * can always set it back to non-static by calling setRenderStatic:NO in the completion block) */
- (void)setRenderStatic:(BOOL)renderStatic
{
    _renderStatic = renderStatic;
    
    if (renderStatic)
        [[DRNRealTimeBlurViewManager sharedManager] deregisterView:self];
    else
        [[DRNRealTimeBlurViewManager sharedManager] registerView:self];
}

/* Set the tint color of the view. (default = [UIColor clearColor])
 * TODO: Use iOS7 tintColor */
- (void)setTint:(UIColor*)tint
{
    _tint = tint;
    self.tintLayer.backgroundColor = _tint.CGColor;
    [self.tintLayer setNeedsDisplay];
}

#pragma mark - Rendering

/* When the view is pushed to the superview, the layer 
 * is rendered for the first time. It will then be refreshed 
 * only if renderStatic = YES */
- (void)willMoveToSuperview:(UIView*)superview
{
    [self renderLayerWithView:superview];
}

/* When the view is visible because is being added to the superview 
 * or to the window, this method is called */
- (void)didMoveToSuperview
{
    if (nil != self.superview) {
        
        //if the view is not set as static registers the view to the manager
        if (!self.renderStatic)
            [[DRNRealTimeBlurViewManager sharedManager] registerView:self];
   
        
    } else {
        //makes sure that the view is deregistered from the manager
        [[DRNRealTimeBlurViewManager sharedManager] deregisterView:self];
    }
}

- (void)renderLayerWithView:(UIView*)superview
{
    //get the visible rect
    CGRect visibleRect = [superview convertRect:self.frame toView:self];
    visibleRect.origin.y += self.frame.origin.y;
    visibleRect.origin.x += self.frame.origin.x;
        
    //hide all the blurred views from the superview before taking a screenshot
    CGFloat alpha = self.alpha;    
    [self toggleBlurViewsInView:superview hidden:YES alpha:alpha];
    
    //Render the layer in the image context
    UIGraphicsBeginImageContextWithOptions(visibleRect.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -visibleRect.origin.x, -visibleRect.origin.y);
    CALayer *layer = superview.layer;
    [layer renderInContext:context];
    
    //show all the blurred views from the superview before taking a screenshot
    [self toggleBlurViewsInView:superview hidden:NO alpha:alpha];
    
    __block UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
        //takes a screenshot of that portion of the screen and blurs it
        //helps w/ our colors when blurring
        //feel free to adjust jpeg quality (lower = higher perf)
        NSData *imageData = UIImageJPEGRepresentation(image, kDRNRealTimeBlurViewScreenshotCompression);
        image = [[UIImage imageWithData:imageData] drn_boxblurImageWithBlur:kDRNRealTimeBlurViewBlurRadius];
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            //update the layer content
            self.layer.contents = (id)image.CGImage;
        });
    });
}

/* Hide or show all the DRNRealTimeBlurView subviews from the target view */
- (void)toggleBlurViewsInView:(UIView*)view hidden:(BOOL)hidden alpha:(CGFloat)originalAlpha
{
    for (UIView *subview in view.subviews)
        if ([subview isKindOfClass:DRNRealTimeBlurView.class])
            subview.alpha = hidden ? 0.f : originalAlpha;
}

@end


#pragma mark - DRNRealTimeBlurViewManager implementation

/* In order to optimize the number of calls to renderLayerWithView in DRNRealTimeBlurView
 * this centralized manager register and deregister the views and makes sure that they're
 * refreshed when is needed */
@implementation DRNRealTimeBlurViewManager

/* Returns the global instance */
+ (id)sharedManager
{
    static dispatch_once_t pred;
    static DRNRealTimeBlurViewManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[DRNRealTimeBlurViewManager alloc] init];
    });
    
    return shared;
}

/* Constructor */
- (id)init
{
    if (self = [super init])
        self.views = [@[] mutableCopy];
    
    return self;
}

/* Register a new view and starts the pulling */
- (void)registerView:(DRNRealTimeBlurView*)view
{
    //add the view to the collection (if it's not already included)
    if (![self.views containsObject:view]) [self.views addObject:view];
    [self refresh];
}

/* Deregister the view */
- (void)deregisterView:(DRNRealTimeBlurView*)view
{
    [self.views removeObject:view];
    [self refresh];
}

/* Pull the new screenshot data from the superviews and forces 
 * the registered views to render */
- (void)refresh
{    
    if (!self.views.count) return;
    
    //refresh all the registered views
    for (DRNRealTimeBlurView *view in self.views)
        [view renderLayerWithView:view.superview];
    
    double delayInSeconds = self.views.count * (1/kDRNRealTimeBlurViewRenderFps);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refresh];
    });
}

@end

