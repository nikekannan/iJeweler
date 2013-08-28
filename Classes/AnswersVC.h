//
//  AnswersVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/29/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@class DetailedAnswersVC;
@class BannerView;

@interface AnswersVC : UIViewController <UITableViewDelegate, UITableViewDataSource, DownloaderDelegate>
{
	UITableView			*myTable;
	NSMutableArray		*answersArray;
	NSDictionary		*infoDict;
	id <DownloaderDelegate> delegate;
	DetailedAnswersVC	*obj_DetailedAnswersVC;
    
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

- (void) loadTable;
- (void) getAnswers;
- (void) refershDetailedAnswersVC;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;

@end
