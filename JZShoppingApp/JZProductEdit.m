//
//  JZProductEdit.m
//  JZShoppingApp
//
//  Created by jihong zhang on 4/30/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZProductEdit.h"
#import "JZProductCell.h"
#import <QuartzCore/QuartzCore.h>
#import "JZProductsModel.h"
#import "JZConstants.h"
#import "JZProtocol.h"


@interface JZProductEdit ()


@property (nonatomic) UIButton *buttonSaveEdit;
@property (nonatomic) UIButton *buttonResetEdit;

@property (nonatomic) UITextField *textFieldName;
@property (nonatomic ) UITextField *textFieldRegPrice;
@property (nonatomic) UITextField *textFieldSalePrice;

@property (nonatomic) NSMutableArray *storesInfo;
@property (nonatomic) NSMutableArray *addrsInfo;

@property (nonatomic) UITextField *textFieldPhoto;
@property (nonatomic) UITextField *textFieldColor;
@property (nonatomic) UITextField *textFieldDescript;

@property (nonatomic) UIScrollView *myScrollView;
@property (nonatomic) UIFont *fontSize;
@property (nonatomic) CGFloat  myScrollViewHeight;

@property (nonatomic) Boolean isEdited;

@end

@implementation JZProductEdit


#pragma mark - subview init
#pragma mark addLabelInMyView
-(void)addLabelInMyView:(UIScrollView*)myView withText:(NSString*)lableText withFram:(CGRect*)frame
{
    UILabel *label = [[UILabel alloc] init];
    label.text = lableText;
    label.frame = *frame;
    label.font =  self.fontSize;  
    [myView addSubview:label];    
}

#pragma mark addTextField with placeholder= @"Required field"
-(void)addTextField:(UITextField*)textField inMyView:(UIScrollView*)myView withText:(NSString*)text withFram:(CGRect*)frame
{
    textField.frame = *frame;
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = self.fontSize;
    textField.placeholder = @"Required field";
    textField.text = text;
    [myView addSubview:textField];
 
}

#pragma mark addTextField with placeholder(passed in)
-(void)addTextField:(UITextField*)textField inMyView:(UIScrollView*)myView withText:(NSString*)text withFfram:(CGRect*)frame placeholder:(NSString*)placeholder
{
    textField.frame = *frame;
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = self.fontSize;  
    textField.placeholder = placeholder;
    textField.text = text;    
    [myView addSubview:textField];
}

#pragma mark addTextView
-(void)addTextView:(UITextView*)textView inMyView:(UIScrollView*)myView withText:(NSString*)text withFram:(CGRect*)frame
{
    textView.frame = *frame;
    textView.delegate = self;
    textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textView.layer.borderWidth = 2.3;
    textView.layer.cornerRadius = 5.0;
    textView.font = self.fontSize;
    textView.clipsToBounds = YES;
    textView.text = text;
    [myView  addSubview:textView];
    
}

#pragma mark addStoreName
-(void)addStoreName:(NSString*)name address:(NSString*)addr inLayoutIndex:(int)index inObjetIndex:(int)objIndex
{
    UITextField *textFieldStoreName = [[UITextField alloc]init];
    UITextView *textViewAddr = [[UITextView alloc]init];

    CGFloat storeNameX = myMargin;
    CGFloat storeNameY = myLabelHight * index + myMargin * (index + 1);
    CGFloat storeNameWidth = self.view.frame.size.width - myMargin * 2;
    CGFloat storeNameHeight = myTextFieldHight;
    CGRect frame = CGRectMake(storeNameX, storeNameY, storeNameWidth, storeNameHeight);
    [self addTextField:textFieldStoreName inMyView:self.myScrollView withText:name withFfram:&frame placeholder:@"Store Name"];
    
    index ++;
    CGFloat txtStoreX = myMargin;
    CGFloat txtStoreY = storeNameY + storeNameHeight + myMargin;
    CGFloat txtStoreWidth = self.view.frame.size.width - myMargin * 2;
    CGFloat txtStoreHeight = myTextViewHight;
    
    frame = CGRectMake(txtStoreX,txtStoreY,txtStoreWidth,txtStoreHeight);
    [self addTextView:textViewAddr inMyView:self.myScrollView withText:addr withFram:&frame];
    
    self.storesInfo[objIndex] = textFieldStoreName;
    self.addrsInfo[objIndex] = textViewAddr;

}

