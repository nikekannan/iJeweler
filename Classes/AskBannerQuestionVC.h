//
//  AskBannerQuestionVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 28/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AskBannerQuestionVC : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> 
{
	UITextView					*questionTextView;
    UITableView                 *myTable;
	UITextField					*zip;
	UITextField					*numberTxt;
	NSString					*questionStr;
	NSString					*toid;
    NSMutableArray              *categoryArray;
	UIActivityIndicatorView		*activityIndicator;
	float						mylat;
	float						mylng;
    int                         category;
	BOOL						isKeyBoardUp;
	BOOL						isQuestionToJeweler;
}

@property (nonatomic, retain) NSString	*questionStr;
@property (nonatomic, retain) NSString	*toid;

// geo code of zip
- (void) callToFindReverseGeoCoding;

// send question to server
- (void) sendMessage;

// save question to local DB with qid
- (void) saveQuestion:(NSString*)qid;

// get the categories
- (NSString *)stringWithUrl:(NSURL *)url;

// pop current view controller
- (void) goBack;

- (void) loadTable;
- (void) reloadTableView;

- (void) sendButtonClicked;
@end
