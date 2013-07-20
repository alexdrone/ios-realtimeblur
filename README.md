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

You can set the tint color of the view via the tint property (still TODO: use iOS7 tintColor ;)) - The default one is clearColor

In DRNRealTimeBlurView.h there are some constants that you can tweak to improve the smoothness/performances of the view or to define some default values.


	//the blur radius
	static const CGFloat kDRNRealTimeBlurViewBlurRadius = 1.f;

	//the default corner radius for all the DRNRealTimeBlurViews
	static const CGFloat kDRNRealTimeBlurViewDefaultCornerRadius = 20.f;

	//the view is rendered every kDRNRealTimeBlurViewRenderPeriod seconds
	//tweak this value to have a smoother or a more perfomant rendering
	static const CGFloat kDRNRealTimeBlurViewRenderFps = 30.f;

	//the alpha component of the tint color
	static const CGFloat kDNRRealTimeBlurTintColorAlpha = 0.1f;


TODO
--------------------

* Improve it ;)
* Cocoapod


Credits
--------------------

If you use this component in your app, please add some credits :)

