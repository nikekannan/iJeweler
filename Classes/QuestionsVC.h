//
//  QuestionsVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@class AnswersVC;
@class BannerView;
@interface QuestionsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, DownloaderDelegate>
{
	UITableView					*myTable;
	UIActivityIndicatorView		*activityIndicator;
	NSMutableArray				*questionsArray;
	BOOL						isDeleteQuestion;
	id <DownloaderDelegate> delegate;
	AnswersVC					*obj_AnswersVC;
    
    // banner
    BannerView              *banner;
    BOOL                    isBannerAnimating;
    BOOL                    loadFirstBanner;
    
    // info view
    UIView                  *infoView;
    BOOL                    isInfoVisible;

}

@property (nonatomic, assign) id <DownloaderDelegate> delegate;
@property  BOOL  isBannerAnimating;

- (void) loadTable;

//testing
- (void) loadQuestions;
- (void) getQuestions;
- (void) reloadTable;
- (void) deleteQuestion:(NSString*)qid;
- (void) refreshAnswersVC;
- (void) refreshDetailedAnswersVC;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;

@end
