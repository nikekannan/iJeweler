//
//  AddPersonVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/28/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UpdatePersonVC : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>
{
	NSDateFormatter	*dateFormatter;
	UIView			*shareView;
	UITableView		*myTable;
	
	NSMutableArray	*infoArray;
	NSMutableArray	*stoneNameArray;
	NSMutableArray	*jewelColorArray;
	NSMutableArray	*jewelStyleArray;
	NSMutableArray	*watchStyleArray;
	NSMutableArray	*relationArray;
	NSMutableArray	*eventsArray;
	NSMutableArray	*jewelersArray;

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
	
	int				jewelColor[4];
	int				jewelStyle[7];
	int				watchStyle[26];
	int				stoneNumber;
	int				rowid;
	
	BOOL			isShareViewUP;
	BOOL			isPickerUP;
	BOOL			isDatePickerUP;
	BOOL			isEventPickerUP;
	BOOL			isRelationPickerUP;
	BOOL			isUpdatePSA;
}

@property int rowid;
@property (nonatomic, retain) NSString	*dateStr;

- (void) loadScrollView;
- (void) loadToolBar;
- (void) loadDatePickerView;
- (void) loadRelationPickerView;
- (void) loadEventPickerView;
- (void) loadShareView;
- (void) dateSelected:(id)sender;
- (void) addMoreEvents;
- (void) jewelButtonColor:(id)sender;
- (void) jewelStyleButton:(id)sender;
- (void) watchStyleButton:(id)sender;
- (void) saveToDB;
- (void) executeSQLQuery:(NSString*)query;
- (void) goBack;
- (void) askAQuestion;
- (void) resignAllTextFields;
- (void) reloadTable;

// SQLITE ACCESS
- (void) getDataFromDB;
- (void) getJewelersList;

- (void)scrollViewToCenterOfScreen:(UIView *)theView ;
@end
