ios-realtimeblur
================

Real-time blur view, like in iOS 7. (deployable on iOS5, 6 and 7)



[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/jVtbBU92suk/0.jpg)](http://www.youtube.com/watch?v=jVtbBU92suk)


Usage
--------------------

• • • Make sure you link to the Accelerate.framework • • •

Instantiate it and use it as any other view :) 

	//Creates a live blur view
	UIERealTimeBlurView *blurView = [[UIERealTimeBlurView alloc] initWithFrame:CGRectMake(60, 110, 200, 200)];
	[self.view addSubview:blurView];
	

You can add all the subviews you want to it...

	UIImageView *speakerImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
	speakerImage.image = [UIImage imageNamed:@"speaker"];
	[blurView addSubview:speakerImage];


If you want to have a static rendering (useful if your view is presented modally) just set

	blurView.renderStatic = YES;

You can set the tint color of the view via the tint property (still TODO: use iOS7 tintColor ;)) - The default one is clearColor

In UIERealTimeBlurView.h you can set the fps by tweaking the global var 

	extern const CGFloat UIERealTimeBlurViewFPS = 30.f;


Credits
--------------------

If you use this component in your app, please add some credits :)
The box blur algorithm is from this beautiful blog post:
http://indieambitions.com/idevblogaday/perform-blur-vimage-accelerate-framework-tutorial
