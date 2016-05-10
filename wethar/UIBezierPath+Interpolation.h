//
//  UIBezierPath+Interpolation.h
//  wethar
//
//  Created by Dylan Straughan on 5/10/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Interpolation)

+(UIBezierPath *)interpolateCGPointsWithHermite:(NSArray *)pointsAsNSValues;

@end
