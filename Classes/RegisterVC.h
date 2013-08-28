//
//  RegisterVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 28/01/11.
//  Copyright 2011 Deemag Infotech Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
	UITableView		*myTable;
	UITextField		*nameTxtField;
	UITextField		*shopTxtField;
	UITextField		*emailTxtField;
	UITextField		*phoneTxtField;
	UITextField		*streetTxtField;
	UITextField		*cityTxtField;
	UITextField		*stateTxtField;
	UITextField		*zipTxtField;
	
	NSString		*nameStr;
	NSString		*shopStr;
	NSString		*emailStr;
	NSString		*phoneStr;
	NSString		*addrsStr;
	NSString		*streetStr;
	NSString		*cityStr;
	NSString		*stateStr;
	NSString		*zipStr;
	
	UIActivityIndicatorView *activityIndicator;
	
	BOOL			isKeyBoardUp;
}

@property (nonatomic, retain) NSString	*nameStr;
@property (nonatomic, retain) NSString	*shopStr;
@property (nonatomic, retain) NSString	*emailStr;
@property (nonatomic, retain) NSString	*phoneStr;
@property (nonatomic, retain) NSString	*addrsStr;
@property (nonatomic, retain) NSString	*streetStr;
@property (nonatomic, retain) NSString	*cityStr;
@property (nonatomic, retain) NSString	*stateStr;
@property (nonatomic, retain) NSString	*zipStr;

- (void) loadDefaultLogo;
- (void) loadTable;
- (void) loadActivityIndicator;
- (void) resignAllResponders;
- (void) addPhoto;
- (void) submit;
- (void) goBack;
@end
