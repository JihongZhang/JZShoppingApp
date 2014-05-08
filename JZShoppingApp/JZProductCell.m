//
//  JZProductCell.m
//  DIYCell
//
//  Created by jihong zhang on 4/22/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZProductCell.h"
#import "JZLargeImageView.h"
#import "JZConstants.h"
#import "JZConstants.h"
#import "JZProtocol.h"



@interface JZProductCell()

@property (nonatomic) UIButton *buttonImage;
@property (nonatomic, retain) UILabel *nameView;
@property (nonatomic, retain) UILabel *regPriceView;
@property (nonatomic, retain) UILabel *salePriceView;
@property (nonatomic, retain) UILabel *descriptionView;
@property (nonatomic, retain) UIButton *buttonDetailView;

@property (nonatomic, retain) UILabel *lableColor;

@property (nonatomic, retain) UIButton *buttonColor1;
@property (nonatomic, retain) UIButton *buttonColor2;
@property (nonatomic, retain) UIButton *buttonColor3;
@property (nonatomic, retain) UIButton *buttonColor4;
@property (nonatomic, retain) UIButton *buttonColor5;

@end

@implementation JZProductCell

-(void) buttonImageEnlargeCB:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonImageTappedOnCell:)]) {
        [self.delegate buttonImageTappedOnCell:self];
    }
}

-(void)buttonDetailProductCB:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonDetailTappedOnCell:)]) {
        [self.delegate buttonDetailTappedOnCell:self];
    }
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]){
  
        UIFont *fontSize = [UIFont systemFontOfSize:myFontSize];
        
        self.buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonImage addTarget:self action:@selector(buttonImageEnlargeCB:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.buttonImage];
                       
        self.nameView = [[UILabel alloc] init];
        self.nameView.font = fontSize;
        [self.contentView addSubview:self.nameView];
        
        self.regPriceView = [[UILabel alloc] init];
        self.regPriceView.font = fontSize;
        [self.contentView addSubview:self.regPriceView];
        self.salePriceView = [[UILabel alloc] init];
        self.salePriceView.font = fontSize;
        [self.contentView addSubview:self.salePriceView];
        
        self.buttonColor1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonColor1 setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.buttonColor1];
        self.buttonColor2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonColor2 setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.buttonColor2];
        self.buttonColor3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonColor3 setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.buttonColor3];        
        self.buttonColor4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonColor4 setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.buttonColor4];
        self.buttonColor5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonColor5 setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.buttonColor5];
        
        
        self.lableColor = [[UILabel alloc] init];
        self.lableColor.text = @"Color:";
        self.lableColor.font = fontSize;
        [self.contentView addSubview:self.lableColor];

        self.buttonDetailView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [self.buttonDetailView addTarget:self action:@selector(buttonDetailProductCB:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.buttonDetailView];
                                                                
    }
    return self;
}