#pragma mark addButton
-(void)addButton:(UIButton*)button inMyView:(UIScrollView*)myView withTitle:(NSString*)title withFfram:(CGRect*)frame select:(NSString*)mySelector
{
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = *frame ;
    [button setTitle:title
             forState:(UIControlState)UIControlStateNormal];
    SEL selector =  NSSelectorFromString(mySelector);
    [button addTarget:self
                action:selector 
      forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [self.myScrollView addSubview:button];
 
}

#pragma mark widgetIndex
// this is for internal use only
// this is the the main widgets layout control
// if you cahnge the order in it, the related widget layout
// position will be changed as well
enum widgetIndex{
    //savebuttonIndex = 0,   I use tooBarButton to replace them
    nameIndex = 0,
    priceLabelIndex,
    priceIndex,
    photoLabelIndex ,
    photoIndex,
    colorLabelIndex,
    colorIndex,
    descriptionLabelIndex,
    descriptionIndex,
    stroeLabelIndex,
    storeNameIndex,
    storeAddrLabelIndex,
    storeAddrIndex,
};

-(int)trimmingAllWhiteSpace:(NSString*)text
{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return text.length;
}

#pragma mark - button click callback
#pragma mark saveChanges
-(void)saveChanges:(id)sender
{
    NSMutableString *errorInfo = [NSMutableString stringWithCapacity:1];
    //TODO
    //need to add stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
    int length = 0;
    length = [self trimmingAllWhiteSpace:self.textFieldName.text];
    if(length == 0){
        [errorInfo appendString:@"Name "];
    }
    length = [self trimmingAllWhiteSpace:self.textFieldRegPrice.text];
    if(length == 0){
        [errorInfo appendString:@"RegPrice "];
    }
    length = [self trimmingAllWhiteSpace:self.textFieldSalePrice.text];
    if(length == 0){
        [errorInfo appendString:@"SalePrice "];
    }
    length = [self trimmingAllWhiteSpace:self.textFieldColor.text];
    if(length == 0){
        [errorInfo appendString:@"Color "];
    }
    length = [self trimmingAllWhiteSpace:self.textFieldPhoto.text];
    if(length == 0){
        [errorInfo appendString:@"Photo "];
    }
    
    /*
    if(self.textFieldName.text.length == 0){
        [errorInfo appendString:@"Name "];
    }
    if(self.textFieldRegPrice.text.length == 0){
        [errorInfo appendString:@"RegPrice "];
    }
    if(self.textFieldSalePrice.text == 0){
        [errorInfo appendString:@"SalePrice "];
    }
    if(self.textFieldColor.text==0){
        [errorInfo appendString:@"Colors "];
    }
    if(self.textFieldPhoto.text==0){
        [errorInfo appendString:@"Photos "];
    }
     */
    
    //TODO: add more checking for all the input fields
    if(errorInfo.length > 1){
        UIAlertView *errorAlertView =[[UIAlertView alloc] initWithTitle:@"Missing fields:" message:errorInfo delegate:self cancelButtonTitle:@"Cancel Save" otherButtonTitles:nil, nil];
        [errorAlertView show];
        return;
    }
    
    JZProductCell *item = self.item;
    
    item.name = self.textFieldName.text;
    item.regPrice = [[self.textFieldRegPrice.text  stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue];
    item.salePrice = [[self.textFieldSalePrice.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue];
    
    NSString *colorsStr = [[NSString alloc] initWithString:self.textFieldColor.text];
    NSArray *colors = [colorsStr componentsSeparatedByString:@","];
    item.colors = [colors mutableCopy];
    
    item.description = self.textFieldDescript.text;
    
    NSString *photoStr = [[NSString alloc] initWithString:self.textFieldPhoto.text];
    NSArray *photos = [photoStr componentsSeparatedByString:@","];
    item.images = [photos mutableCopy];

    
    NSMutableArray *stores = [[NSMutableArray alloc] init];
    NSMutableArray *addresses = [[NSMutableArray alloc] init];
    int j =0;
    for(int i=0; i< maxStoresAllowedForEachProduct; i++){
        UITextView *textField = self.storesInfo[i];
        UITextView *textView = self.addrsInfo[i];
        NSString *store = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *addr = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(store.length > 0){
            stores[j] = store;
            addresses[j++] = addr;
        }
    }
    
    if(j > 0){
        NSMutableDictionary  *arrayStoreAddress = [[NSMutableDictionary alloc] initWithObjects:addresses forKeys:stores];
        item.stores = arrayStoreAddress;
    }else{
        item.stores = [[NSMutableDictionary alloc] init];
    }
         
    
    //save the data to database
    int productId = item.productId;
    
    if(self.isEdit == TRUE){ //save edit
        //save the data to database
        if(productId > 0){ // if product id <= 0, do data save in DB
            [JZProductsModel deleteOneProductFromDb:productId];
            [JZProductsModel insertOneProductToDb:item];
        }
        if ([self.delegate respondsToSelector:@selector(onSaveEditSuccess:)]) {
            [self.delegate onSaveEditSuccess:item];
        }
        
    }else{ //add product
        item.productId = 0;
        [JZProductsModel insertOneProductToDb:item];
        
        //pass data to parent page: tableViewProducts
        if ([self.delegate respondsToSelector:@selector(onAddSuccess:)]) {
            [self.delegate onAddSuccess:item];
        }
    }
        
    //leave this page
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark resetChanges
-(void)resetChanges:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark initWithProductCell
-(id)initWithProductCell:(JZProductCell*)productCell
{
    self = [super init];
    
    if(self){
        //init widgets that need too hold the values
        self.buttonSaveEdit = [[UIButton alloc] init];
        self.buttonResetEdit = [[UIButton alloc] init];
        self.textFieldName = [[UITextField alloc] init];
        self.textFieldRegPrice = [[UITextField alloc] init];
        self.textFieldSalePrice = [[UITextField alloc] init];
        self.textFieldPhoto = [[UITextField alloc] init];
        self.textFieldColor = [[UITextField alloc] init];
        self.textFieldDescript = [[UITextField alloc] init];
        self.item = productCell;
        
        self.fontSize = [UIFont systemFontOfSize:myFontSize];
        enum widgetIndex index ;
        CGRect frame;
        
        self.isEdited = FALSE;
         
        //product name
        index = nameIndex;
        CGFloat labelX =  myMargin;
        CGFloat labelY = myLabelHight * index + myMargin * (index + 1);
        CGFloat labelWidth = (self.view.frame.size.width - myMargin * 3)/5;
        frame = CGRectMake(labelX, labelY, labelWidth, myLabelHight);
        [self addLabelInMyView:self.myScrollView withText:@"Name:" withFram:&frame];
        
        CGFloat fieldX= labelX + labelWidth + myMargin;
        CGFloat fieldY = myLabelHight * index + myMargin * (index + 1);
        CGFloat fieldWidth = (self.view.frame.size.width - myMargin * 3)/5 *4;
        CGFloat fieldHeight = myLabelHight;
        frame = CGRectMake(fieldX, fieldY, fieldWidth, fieldHeight);
        //self.textFieldName = [[UITextField alloc] init];
        
        [self addTextField:self.textFieldName inMyView:self.myScrollView withText:productCell.name withFram:&frame];
        
        //price
        index = priceLabelIndex;
        CGFloat regPriceX = myMargin;
        CGFloat regPriceY =  myLabelHight * index + myMargin * (index + 1);
        CGFloat regPriceWidth = (self.view.frame.size.width - myMargin * 3)/2;
        CGFloat regPriceHeight = myLabelHight;
        frame = CGRectMake(myMargin, regPriceY, regPriceWidth , regPriceHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Reg. price:" withFram:&frame];
        
        CGFloat salePriceX = regPriceX + regPriceWidth + myMargin;
        frame =  CGRectMake(salePriceX, regPriceY, regPriceWidth , regPriceHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Sale price:" withFram:&frame];
                
        //textfield
        index = priceIndex;
        CGFloat regTextFieldX = regPriceX ;
        CGFloat regTextFieldY = myLabelHight * index + myMargin * (index + 1);
        CGFloat regTextFieldWidth = regPriceWidth;
        CGFloat regTextFieldHeight = myTextFieldHight;
        frame = CGRectMake(regTextFieldX, regTextFieldY, regTextFieldWidth, regTextFieldHeight);
        [self addTextField:self.textFieldRegPrice inMyView:self.myScrollView withText:[NSString stringWithFormat:@"$%.2f", [productCell regPrice]] withFram:&frame];
        
        CGFloat saleTextFieldX = regTextFieldX + regTextFieldWidth + myMargin;
        CGFloat saleTextFieldY = regTextFieldY ;
        frame = CGRectMake(saleTextFieldX, saleTextFieldY, regTextFieldWidth, regTextFieldHeight);
        [self addTextField:self.textFieldSalePrice inMyView:self.myScrollView withText:[NSString stringWithFormat:@"$%.2f", [productCell salePrice]] withFram:&frame];
   
        //photo
        index = photoLabelIndex;
        CGFloat photoX = myMargin;
        CGFloat photoY = myLabelHight * index + myMargin * (index + 1);
        CGFloat photoWidth = self.view.frame.size.width - myMargin * 2;
        CGFloat photoHeight = myLabelHight;
        frame = CGRectMake(photoX, photoY, photoWidth, photoHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Product photos (max allowed is 5):" withFram:&frame];
        
        index = photoIndex;
        CGFloat txtPhotoX = myMargin;
        CGFloat txtPhotoY = myLabelHight * index + myMargin * (index + 1);
        CGFloat txtPhotoWidth = self.view.frame.size.width - myMargin * 2;
        CGFloat txtPhotoHeight = myTextFieldHight;
        NSString *images = @"";
        if(productCell.images.count > 0){
            images = [NSString stringWithFormat:@"%@", [productCell.images objectAtIndex:0]];
            for(int i=1; i< productCell.images.count; i++){
                images = [images stringByAppendingString:@", "];
                images = [images stringByAppendingString:[productCell.images objectAtIndex:i]];
            }
        }
        frame = CGRectMake(txtPhotoX,txtPhotoY,txtPhotoWidth,txtPhotoHeight);
        [self addTextField:self.textFieldPhoto inMyView:self.myScrollView withText:images withFram:&frame];
        
        //color
        index = colorLabelIndex;
        CGFloat colorX = myMargin;
        CGFloat colorY = myLabelHight * index + myMargin * (index + 1);
        CGFloat colorWidth = self.view.frame.size.width - myMargin * 2;
        CGFloat colorHeight = myLabelHight;
        frame = CGRectMake(colorX, colorY, colorWidth, colorHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Product colors (max allowed is 5):" withFram:&frame];
        
        index = colorIndex;
        CGFloat txtColorX = myMargin;
        CGFloat txtColorY = myLabelHight * index + myMargin * (index + 1);
        CGFloat txtColorWidth = self.view.frame.size.width - myMargin * 2;
        CGFloat txtColorHeight = myTextFieldHight;
        frame = CGRectMake(txtColorX,txtColorY,txtColorWidth,txtColorHeight);
        NSString *colors = @"";
        if(productCell.colors.count > 0){
            colors = [NSString stringWithFormat:@"%@", [productCell.colors objectAtIndex:0]];
            for(int i=1; i< productCell.colors.count; i++){
                colors = [colors stringByAppendingString:@", "];
                colors = [colors stringByAppendingString:[productCell.colors objectAtIndex:i]];
            }
        }
        [self addTextField:self.textFieldColor inMyView:self.myScrollView withText:colors withFram:&frame];
        
        //description
        index = descriptionLabelIndex;
        CGFloat descriptX = myMargin;
        CGFloat descriptY = myLabelHight * index + myMargin * (index + 1);
        CGFloat descriptWidth = self.view.frame.size.width - myMargin * 2;
        CGFloat descriptHeight = myLabelHight;
        frame = CGRectMake(descriptX, descriptY, descriptWidth, descriptHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Product description:" withFram:&frame];
        
        index = descriptionIndex;
        CGFloat txtDescriptX = myMargin;
        CGFloat txtDescriptY = myLabelHight * index + myMargin * (index + 1);
        CGFloat txtDescriptWidth = self.view.frame.size.width - myMargin * 2;
        CGFloat txtDescriptHeight = myTextFieldHight;
        frame = CGRectMake(txtDescriptX,txtDescriptY,txtDescriptWidth,txtDescriptHeight);
        [self addTextField:self.textFieldDescript inMyView:self.myScrollView withText:productCell.description withFram:&frame];
        
        //label stores
        index = stroeLabelIndex;
        CGFloat storeX = myMargin;
        CGFloat storeY = myLabelHight * index + myMargin * (index + 1);
        CGFloat storeWidth = self.view.frame.size.width - myMargin * 2;
        CGFloat storeHeight = myLabelHight;
        frame = CGRectMake(storeX, storeY, storeWidth, storeHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Product in stores (optional):" withFram:&frame];
        
        //list of store name & addr
        index = storeNameIndex;
        [productCell.stores removeObjectForKey:@""];
        [productCell.stores removeObjectForKey:@" "];
        NSArray *storeNames = [productCell.stores allKeys];;
        storeNames = [storeNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        self.storesInfo = [[NSMutableArray alloc] init];
        self.addrsInfo = [[NSMutableArray alloc] init];
        for(int i=0; i< maxStoresAllowedForEachProduct; i++){
            if( i < storeNames.count){
                if( [[storeNames objectAtIndex:i] length] < 1){
                    continue;
                }
                NSString *addr = [productCell.stores objectForKey:storeNames[i]];
                [self addStoreName:storeNames[i] address:addr  inLayoutIndex:index  inObjetIndex:i];
            }else{
                [self addStoreName:@"" address:@"" inLayoutIndex:index  inObjetIndex:i];
            }
            index += 3; //store name + textView height = 2 * myLabelHight
        }
        
        //make the content size large enough to hole all the widgets
        //if we already have 5 store, only need to plus 2 as extra
        //othewise need to reserve the space for the stores info
        index = index + (storeNames.count >= maxStoresAllowedForEachProduct ? 2: (maxStoresAllowedForEachProduct * 3 + 2));
        CGFloat lastY = myLabelHight * index + myMargin * (index + 1);
        self.myScrollViewHeight = self.view.frame.size.height > lastY? self.view.frame.size.height : lastY;
        self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width,  self.myScrollViewHeight);
        
        [self.view addSubview:self.myScrollView];
    }
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
    }
    return self;
}

#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
     self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.myScrollView.scrollEnabled=YES;
    self.myScrollView.showsHorizontalScrollIndicator = YES;
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Text field delegate
//TODO need to dynamically get the keyboard size 
//const int keyboardSizeHeight = 235;

#pragma mark textFieldDidBeginEditing
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat framHeight = self.view.frame.size.height;
    CGFloat visibalHeight = framHeight - keyboardSizeHeight;
    CGFloat textFieldBottomY = textField.frame.origin.y + textField.frame.size.height/2;
    CGFloat gap = textFieldBottomY - visibalHeight;    

    if(textFieldBottomY > visibalHeight){
        CGPoint scrollPoint = CGPointMake(0.0, gap);        
        [self.myScrollView setContentOffset:scrollPoint animated:YES];
        //[self.myScrollView setContentSize:CGSizeMake(300, 350)];
    }
}

#pragma mark textFieldDidEndEditing
-(void)textFieldDidEndEditing:(UITextField *)textField {
    //keyboard will hide
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width,  self.myScrollViewHeight);
    self.isEdited = TRUE;
}

#pragma mark textFieldShouldReturn
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Text View delegate
#pragma mark  textView shouldChangeTextInRang replacementText
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

#pragma mark textViewDidBeginEditing
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGFloat framHeight = self.view.frame.size.height;
    CGFloat visibalHeight = framHeight - keyboardSizeHeight;
    CGFloat textFieldBottomY = textView.frame.origin.y + textView.frame.size.height/2;
    CGFloat gap = textFieldBottomY - visibalHeight;
    
    if(textFieldBottomY > visibalHeight){
        CGPoint scrollPoint = CGPointMake(0.0, gap);
        [self.myScrollView setContentOffset:scrollPoint animated:YES];
    }
  
}

#pragma mark textViewDidEndEditing
- (void)textViewDidEndEditing:(UITextView *)textView
{
    //keyboard will hide
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width,  self.myScrollViewHeight);
    self.isEdited = TRUE;
}

@end
