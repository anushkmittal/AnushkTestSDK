//
//  SUPGridView.m
//  AnushkTestSDK
//
//  Created by Padraig O Cinneide on 2014-03-24.
//  Copyright (c) 2014 Supertop. All rights reserved.
//

#import "SUPGridView.h"

@interface SUPGridView()

@property (nonatomic, strong) UIColor *lightColor;
@property (nonatomic, strong) UIColor *strongColor;

@end

#define SINGLE_PIXEL (1.0f / [[UIScreen mainScreen] scale])

@implementation SUPGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gridColor = [UIColor redColor];

        self.minorGridSize = CGSizeMake(5, 5);
        self.majorGridSize = CGSizeMake(20, 20);
        self.startFromBottom = NO;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setStartFromBottom:(BOOL)startFromBottom
{
    _startFromBottom = startFromBottom;
    
    [self setNeedsDisplay];
}

- (void)setGridColor:(UIColor *)gridColor
{
    _gridColor = gridColor;
    
    self.lightColor = [gridColor colorWithAlphaComponent:0.3];
    self.strongColor = [gridColor colorWithAlphaComponent:0.5];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetShouldAntialias(context, NO);
    
    if (self.startFromBottom) {
        for (CGFloat y = self.bounds.size.height; y > 0; y = y - self.minorGridSize.height)
        {
            [self setLineAttributesForPosition:self.bounds.size.height - y];
            [self drawLineAtYPosition:y];
        }
    } else {
        for (CGFloat y = 0; y < self.bounds.size.height; y = y + self.minorGridSize.height)
        {
            [self setLineAttributesForPosition:y];
            [self drawLineAtYPosition:y];
        }
    }


    for (CGFloat x = 0; x < self.bounds.size.width; x = x + self.minorGridSize.width)
    {
        [self setLineAttributesForPosition:x];
        [self drawLineAtXPosition:x];
    }
}

- (void)setLineAttributesForPosition:(CGFloat)pos
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat dashes[2] = {1,1};
    
    if (fmodf(pos, self.majorGridSize.width) == 0) {
        CGContextSetStrokeColorWithColor(context, self.strongColor.CGColor);
        CGContextSetLineDash(context, 1, dashes, 0);
    } else {
        CGContextSetStrokeColorWithColor(context, self.lightColor.CGColor);
        CGContextSetLineDash(context, 1, dashes, 2);
    }
}


- (void)drawLineAtYPosition:(CGFloat)yPos
{
    yPos = round(yPos)+SINGLE_PIXEL;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, SINGLE_PIXEL);
    
    CGContextMoveToPoint(context, 0, yPos); //start at this point
    CGContextAddLineToPoint(context, self.bounds.size.width, yPos); //draw to this point
    
    CGContextStrokePath(context);
}

- (void)drawLineAtXPosition:(CGFloat)xPos
{
    xPos = round(xPos);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, SINGLE_PIXEL);
    
    CGContextMoveToPoint(context, xPos, 0); //start at this point
    CGContextAddLineToPoint(context, xPos, self.bounds.size.height); //draw to this point
    
    CGContextStrokePath(context);
}

@end
