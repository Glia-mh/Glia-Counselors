//
// RTSpinKitPulseAnimation.m
// SpinKit
//
// Copyright (c) 2014 Ramon Torres
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

#import "RTSpinKitPulseAnimation.h"

@implementation RTSpinKitPulseAnimation

-(void)setupSpinKitAnimationInLayer:(CALayer*)layer withSize:(CGSize)size color:(UIColor*)color
{
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed: @"logo_1.png"];
    CALayer *circle = logo.layer;
    circle.frame = CGRectInset(CGRectMake(0.0, 0.0, size.width, size.height), 2.0, 2.0);
    circle.backgroundColor = color.CGColor;
    circle.anchorPoint = CGPointMake(0.5, 0.5);
    circle.opacity = 1.0;
    circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5;
    circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
    
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnim.values = @[
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)],
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0.0)]
    ];

    CAKeyframeAnimation *opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.values = @[@(1.0), @(0.0)];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.removedOnCompletion = NO;
    animGroup.beginTime = beginTime;
    animGroup.repeatCount = HUGE_VALF;
    animGroup.duration = 1.0;
    animGroup.animations = @[scaleAnim, opacityAnim];
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [layer addSublayer:circle];
    [circle addAnimation:animGroup forKey:@"spinkit-anim"];
}

@end
