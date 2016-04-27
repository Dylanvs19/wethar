//
//  flickrAPIClient.m
//  wethar
//
//  Created by Dylan Straughan on 4/26/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "flickrAPIClient.h"

@implementation flickrAPIClient



-(void)getPhotoFromFlickrWithLatitude:(NSString *)latitude longitude:(NSString *)longitude city:(NSString *)city state:(NSString *)state andCompletionBlock:(void(^)(UIImage *))completionBlock {
    
    NSURL *flickerAPI = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&lat=%@&lon=-%@&accuracy=3&extras=url_c,views&format=json&tags=%@,%@",FLICKR_API_KEY,latitude,longitude,city,state]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:flickerAPI completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary * dataToSend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *photosArrayFromData = dataToSend[@"photos"][@"photo"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"views > 100"];
        NSArray *filteredPhotos = [photosArrayFromData filteredArrayUsingPredicate:predicate];
        
        if(filteredPhotos == nil) {
            
            // add weird photo in xcassets
            
        } else {
            
            NSMutableArray *finalPhotoArray = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dict in filteredPhotos) {
                
                if (dict[@"url_c"]) {
                    
                    [finalPhotoArray addObject:dict];
                }
                
                
            }
            
            NSDictionary *photoDictionary = [finalPhotoArray objectAtIndex:arc4random() %finalPhotoArray.count];
            
            UIImage *image = [image imageforURL:[NSURL URLWithString:photoDictionary[@"url_c"]]];
            
            completionBlock(image);
            
        }
        
    }];
    
    [dataTask resume];
}


@end
