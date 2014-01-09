//
//  HLLListViewController.m
//  Hallo
//
//  Created by Alex Usbergo on 6/11/13.
//  Copyright (c) 2013 Alex Usbergo. All rights reserved.
//

#import "ListViewController.h"
#import "UIERealTimeBlurView.h"

#define hll_color(r,g,b,a) [UIColor colorWithRed:(float)r/255.f green:(float)g/255.f blue:(float)b/255.f  alpha:a]

@interface UIColor (HLLAdditions)

//the background color for the current cell
+ (UIColor*)hll_backgroundColorForIndex:(NSUInteger)index;

@end


@interface ListViewController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

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
    
    UIERealTimeBlurView *blur = [[UIERealTimeBlurView alloc] initWithFrame:CGRectMake(60, 110, 200, 200)];
    [self.view addSubview:blur];
    
    //..and adds a subview
    [blur addSubview:speakerImage];
    
    self.title = @"Alex Usbergo ~ Live Blur";
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
    
    cell.textLabel.text = @"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet";
    cell.detailTextLabel.text = @"Lorem ipsum alexibus usbergique";
    
    
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
