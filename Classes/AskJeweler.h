//
//  AskJeweler.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 05/05/11.
//  Copyright 2011 Deemag Infotech Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AskJeweler : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> 
{
	UITextView					*questionTextView;
	UITextField					*zip;
	UITextField					*numberTxt;
	NSString					*questionStr;
    NSMutableArray              *categoryArray;
	UIActivityIndicatorView		*activityIndicator;
	float						mylat;
	float						mylng;
	BOOL						isKeyBoardUp;
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

@end




// Ask a question from PSA