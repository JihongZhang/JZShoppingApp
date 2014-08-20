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
#import "JZCheckBox.h"



@interface JZProductEdit ()


@property (nonatomic) UIButton *buttonSaveEdit;
@property (nonatomic) UIButton *buttonResetEdit;

@property (nonatomic) UITextField *textFieldName;
@property (nonatomic ) UITextField *textFieldRegPrice;
@property (nonatomic) UITextField *textFieldSalePrice;

@property (nonatomic) UITextField *textFieldPhoto;
@property (nonatomic) UITextField *textFieldColor;
@property (nonatomic) UITextField *textFieldDescript;

@property (nonatomic) NSMutableArray *storesInfo;
@property (nonatomic) NSMutableArray *addrsInfo;
@property (nonatomic) NSMutableArray *checkBoxInfo;

// for holding the display information of stores info
// if cancel edit: keep the product cell info untouched
// if save the edit, copy storesForDisplay to (productCell)item.stores
@property (nonatomic) NSMutableDictionary *storesForDisplay;
@property (nonatomic) int numberOfDisplayStores;


@property (nonatomic) UIScrollView *myScrollView;
@property (nonatomic) UIFont *fontSize;
@property (nonatomic) CGFloat  myScrollViewHeight;

@property (nonatomic) Boolean isEdited;


