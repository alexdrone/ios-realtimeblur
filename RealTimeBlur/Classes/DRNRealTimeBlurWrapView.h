//
//  DRNRealTimeBlueWrapView.h
//  TurnTheTide
//
//  Created by Tod Cunningham on 11/2/13.
//  Copyright (c) 2013 Five Lakes Studio. All rights reserved.
//
#import "DRNRealTimeBlurView.h"

@interface DRNRealTimeBlurWrapView : DRNRealTimeBlurView

@property (strong, readonly, nonatomic) UIView *wrappedView;

- (id)initWithView:(UIView *)theView;

@end
