//
//  wundergroundAPIClient.h
//  wethar
//
//  Created by Dylan Straughan on 4/26/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wundergroundAPIClient : NSObject

-(void)fetchWeatherDataForLocationWithCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void(^)(NSDictionary*data))completionBlock;

@end
