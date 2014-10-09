//
//  JZStoreInfo.h
//  JZShoppingApp
//
//  Created by jihong zhang on 9/27/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZAddress.h"

@interface JZStoreInfo : NSObject

@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) JZAddress *address;

-(id)initWithStoreName:(NSString*)storeName address:(JZAddress*)address;

@end
