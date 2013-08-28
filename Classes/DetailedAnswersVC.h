//
//  DetailedAnswersVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/29/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@class BannerView;

@interface DetailedAnswersVC : UIViewController <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DownloaderDelegate> {
	UITextView				*answerTxtView;
	UIView					*containerView;
	UITableView				*myTable;
	UIView					*view1;	// holds answer and reply button
	UIView					*view2; // to make answer
	
	UIBarButtonItem			*infoItem;
	UIBarButtonItem			*cancelMsgItem;
	
	NSMutableArray			*answersArray;
	NSDictionary			*infoDict;
	
	UIActivityIndicatorView	*activityIndicator;
	
	UIButton				*attachButton;
	UILabel					*attachCount;

	BOOL					transitioning;
	CGFloat					cellHeight[150];
	id <DownloaderDelegate> delegate;
    
    // banner
    BannerView              *banner;
    BOOL                    isBannerAnimating;
    BOOL                    loadFirstBanner;
    
    // info view
    UIView                  *infoView;
    BOOL                    isInfoVisible;

}

@property (nonatomic, assign) id <DownloaderDelegate> delegate;
@property (nonatomic, retain) NSDictionary	*infoDict;
@property  BOOL  isBannerAnimating;

// for flip animation
-(void)nextTransition;

// view to hold chat and reply button
- (void) loadView1;

// view to hold the textview
- (void) loadView2;

// to load the info page
- (void) loadInfoView;

// to show answers
- (void) getAnswers;

// move chats up
-(void) tableViewScrollsToBottom;

// to save reply with server qatable's rowid
- (NSString*) getServerTime;
- (void) saveAnswer:(NSString*) rowid dateTime:(NSString*)dateTime;
//- (void) saveAnswer:(NSString*) rowid;

// send message to server
- (void) sendMessage;

- (void) deleteAttachment;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;


@end
