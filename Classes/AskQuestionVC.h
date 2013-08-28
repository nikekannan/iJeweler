//
//  AskQuestionVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 2/1/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AskQuestionVC : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> 
{
	UITextView					*questionTextView;
    UITableView                 *myTable;
	UITextField					*zip;
	UITextField					*numberTxt;
	NSString					*questionStr;
    NSMutableArray              *categoryArray;
	UIActivityIndicatorView		*activityIndicator;
	float						mylat;
	float						mylng;
    int                         category;
	BOOL						isKeyBoardUp;
	BOOL						isQuestionToJeweler;
}

@property (nonatomic, retain) NSString	*questionStr;

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
