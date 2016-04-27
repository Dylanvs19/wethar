//
//  flickrAPIClient.h
//  wethar
//
//  Created by Dylan Straughan on 4/26/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "secrets.h"

@interface flickrAPIClient : NSObject

-(void)getPhotoFromFlickrWithLatitude:(NSString *)latitude longitude:(NSString *)longitude city:(NSString *)city state:(NSString *)state andCompletionBlock:(void(^)(UIImage *))completionBlock;

@end
