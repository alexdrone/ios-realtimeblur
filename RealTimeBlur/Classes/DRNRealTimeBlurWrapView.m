//
//  DRNRealTimeBlueWrapView.m
//  TurnTheTide
//
//  Created by Tod Cunningham on 11/2/13.
//  Copyright (c) 2013 Five Lakes Studio. All rights reserved.
//
#import "DRNRealTimeBlurWrapView.h"


@implementation DRNRealTimeBlurWrapView


- (id)initWithView:(UIView *)theView
{
    if( theView == nil )
        return nil;
    
    self = [super initWithFrame:theView.frame];
    if( self )
    {
        _wrappedView = theView;
        _wrappedView.backgroundColor = [UIColor clearColor];
        _wrappedView.bounds = CGRectMake(0, 0, theView.frame.size.width, theView.frame.size.width);
        [self addSubview:_wrappedView];
    }
    
    return self;
}


@end
