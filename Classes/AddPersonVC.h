//
//  AddPersonVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/28/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddPersonVC : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
	NSDateFormatter	*dateFormatter;
	NSMutableArray	*stoneNameArray;
	NSMutableArray	*jewelColorArray;
	NSMutableArray	*jewelStyleArray;
	NSMutableArray	*watchStyleArray;
	NSMutableArray	*relationArray;
	NSMutableArray	*eventsArray;
	
	UIScrollView	*myScrollView;
	
	UITextField		*nameTxtField;
	UITextField		*relationTxtField;
	UITextField		*dobTxtField;
	UITextField		*eventTxtField;
	UITextField		*budgetTxtField1;
	UITextField		*budgetTxtField2;
	
	UILabel			*stoneNameLabel;
	UIButton		*askQtnAboutStone;
	
	UIImageView		*birthStoneImageView;
	
	UIView			*datePickerHolder;
	UIDatePicker	*myDatePicker;
	NSString		*dateStr;
	
	UIView			*relationPickerView;
	UIPickerView	*relationPicker;
	
	UIView			*eventPickerView;
	UIPickerView	*eventPicker;
	
	UIBarButtonItem *save;
	
	int				jewelColor[4];
	int				jewelStyle[7];
	int				watchStyle[26];
	int				stoneNumber;
	
	BOOL			isPickerUP;
	BOOL			isDatePickerUP;
	BOOL			isEventPickerUP;
	BOOL			isRelationPickerUP;
}

@property (nonatomic, retain) NSString *dateStr;

- (void) loadScrollView;
- (void) loadDatePickerView;
- (void) loadRelationPickerView;
- (void) loadEventPickerView;
- (void) dateSelected:(id)sender;
- (void) jewelButtonColor:(id)sender;
- (void) jewelStyleButton:(id)sender;
- (void) watchStyleButton:(id)sender;
- (void) saveToDB:(NSString*)psaID;
- (void) executeSQLQuery:(NSString*)query;
- (void) goBack;
- (void) askAQuestion;
- (void) resignAllTextFields;

- (void)scrollViewToCenterOfScreen:(UIView *)theView ;

// to send psa to server
- (void) sendPSA;
@end
