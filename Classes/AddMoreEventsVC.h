//
//  AddMoreEventsVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 5/1/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerView;
@interface AddMoreEventsVC : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>
{
	NSDateFormatter	*dateFormatter;
	UIView			*containerView;
	UIView			*view1;
	UIView			*view2;
	UITableView		*myTable;
	UIBarButtonItem *add;
	
	NSMutableArray	*infoArray;
	NSMutableArray	*eventsArray;

	UITextField		*dobTxtField;
	UITextField		*eventTxtField;

	UIView			*datePickerHolder;
	UIDatePicker	*myDatePicker;
	NSString		*dateStr;

	UIView			*eventPickerView;
	UIPickerView	*eventPicker;
	
	int				rowid;
	
	BOOL			isPickerUP;
	BOOL			isDatePickerUP;
	BOOL			isEventPickerUP;
	BOOL			isUpdatePSA;
	BOOL			transitioning;

    // banner
    BannerView              *banner;
    BOOL                    isBannerAnimating;
    BOOL                    loadFirstBanner;
    
    // info view
    UIView                  *infoView;
    BOOL                    isInfoVisible;
}

@property int rowid;
@property (nonatomic, retain) NSString	*dateStr;
@property  BOOL  isBannerAnimating;

- (void) loadTable;
- (void) loadForm;
- (void) loadDatePickerView;
- (void) loadEventPickerView;
- (void) editEvent;
- (void) nextTransition;
- (void) dateSelected:(id)sender;

//Other events manipulation with server
- (void) getOtherEventsList;
- (void) addOtherEventToServer;
- (void) updateOtherEvent;
- (void) deleteOtherEvent:(NSString*) row_id;

- (void) animatePickerView:(id)sender;

- (void) resignAllTextFields;

- (void) saveButtonClicked;
- (void) cancelButtonClicked;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;


@end
