ios-realtimeblur
================

Real-time blur view, like in iOS 7. (on iOS5,6 and 7)



[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/jVtbBU92suk/0.jpg)](http://www.youtube.com/watch?v=jVtbBU92suk)


Usage
--------------------

Instantiate it and use it as any other view :) 
If you want to have a static rendering (useful if your view is presented modally) just set

	blurView.renderStatic = YES;


Rember to set renderStatic to YES everytime you want to animate the view (you can always set it to NO in the completion block)


	blurView.renderStatic = YES;
	blurView.alpha = 0.f;

	//show aniamtion
	[UIView animateWithDuration:1 animations:^{
	    blurView.alpha = 1.f;
	} completion:^(BOOL finished) {
	    blurView.renderStatic = NO;
	}];


You can set the tint color of the view via the tint property (still TODO: use iOS7 tintColor ;)) - The default one is clearColor


In DRNRealTimeBlurView.h there are some constants that you can tweak to improve the smoothness/performances of the view or to define some default values.

	//adjust jpeg quality (lower = higher perf)
	#define kDRNRealTimeBlurViewScreenshotCompression 0.01

	//the blur radius
	#define kDRNRealTimeBlurViewBlurRadius 1

	//the default corner radius for all the DRNRealTimeBlurViews
	#define kDRNRealTimeBlurViewDefaultCornerRadius 20

	//the view is rendered every kDRNRealTimeBlurViewRenderPeriod seconds
	//tweak this value to have a smoother or a more perfomant rendering
	#define kDRNRealTimeBlurViewRenderPeriod 0.1

	//The tint color alpha
	#define kDNRRealTimeBlurTintColorAlpha 0.1


TODO
--------------------

* Improve it ;)
* Cocoapod


Credits
--------------------

If you use this component in your app, please add some credits :)