#pragma mark - init
#pragma mark layoutSubviews called when cell size change
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageHeight = self.contentView.frame.size.height - 2 * myMargin;
    CGFloat imageWidth = imageHeight;
    CGFloat imageX = myMargin;
    CGFloat imageY = myMargin;
    self.buttonImage.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    
    
    //set product name position and size
    CGFloat lableNameX = imageX + imageWidth + myMargin;
    CGFloat lableNameY = imageY;
    CGFloat lableNameWidth = self.contentView.frame.size.width - lableNameX - myMargin;
    CGFloat lableNameHeight = (self.contentView.frame.size.height - myMargin * 2) / 3 ;
    self.nameView.backgroundColor = [UIColor clearColor];
    self.nameView.frame = CGRectMake(lableNameX, lableNameY, lableNameWidth, lableNameHeight);
    
    //set product color lable position and size
    CGFloat lableColorX = lableNameX;
    CGFloat lableColorY = lableNameY + lableNameHeight;
    CGFloat lableColorWidth = lableNameWidth / 4;
    self.lableColor.backgroundColor = [UIColor clearColor];
    self.lableColor.frame = CGRectMake(lableColorX, lableColorY, lableColorWidth, lableNameHeight);
    
    //set color button
    CGFloat buttonColorWidth = lableNameHeight/10 * 8; 
    CGFloat buttonColorHeight = buttonColorWidth ;
    CGFloat buttonColorX = lableColorX + lableColorWidth + myMargin;
    CGFloat buttonColorY = lableColorY + lableNameHeight/10;
    self.buttonColor1.frame = CGRectMake(buttonColorX, buttonColorY, buttonColorWidth, buttonColorHeight);
    
    buttonColorX = buttonColorX + buttonColorWidth  + myMargin;
    self.buttonColor2.frame = CGRectMake(buttonColorX, buttonColorY, buttonColorWidth, buttonColorHeight);

    buttonColorX = buttonColorX + buttonColorWidth + myMargin;
    self.buttonColor3.frame = CGRectMake(buttonColorX, buttonColorY, buttonColorWidth, buttonColorHeight);
    
    buttonColorX = buttonColorX + buttonColorWidth + myMargin;
    self.buttonColor4.frame = CGRectMake(buttonColorX, buttonColorY, buttonColorWidth, buttonColorHeight);
    buttonColorX = buttonColorX + buttonColorWidth + myMargin;
    self.buttonColor5.frame = CGRectMake(buttonColorX, buttonColorY, buttonColorWidth, buttonColorHeight);
        
    
    //set detail button position and size
    CGFloat buttonDetailWidth = lableNameHeight;
    CGFloat buttonDetailHeight = buttonDetailWidth;
    CGFloat buttonDetailX = self.contentView.frame.size.width - myMargin - buttonDetailWidth;
    CGFloat buttonDetailY = buttonColorY; 
    self.buttonDetailView.frame = CGRectMake(buttonDetailX, buttonDetailY, buttonDetailWidth, buttonDetailHeight);
    
    //set product regSale price position and size
    CGFloat lableRegSaleY = lableNameY + lableNameHeight * 2;
    CGFloat lableRegSaleWidth = lableNameWidth/5 * 2;
    //self.regPriceView.backgroundColor = [UIColor clearColor];
    self.regPriceView.textColor = [UIColor grayColor];
    self.regPriceView.frame = CGRectMake(lableNameX, lableRegSaleY, lableRegSaleWidth, lableNameHeight);
    
    //set product sale price position and size
    CGFloat lableSaleWidth = lableNameWidth/5 * 3 ;
    CGFloat lableSaleX =  myMargin + lableNameX + lableRegSaleWidth;
    //self.salePriceView.backgroundColor = [UIColor clearColor];
    self.salePriceView.textColor = [UIColor redColor];
    self.salePriceView.frame = CGRectMake(lableSaleX, lableRegSaleY, lableSaleWidth, lableNameHeight);
}

#pragma mark setProduct
-(void)setProduct:(JZProductCell *)product{
    self.nameView.text = product.name;
    self.regPriceView.text = [NSString stringWithFormat:@"Reg: $%0.2f", product.regPrice];
    self.salePriceView.text = [NSString stringWithFormat:@"Sale: $%0.2f", product.salePrice];
    if(product.images.count > 0){
        UIImage *image = [UIImage imageNamed:[[product images] objectAtIndex:0]];
        [self.buttonImage setBackgroundImage:image forState:UIControlStateNormal];
    }

    NSArray *buttonColorsArray = @[self.buttonColor1, self.buttonColor2, self.buttonColor3, self.buttonColor4, self.buttonColor5];
    int i;
    for(i=0; i< product.colors.count; i++){
        UIButton *button = [buttonColorsArray objectAtIndex:i];
        NSString *colorName = [[product.colors objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(colorName.length < 2){
            break;
        }

        colorName = [colorName lowercaseString];
        colorName = [colorName stringByReplacingOccurrencesOfString:@"color" withString:@"Color"];
        if ([colorName rangeOfString:@"Color"].location == NSNotFound) {
            colorName = [colorName stringByAppendingString:@"Color"];
        }

        SEL selector = NSSelectorFromString(colorName);
        UIColor *color = [UIColor  clearColor];
        if ([UIColor respondsToSelector:selector]) {
            color = [UIColor performSelector:selector];
            button.backgroundColor = color;
        }
         
    }
    for(i=i; i< maxColorsAllowedForEachProduct; i++){
        UIButton *button = [buttonColorsArray objectAtIndex:i];
        button.backgroundColor = [UIColor clearColor];
    }
}


@end
