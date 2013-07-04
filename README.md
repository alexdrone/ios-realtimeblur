ios-realtimeblur
================

Real-time blur view, like in iOS 7. (deployable on iOS5, 6 and 7)



[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/jVtbBU92suk/0.jpg)](http://www.youtube.com/watch?v=jVtbBU92suk)


Usage
--------------------

Instantiate it and use it as any other view :) 

	//Creates a live blur view
	DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(60, 110, 200, 200)];
	[self.view addSubview:blurView];
	

You can add all the subviews you want to it...

	UIImageView *speakerImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
	speakerImage.image = [UIImage imageNamed:@"speaker"];
	[blurView addSubview:speakerImage];


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
	static const CGFloat kDRNRealTimeBlurViewScreenshotCompression = 0.01;

	//the blur radius
	static const CGFloat kDRNRealTimeBlurViewBlurRadius = 1.f;

	//the default corner radius for all the DRNRealTimeBlurViews
	static const CGFloat kDRNRealTimeBlurViewDefaultCornerRadius = 20.f;

	//the view is rendered every kDRNRealTimeBlurViewRenderPeriod seconds
	//tweak this value to have a smoother or a more perfomant rendering
	static const CGFloat kDRNRealTimeBlurViewRenderPeriod = 0.1f;

	//the alpha component of the tint color
	static const CGFloat kDNRRealTimeBlurTintColorAlpha = 0.1f;


TODO
--------------------

* Improve it ;)
* Cocoapod


Credits
--------------------

If you use this component in your app, please add some credits :)

