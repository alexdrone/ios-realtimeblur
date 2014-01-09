// Copyright (c) 2013-2014 Alex Usbergo
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
//  UIERealTimeBlurView.m
//  LiveBlur
//
//  Created by Alex Usbergo on 09/01/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

#import "UIERealTimeBlurView.h"
#import "UIImage+BoxBlur.h"
#import <objc/runtime.h>

/*** Returns the os version */
NSUInteger UIEDeviceSystemMajorVersion();

//tweak this value to have a smoother or a more perfomant rendering
//Default is 30FPS
const CGFloat UIERealTimeBlurViewFPS = 30;
const CGFloat UIERealTimeBlurViewDefaultBlurRadius = 1;
const CGFloat UIERealTimeBlurViewTintColorAlpha = 0.1;

@implementation UIERealTimeBlurView {
    
    /*** The background layer with the tint color */
    CALayer *_tintLayer;
    UIColor *_tint;
    
    CADisplayLink *_displayLink;
    
    /*** Wheter the view has been rendered once or not */
    BOOL _rendered;
    
    /*** On iOS7 we use the native blur implementation */
    BOOL _ios7;
    UIToolbar *_nativeBlurView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.clipsToBounds = YES;
        
        // on iOS7 uses the native UIToolbar implementation
        if (UIEDeviceSystemMajorVersion() > 6) {
            
            // flag for os version
            _ios7 = YES;
            _nativeBlurView = [[UIToolbar alloc] initWithFrame:self.bounds];
            
            // add the toolbar layer as sublayer
            [self.layer insertSublayer:_nativeBlurView.layer atIndex:0];
        
        } else {
        
            _tintLayer = [[CALayer alloc] init];
            _tintLayer.frame = self.bounds;
            _tintLayer.opacity = UIERealTimeBlurViewTintColorAlpha;
            
            //default tint color
            self.tintColor = [UIColor clearColor];
        }
    }
    return self;
}

- (void)setTintColor:(UIColor*)tintColor
{
    if (_ios7)
        [super setTintColor:tintColor];
    else {
        _tint = tintColor;
        [_tintLayer setBackgroundColor:_tint.CGColor];
    }
}

#pragma mark - Rendering

- (void)uie_renderLayerWithView:(UIView*)superview
{
    if (_ios7) return;
    
    //get the visible rect
    CGRect visibleRect = [superview convertRect:self.frame toView:self];
    visibleRect.origin.y += self.frame.origin.y;
    visibleRect.origin.x += self.frame.origin.x;
    
    //hide all the blurred views from the superview before taking a screenshot
    CGFloat alpha = self.alpha;
    [self uie_toggleBlurViewsInView:superview hidden:YES alpha:alpha];
    
    //Render the layer in the image context
    if (CGRectIsEmpty(visibleRect)) return;
    
    UIGraphicsBeginImageContextWithOptions(visibleRect.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -visibleRect.origin.x, -visibleRect.origin.y);
    CALayer *layer = superview.layer;
    [layer renderInContext:context];
    
    //show all the blurred views from the superview before taking a screenshot
    [self uie_toggleBlurViewsInView:superview hidden:NO alpha:alpha];
    
    __block UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //takes a screenshot of that portion of the screen and blurs it
        //helps w/ our colors when blurring
        //feel free to adjust jpeg quality (lower = higher perf)
        NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
        image = [[UIImage imageWithData:imageData] uie_boxblurImageWithBlur:UIERealTimeBlurViewDefaultBlurRadius];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //update the layer content
            self.layer.contents = (id)image.CGImage;
        });
    });
}

/*** Hide or show all the DRNRealTimeBlurView subviews from the target view */
- (void)uie_toggleBlurViewsInView:(UIView*)view hidden:(BOOL)hidden alpha:(CGFloat)originalAlpha
{
    if (_ios7) return;
    
    for (UIView *subview in view.subviews)
        if ([subview isKindOfClass:UIERealTimeBlurView.class])
            subview.alpha = hidden ? 0.f : originalAlpha;
}

#pragma mark - Refreshing

- (void)willMoveToSuperview:(UIView*)superview
{
    if (_ios7) return;
    
    [self uie_renderLayerWithView:superview];
    
    //static rendering doesn't need the display link
    if (_renderStatic) return;
    
    if (superview != nil) {
        
        //create the display link
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh)];
        _displayLink.frameInterval = (NSInteger)(ceil(60.0/UIERealTimeBlurViewFPS));
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

    } else {
        
        //invalidate and free the display link
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

/*** Manually performs the refresh of the blurred background */
- (void)refresh
{
    if (_ios7) return;
    
    if (self.superview != nil) {
        [self uie_renderLayerWithView:self.superview];
    }
}

@end

/*** Returns the os version */
NSUInteger UIEDeviceSystemMajorVersion()
{
    static NSUInteger __osVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __osVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return __osVersion;
}