@property (nonatomic) CGRect   activeFieldFrame;

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
-(void)addTextField:(UITextField*)textField inMyView:(UIScrollView*)myView withText:(NSString*)text withFrame:(CGRect*)frame
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
-(void)addTextField:(UITextField*)textField inMyView:(UIScrollView*)myView withText:(NSString*)text withFrame:(CGRect*)frame placeholder:(NSString*)placeholder
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
-(void)addStoreName:(NSString*)name address:(NSString*)addr inLayoutIndex:(int)index inObjectIndex:(int)objIndex
{
    UITextField *textFieldStoreName = [[UITextField alloc] init];
    UITextView *textViewAddr = [[UITextView alloc]init];
    
    CGFloat storeNameX = myMargin * 4; //move 5 margin size for checkbox
    CGFloat storeNameY = myLabelHight * index + myMargin * (index + 1);
    CGFloat storeNameWidth =  CGRectGetWidth(self.view.frame) - storeNameX - myMargin;
    CGFloat storeNameHeight = myTextFieldHight;
    CGRect frame = CGRectMake(storeNameX, storeNameY, storeNameWidth, storeNameHeight);
    [self addTextField:textFieldStoreName inMyView:self.myScrollView withText:name withFrame:&frame placeholder:@"Store Name"];
    
    //add check box next to the store name
    CGFloat checkX = myMargin;
    CGFloat checkY = storeNameY;
    CGFloat checkWidth = myCheckboxImageWidth;
    CGFloat checkHeight = myCheckboxImageHeight;
    frame = CGRectMake(checkX, checkY, checkWidth, checkHeight);
    JZCheckBox *checkBox = [[JZCheckBox alloc] initWithKey:name index:objIndex andFrame:frame];
    checkBox.delegate = self;
    [self.myScrollView addSubview:checkBox];
    
    index ++;
    CGFloat txtStoreX = myMargin;
    CGFloat txtStoreY = storeNameY + storeNameHeight + myMargin;
    CGFloat txtStoreWidth =  CGRectGetWidth(self.view.frame) - myMargin * 2;
    CGFloat txtStoreHeight = myTextViewHight;
    
    frame = CGRectMake(txtStoreX,txtStoreY,txtStoreWidth,txtStoreHeight);
    [self addTextView:textViewAddr inMyView:self.myScrollView withText:addr withFram:&frame];

    textFieldStoreName.tag = objIndex+100;
    textViewAddr.tag = objIndex+100;
    self.storesInfo[objIndex] = textFieldStoreName;
    self.addrsInfo[objIndex] = textViewAddr;
    self.checkBoxInfo[objIndex] = checkBox;
    
    [self.storesForDisplay setObject:addr forKey:name];
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


#pragma mark add store name and store address if the store name is not null
//-(void)storeInfoLayoutAtIndex:(int)index forProduct:(JZProductCell*)productCell
-(void)storeInfoLayoutAtIndex:(int)index forStores:(NSDictionary*)stores
{
    NSArray *storeNames = [stores allKeys];
    storeNames = [storeNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for(int i=0; i< storeNames.count; i++){
        if( i < storeNames.count){
            if( [[storeNames objectAtIndex:i] length] < 1){
                continue;
            }
            NSString *addr = [stores objectForKey:storeNames[i]];
            self.numberOfDisplayStores++;
            [self addStoreName:storeNames[i] address:addr  inLayoutIndex:index  inObjectIndex:i];
        }  
        index += 3; //store name + textView height = 2 * myLabelHight
    }
}



#pragma mark widgetIndex
// this is for internal use only
// this is the the main widgets layout control
// if you cahnge the order in it, the related widget layout
// position will be changed as well
typedef NS_ENUM(NSInteger, editPageWidgetIndex){
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
    seperateLineIndex,
    storeLabelIndex,
    storeNameIndex,
};

-(int)trimmingAllWhiteSpace:(NSString*)text
{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return text.length;
}

#pragma mark - page editing checking and alarm
-(void)checkIfPageEdited
{
    if(self.isEdited){
        UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Page has been edited" message:nil delegate:self cancelButtonTitle:@"Cancel Edit" otherButtonTitles:@"Save Edit", nil];
        alert.tag = 11;
        [alert show];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark alarm for edit and add product  
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11) { //for edit page and add page
        if (buttonIndex == 0) { //cancel editing in the page
          [self.navigationController popViewControllerAnimated:YES];
        }else{   //save editing in the page
            [self saveChanges:self];
        }
    }
}

#pragma mark - button save and cancel click callback
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

    //for stores info
    self.item.stores = [self.storesForDisplay mutableCopy];
    NSMutableArray *stores = [[NSMutableArray alloc] init];
    NSMutableArray *addresses = [[NSMutableArray alloc] init];
    int j =0;    
    for(int i=0; i< self.storesInfo.count; i++){
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
    
    if(self.pageTypeIsAdding == FALSE){ //page is for edit product: save edit
        //save the data to database
        if(productId > 0){ // if product id <= 0, do data save in DB
            [JZProductsModel deleteOneProductFromDb:productId];
            [JZProductsModel insertOneProductToDb:item];
        }
#ifdef KVCKVO
        [self.buttonAction setValue:@"edit" forKey:@"action"];
#else
        if ([self.delegate respondsToSelector:@selector(onSaveEditSuccess:)]) {
            [self.delegate onSaveEditSuccess:item];
        }
#endif
    }else{ //page is for adding product: add product
        item.productId = 0;
        [JZProductsModel insertOneProductToDb:item];
        
        //pass data to parent page: tableViewProducts
        if ([self.delegate respondsToSelector:@selector(onAddSuccess:)]) {
            [self.delegate onAddSuccess:item];
        }
    }
    
    NSLog(@"before leave edit page, after onAddSuccess");
    //leave this page
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark resetChanges
-(void)resetChanges:(id)sender
{
#ifdef KVCKVO
    [self.buttonAction setValue:@"reset" forKey:@"action"];
#endif
   [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark initWithProductCell
-(id)initWithProductCell:(JZProductCell*)productCell
{
    self = [super init];
    
    if(self){
        
        [self registerForKeyboardNotifications];
        
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
        self.storesForDisplay = [[NSMutableDictionary alloc] init];
        self.numberOfDisplayStores = 0;
        
        self.fontSize = [UIFont systemFontOfSize:myFontSize];
        enum editPageWidgetIndex widgetIndex ;
        CGRect frame;
        
        self.isEdited = FALSE;
         
        //product name
        widgetIndex = nameIndex;
        CGFloat labelX =  myMargin;
        CGFloat labelY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat labelWidth = ( CGRectGetWidth(self.view.frame) - myMargin * 3)/5;
        frame = CGRectMake(labelX, labelY, labelWidth, myLabelHight);
        [self addLabelInMyView:self.myScrollView withText:@"Name:" withFram:&frame];
        
        CGFloat fieldX= labelX + labelWidth + myMargin;
        CGFloat fieldY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat fieldWidth = ( CGRectGetWidth(self.view.frame) - myMargin * 3)/5 *4;
        CGFloat fieldHeight = myLabelHight;
        frame = CGRectMake(fieldX, fieldY, fieldWidth, fieldHeight);
        
        [self addTextField:self.textFieldName inMyView:self.myScrollView withText:productCell.name withFrame:&frame];
        
        //price
        widgetIndex = priceLabelIndex;
        CGFloat regPriceX = myMargin;
        CGFloat regPriceY =  myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat regPriceWidth = ( CGRectGetWidth(self.view.frame) - myMargin * 3)/2;
        CGFloat regPriceHeight = myLabelHight;
        frame = CGRectMake(myMargin, regPriceY, regPriceWidth , regPriceHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Reg. price:" withFram:&frame];
        
        CGFloat salePriceX = regPriceX + regPriceWidth + myMargin;
        frame =  CGRectMake(salePriceX, regPriceY, regPriceWidth , regPriceHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Sale price:" withFram:&frame];
                
        //textfield
        widgetIndex = priceIndex;
        CGFloat regTextFieldX = regPriceX ;
        CGFloat regTextFieldY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat regTextFieldWidth = regPriceWidth;
        CGFloat regTextFieldHeight = myTextFieldHight;
        frame = CGRectMake(regTextFieldX, regTextFieldY, regTextFieldWidth, regTextFieldHeight);
        [self addTextField:self.textFieldRegPrice inMyView:self.myScrollView withText:[NSString stringWithFormat:@"$%.2f", [productCell regPrice]] withFrame:&frame];
        
        CGFloat saleTextFieldX = regTextFieldX + regTextFieldWidth + myMargin;
        CGFloat saleTextFieldY = regTextFieldY ;
        frame = CGRectMake(saleTextFieldX, saleTextFieldY, regTextFieldWidth, regTextFieldHeight);
        [self addTextField:self.textFieldSalePrice inMyView:self.myScrollView withText:[NSString stringWithFormat:@"$%.2f", [productCell salePrice]] withFrame:&frame];
   
        //photo
        widgetIndex = photoLabelIndex;
        CGFloat photoX = myMargin;
        CGFloat photoY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat photoWidth =  CGRectGetWidth(self.view.frame) - myMargin * 2;
        CGFloat photoHeight = myLabelHight;
        frame = CGRectMake(photoX, photoY, photoWidth, photoHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Product photos (max allowed is 5):" withFram:&frame];
        
        widgetIndex = photoIndex;
        CGFloat txtPhotoX = myMargin;
        CGFloat txtPhotoY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat txtPhotoWidth =  CGRectGetWidth(self.view.frame) - myMargin * 2;
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
        [self addTextField:self.textFieldPhoto inMyView:self.myScrollView withText:images withFrame:&frame];
        
        //color
        widgetIndex = colorLabelIndex;
        CGFloat colorX = myMargin;
        CGFloat colorY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat colorWidth =  CGRectGetWidth(self.view.frame) - myMargin * 2;
        CGFloat colorHeight = myLabelHight;
        frame = CGRectMake(colorX, colorY, colorWidth, colorHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Product colors (max allowed is 5):" withFram:&frame];
        
        widgetIndex = colorIndex;
        CGFloat txtColorX = myMargin;
        CGFloat txtColorY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat txtColorWidth =  CGRectGetWidth(self.view.frame) - myMargin * 2;
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
        [self addTextField:self.textFieldColor inMyView:self.myScrollView withText:colors withFrame:&frame];
        
        //description
        widgetIndex = descriptionLabelIndex;
        CGFloat descriptX = myMargin;
        CGFloat descriptY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat descriptWidth =  CGRectGetWidth(self.view.frame) - myMargin * 2;
        CGFloat descriptHeight = myLabelHight;
        frame = CGRectMake(descriptX, descriptY, descriptWidth, descriptHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Product description:" withFram:&frame];
        
        widgetIndex = descriptionIndex;
        CGFloat txtDescriptX = myMargin;
        CGFloat txtDescriptY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat txtDescriptWidth =  CGRectGetWidth(self.view.frame) - myMargin * 2;
        CGFloat txtDescriptHeight = myTextFieldHight;
        frame = CGRectMake(txtDescriptX,txtDescriptY,txtDescriptWidth,txtDescriptHeight);
        [self addTextField:self.textFieldDescript inMyView:self.myScrollView withText:productCell.description withFrame:&frame];
        
        //seperate line
        widgetIndex = seperateLineIndex;
        CGFloat lineX = myMargin * 2;
        CGFloat lineY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1) + myLabelHight/2;
        CGFloat lineWidth =  CGRectGetWidth(self.view.frame) - myMargin * 4;
        CGFloat lineHeight = 1;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineX,lineY,lineWidth,lineHeight)];
        lineView.backgroundColor = [UIColor grayColor];
        [self.myScrollView addSubview:lineView];
        
        
        //label stores
        widgetIndex = storeLabelIndex;
        CGFloat storeX = myMargin;
        CGFloat storeY = myLabelHight * widgetIndex + myMargin * (widgetIndex + 1);
        CGFloat storeWidth =  CGRectGetWidth(self.view.frame)/2 - myMargin * 2 - 20;
        CGFloat storeHeight = myLabelHight;
        frame = CGRectMake(storeX, storeY, storeWidth, storeHeight);
        [self addLabelInMyView:self.myScrollView withText:@"Product in stores:" withFram:&frame];
        //button Add
        CGFloat buttonAddX = storeX + storeWidth + myMargin;
        CGFloat buttonAddY = storeY;
        CGFloat buttonAddWidth =  CGRectGetWidth(self.view.frame)/4 - myMargin * 2;
        CGFloat buttonAddHeight = myLabelHight;
        frame = CGRectMake(buttonAddX, buttonAddY, buttonAddWidth, buttonAddHeight);
        UIButton *buttonAdd = [[UIButton alloc] init];
        [self addButton:buttonAdd inMyView:self.myScrollView withTitle:@"Add" withFfram:&frame select:@"buttonAddStoreCB"];
        //button Delete
        CGFloat buttonDeleteX = buttonAddX + buttonAddWidth + myMargin;
        CGFloat buttonDeleteY = storeY;
        CGFloat buttonDeleteWidth =  CGRectGetWidth(self.view.frame)/4 - myMargin * 2;
        CGFloat buttonDeleteHeight = myLabelHight;
        frame = CGRectMake(buttonDeleteX, buttonDeleteY, buttonDeleteWidth, buttonDeleteHeight);
        UIButton *buttonDelete = [[UIButton alloc] init];
        [self addButton:buttonDelete inMyView:self.myScrollView withTitle:@"Delete" withFfram:&frame select:@"buttonDeleteStoreCB"];
        
        
        //list of store name & addr
        self.storesInfo = [[NSMutableArray alloc] init];
        self.addrsInfo = [[NSMutableArray alloc] init];
        self.checkBoxInfo = [[NSMutableArray alloc] init];
        widgetIndex = storeNameIndex;
        [productCell.stores removeObjectForKey:@""];
        [productCell.stores removeObjectForKey:@" "];
        [self storeInfoLayoutAtIndex:widgetIndex forStores:productCell.stores];
        
        
        //make the content size large enough to hole all the widgets
        // maxStoresAllowedForEachProduct * 3 * myLabelHight -- 5* each store info
        // plus 5 * myLabelHight as extra
        CGFloat lastY = widgetIndex * myLabelHight + myMargin * (widgetIndex + 1) + ( maxStoresAllowedForEachProduct * (myLabelHight + myMargin) * 3 ) + myLabelHight * 5;
        self.myScrollViewHeight =  CGRectGetHeight(self.view.frame) > lastY?  CGRectGetHeight(self.view.frame) : lastY;
        self.myScrollView.contentSize = CGSizeMake( CGRectGetWidth(self.view.frame),  self.myScrollViewHeight);
        
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
     self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  CGRectGetWidth(self.view.frame),  CGRectGetHeight(self.view.frame))];
    self.myScrollView.scrollEnabled=YES;
    self.myScrollView.showsHorizontalScrollIndicator = YES;
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myScrollView];
    self.isEdited = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Handle Notifications
#pragma mark Key board notification
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+CGRectGetHeight(self.activeFieldFrame), 0.0);
    self.myScrollView.contentInset = contentInsets;
    self.myScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= (kbSize.height + self.navigationController.navigationBar.frame.size.height);

    if (!CGRectContainsPoint(aRect, self.activeFieldFrame.origin) ) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.activeFieldFrame), CGRectGetMaxY(self.activeFieldFrame), CGRectGetWidth(self.activeFieldFrame), CGRectGetHeight(self.activeFieldFrame));
        [self.myScrollView scrollRectToVisible:frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.myScrollView.contentInset = contentInsets;
    self.myScrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - Text field delegate
#pragma mark textFieldDidBeginEditing
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeFieldFrame = textField.frame;
    self.isEdited = TRUE;
}

#pragma mark textFieldDidEndEditing
-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeFieldFrame = CGRectMake(0, 0, 0, 0);
    if(textField.tag >= 100){
        [self.storesForDisplay setObject:self.addrsInfo[textField.tag-100] forKey:self.addrsInfo[textField.tag-100]];
    }
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
    self.isEdited = TRUE;
    self.activeFieldFrame = textView.frame;
}

#pragma mark textViewDidEndEditing
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.activeFieldFrame = CGRectMake(0, 0, 0, 0);
    if(textView.tag >= 100){
        [self.storesForDisplay setObject:self.addrsInfo[textView.tag-100] forKey:self.addrsInfo[textView.tag-100]];
    }
}

#pragma mark - store info editing
#pragma mark buttonAddStoreCB
-(void)buttonAddStoreCB
{
    if(self.numberOfDisplayStores >= maxStoresAllowedForEachProduct){
        return;
    }
    
    self.numberOfDisplayStores++;
    int storeCount = self.numberOfDisplayStores;
    int index = storeNameIndex + (storeCount-1) * 3;
    [self addStoreName:@"" address:@"" inLayoutIndex:index  inObjectIndex:storeCount-1];
        
}

#pragma mark buttonDeleteStoreCB
-(void)buttonDeleteStoreCB
{    
    if(self.numberOfDisplayStores==0){
        return;
    }

    for(int i=self.storesInfo.count-1; i>=0; i--){
        JZCheckBox *checkBox = self.checkBoxInfo[i];
        UITextField *textFieldStoreName = self.storesInfo[i];
        UITextView *textViewAddr = self.addrsInfo[i];

        if(checkBox.isChecked == TRUE){
            self.numberOfDisplayStores--;
            [self.storesForDisplay removeObjectForKey:textFieldStoreName.text];
            [self.storesInfo removeObjectAtIndex:i];
            [self.addrsInfo removeObjectAtIndex:i];
            [self.checkBoxInfo removeObjectAtIndex:i];
        }
        //remove all the widgets 
        [checkBox removeFromSuperview];
        [textFieldStoreName removeFromSuperview];
        [textViewAddr removeFromSuperview];
    }
    
    //move the rest widgets up by redisplay them
    [self storeInfoLayoutAtIndex:storeNameIndex forStores:self.storesForDisplay];
    self.isEdited = TRUE;
}


#pragma mark - JZCheckBox delegate
-(void) onCheckBoxChange:(JZCheckBox *)checkBox isChecked:(BOOL)isChecked
{
    //add code to handle the event for check box state change
}



@end
