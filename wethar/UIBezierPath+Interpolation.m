//
//  UIBezierPath+Interpolation.m
//  wethar
//
//  Created by Dylan Straughan on 5/10/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "UIBezierPath+Interpolation.h"

@implementation UIBezierPath (Interpolation)

+(UIBezierPath *)interpolateCGPointsWithHermite:(NSArray *)pointsAsNSValues {
    
    NSInteger nCurves = [pointsAsNSValues count]-1;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSInteger ii=0; ii < nCurves; ii++) {
        NSValue *value  = pointsAsNSValues[ii];
        
        CGPoint curPt, prevPt, nextPt, endPt;
        [value getValue:&curPt];
        if (ii==0)
            [path moveToPoint:curPt];
        
        NSInteger nextii = (ii+1)%[pointsAsNSValues count];
        NSInteger previi = (ii-1 < 0 ? [pointsAsNSValues count]-1 : ii-1);
        
        [pointsAsNSValues[previi] getValue:&prevPt];
        [pointsAsNSValues[nextii] getValue:&nextPt];
        endPt = nextPt;
        
        CGFloat mx, my;
       
        mx = (nextPt.x - curPt.x) * 0.5;
        my = (nextPt.y - curPt.y) * 0.5;
        
        CGPoint ctrlPt1;
        ctrlPt1.x = curPt.x + mx / 3.0;
        ctrlPt1.y = curPt.y + my / 3.0;
        
        [pointsAsNSValues[nextii] getValue:&curPt];
        
        nextii = (nextii+1)%[pointsAsNSValues count];
        previi = ii;
        
        [pointsAsNSValues[previi] getValue:&prevPt];
        [pointsAsNSValues[nextii] getValue:&nextPt];
      
        mx = (curPt.x - prevPt.x) * 0.5;
        my = (curPt.y - prevPt.y) * 0.5;
        
        CGPoint ctrlPt2;
        
        ctrlPt2.x = curPt.x - mx / 3.0;
        ctrlPt2.y = curPt.y - my / 3.0;
        
        [path addCurveToPoint:endPt controlPoint1:ctrlPt1 controlPoint2:ctrlPt2];
    }
    
    return path;
}

@end
