//
//  JZAddress.m
//  JZShoppingApp
//
//  Created by jihong zhang on 9/28/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZAddress.h"

@implementation JZAddress

-(id)initWithAddress:(NSString*) address
{
    self = [super init];
    if(self) {
        self.address = [address copy];
    }
    return self;
}

/*
-(id)initWithStreetAndNumer:(NSString*)streetAndNumber city:(NSString*)city state:(NSString*)state zipCode:(NSString*)zipCode
{
    self = [super init];
    if(self){
        self.streetAndNumer = streetAndNumber;
        self.city = city;
        self.state = state;
        self.zipCode = zipCode;
    }
    return self;
}
*/

-(id)copyWithZone:(NSZone *)zone
{
    //shallow copy
    /*
    JZAddress *address = [[[self class] allocWithZone:zone] init];
    address.streetAndNumer = _streetAndNumer;
    address.city = _city;
    address.state = _state;
    address.zipCode = _zipCode;
    */
    
    //deep copy
    JZAddress *address = [[[self class] allocWithZone:zone] init];
    /*
    address.streetAndNumer = [_streetAndNumer copy]; //[_streetAndNumer mutableCopy]; real copy
    address.city = [_city copy];
    address.state = [_state copy];
    address.zipCode = [_zipCode copy];
     */
    
    address.address = [_address copyWithZone:zone];
    
    return address;
    
}

  
@end
