//
//  JZStoreInfo.m
//  JZShoppingApp
//
//  Created by jihong zhang on 9/27/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZStoreInfo.h"

@implementation JZStoreInfo

-(id)initWithStoreName:(NSString*)storeName address:(JZAddress*)address
{
    self = [super init];
    if(self){
        self.storeName = [storeName copy];
        self.address = [address copy];
    }
    return self;
}


-(id)copyWithZone:(NSZone *)zone
{
    //deep copy
    JZStoreInfo *storeInfo = [[[self class] allocWithZone:zone] init];
    /*
    JZAddress *adddress = [_address copy];
    storeInfo.address = adddress;
    storeInfo.storeName = [_storeName copy];
     */
    
    storeInfo.address = [_address copyWithZone:zone];
    storeInfo.storeName = [_storeName copyWithZone:zone];
    
    return storeInfo;
}


@end
