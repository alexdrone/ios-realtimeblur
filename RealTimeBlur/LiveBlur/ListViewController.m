//
//  HLLListViewController.m
//  Hallo
//
//  Created by Alex Usbergo on 6/11/13.
//  Copyright (c) 2013 Alex Usbergo. All rights reserved.
//

#import "ListViewController.h"
#import "DRNRealTimeBlurView.h"

#define hll_color(r,g,b,a) [UIColor colorWithRed:(float)r/255.f green:(float)g/255.f blue:(float)b/255.f  alpha:a]

@interface UIColor (HLLAdditions)

//the background color for the current cell
+ (UIColor*)hll_backgroundColorForIndex:(NSUInteger)index;

@end


@interface ListViewController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DRNRealTimeBlurView *blurView;

@end

@implementation ListViewController



#pragma mark - TableViewDataSource

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIImageView *speakerImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    speakerImage.image = [UIImage imageNamed:@"speaker"];
    speakerImage.alpha = 0.5f;

    //Creates a live blur view
    self.blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(60, 110, 200, 200)];
    [self.view addSubview:self.blurView];

    //..and adds a subview
    [self.blurView addSubview:speakerImage];

    //shows and hides the blur view every 10secs
    [self showHideLoop];
    
    self.title = @"Alex Usbergo ~ Live Blur";
}

- (void)showHideLoop
{    
    //When renderStatic is YES, the view is not rendered every kDRNRealTimeBlurViewRenderPeriod seconds.
    //Useful when the view is presented modally and there's no interaction in the superview.
    //IMPORTANT: Always set the view as static before animating the view (you
    //can always set it back to non-static by calling setRenderStatic:NO in the completion block)
    self.blurView.renderStatic = YES;
    self.blurView.alpha = 0.f;
    
    //show aniamtion
    [UIView animateWithDuration:1 animations:^{
        self.blurView.alpha = 1.f;
    } completion:^(BOOL finished) {
        self.blurView.renderStatic = NO;
        
        //After 10seconds it hides the view
        double delayInSeconds = 10.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
            //hide animation
            self.blurView.renderStatic = YES;
            [UIView animateWithDuration:1 animations:^{
                self.blurView.alpha = 0.f;
            } completion:^(BOOL finished) {
                
                //recursively call showHideLoop
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self showHideLoop];
                });
            }];
        });
    }];
    

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *identifier = NSStringFromClass(self.class);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"Hwæt! wē Gār-Dena in ġeār-dagum";
    cell.detailTextLabel.text = @"þēod-cyninga, þrym ġefrūnon";
    
    
    UIColor *bkg = [UIColor hll_backgroundColorForIndex:indexPath.row];
    cell.textLabel.textColor = bkg;
    cell.detailTextLabel.textColor = bkg;
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UIColor (HLLAdditions)

/* the cyclic background colors */
+ (NSArray*)hll_backgroundColors
{
    return @[hll_color(255, 117, 96, 1), hll_color(254, 89, 121, 1), hll_color(233, 71, 144, 1), hll_color(255, 103, 193, 1), hll_color(197, 130, 236, 1), hll_color(164, 158, 255, 1), hll_color(159, 182, 249, 1), hll_color(164, 158, 255, 1), hll_color(197, 130, 236, 1), hll_color(255, 103, 193, 1),  hll_color(233, 71, 144, 1)];
}

+ (UIColor*)hll_backgroundColorForIndex:(NSUInteger)index
{
    index = index % [self hll_backgroundColors].count;
    UIColor *color = [self hll_backgroundColors][index];
    
    NSAssert(nil != color, @"nil color");
    return color;
}

@end
