//
//  DVSDatastore.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSDatastore.h"

@implementation DVSDatastore

+ (instancetype)sharedDataSource {
    
    static DVSDatastore *_sharedPiratesDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPiratesDataStore = [[DVSDatastore alloc] init];
    });
    
    return _sharedPiratesDataStore;
}

-(instancetype)init
{
    self = [super init];
    
    if(self) {
        
        
    }
    
    return self;
}


@end
