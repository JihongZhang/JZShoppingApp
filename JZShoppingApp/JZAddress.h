//
//  JZAddress.h
//  JZShoppingApp
//
//  Created by jihong zhang on 9/28/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZAddress : NSObject  //<NSCopying>
/*
@property (nonatomic) NSString *streetAndNumer;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *zipCode;


-(id)initWithStreetAndNumer:(NSString*)streetAndNumber city:(NSString*)city state:(NSString*)state zipCode:(NSString*)zipCode;
*/


@property (nonatomic) NSString *address;

-(id)initWithAddress:(NSString *) address;
-(id)copyWithZone:(NSZone *)zone;
  

@end
