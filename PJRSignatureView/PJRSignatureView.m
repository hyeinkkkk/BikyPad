//
//  PJRSignatureView.m
//  SignExample
//
//  Created by paritosh.raval on 21/11/14.
//  Copyright (c) 2014 paritosh.raval. All rights reserved.
//

/*
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the <organization> nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "PJRSignatureView.h"


#define INITIAL_COLOR [UIColor blackColor]; // Initial color for line  drawing.
#define FINAL_COLOR [UIColor blackColor];// End color after completd drawing

#define INITIAL_LABEL_TEXT @"";//@"Sign Here";


@implementation PJRSignatureView
{
    UIBezierPath *beizerPath;
    UIImage *incrImage;
    CGPoint points[5];
    uint control;
    NSString *backgroundImage;
}


- (void) setBackgroundImage:(NSString *)imageName {
    //set background
//    UIGraphicsBeginImageContext(self.frame.size);
    UIGraphicsBeginImageContext(self.frame.size);
    backgroundImage = imageName;
    [[UIImage imageNamed: imageName] drawInRect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:image];
    [[UIColor colorWithPatternImage:image] setFill];
    //end setting background

}

// Create a View which contains Signature Label

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        float lblHeight = 61;
        self.backgroundColor = [UIColor whiteColor];
        
//        int value = arc4random_uniform(2) + 1;

//        backgroundImage = [NSString stringWithFormat:@"speech_%d.jpg",value];
//        [self setBackgroundImage]; 
        
        [self setMultipleTouchEnabled:NO];
        beizerPath = [UIBezierPath bezierPath];
        [beizerPath setLineWidth:5.0]; //글씨 굵기
        lblSignature = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - lblHeight/2, self.frame.size.width, lblHeight)];
        lblSignature.font = [UIFont fontWithName:@"HelveticaNeue" size:51];
        lblSignature.text = INITIAL_LABEL_TEXT;
        lblSignature.textColor = [UIColor lightGrayColor];
        lblSignature.textAlignment = NSTextAlignmentCenter;
        lblSignature.alpha = 0.3;
        [self addSubview:lblSignature];

        
        
    }
    return self;
}

- (void) createLableView:(CGRect)frame{
    UILabel * testText = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height)];//initWithFrame:CGRectMake(200, self.frame.size.height/2 - lblHeight/2, self.frame.size.width, self.frame.size.width)]; //[[UILabel alloc] init];
    testText.text = @"플레이어 : 2~4명 \n 예상 시간 : 5분 이내 \n    게임 룰 \n  1. 중앙(달)에 플레이어가 다 모인다 \n    2. 플레이어 별로 지구로 내려갈 길을 정한다.\n    3. 시작과 동시에 각자 길을 따라 지구로 내려간다.\n    단, 숫자 1부터 10까지 순서대로 밟으면서\n 지구로 내려가야 한다.\n    4. 가장 먼저 지구에 도착한 사람이 승리한다. \n";
    testText.textAlignment = NSTextAlignmentCenter;
    testText.numberOfLines = 0;
    testText.font =[UIFont fontWithName:@"Helvetica-Bold" size:30 ];
    
    //set background image
    [[UIImage imageNamed: backgroundImage] drawInRect:self.bounds];
    UIImage *image = [UIImage imageNamed:@"11.jpg"];
    CGSize imgSize = testText.frame.size;
    
    UIGraphicsBeginImageContext( imgSize );
    [image drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    testText.backgroundColor = [UIColor colorWithPatternImage:newImage];
    
    
    [self addSubview:testText];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [incrImage drawInRect:rect];
    [beizerPath stroke];
    
    // Set initial color for drawing
    
    UIColor *fillColor = INITIAL_COLOR;
    [fillColor setFill];
    UIColor *strokeColor = INITIAL_COLOR;
    [strokeColor setStroke];
    [beizerPath stroke];
    
}

#pragma mark - UIView Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([lblSignature superview]){
        [lblSignature removeFromSuperview];
    }
    control = 0;
    UITouch *touch = [touches anyObject];
    points[0] = [touch locationInView:self];
    
    CGPoint startPoint = points[0];
    CGPoint endPoint = CGPointMake(startPoint.x + 1.5, startPoint.y
                              + 2);
    
    [beizerPath moveToPoint:startPoint];
    [beizerPath addLineToPoint:endPoint];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    control++;
    points[control] = touchPoint;
    
    if (control == 4)
    {
        points[3] = CGPointMake((points[2].x + points[4].x)/2.0, (points[2].y + points[4].y)/2.0);
        
        [beizerPath moveToPoint:points[0]];
        [beizerPath addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
        
        [self setNeedsDisplay];
        
        points[0] = points[3];
        points[1] = points[4];
        control = 1;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawBitmapImage];
    [self setNeedsDisplay];
    [beizerPath removeAllPoints];
    control = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Bitmap Image Creation

- (void)drawBitmapImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    if (!incrImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        
        [self setBackgroundImage:backgroundImage];
        
//        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [incrImage drawAtPoint:CGPointZero];
    
    //Set final color for drawing
    UIColor *strokeColor = FINAL_COLOR;
    [strokeColor setStroke];
    [beizerPath stroke];
    incrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)clearSignature
{
    incrImage = nil;
    [self setNeedsDisplay];
}

#pragma mark - Get Signature image from given path

- (UIImage *)getSignatureImage {
    
    if([lblSignature superview]){
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return signatureImage;
}


@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
