//
//  RootViewController.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 2/1/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownloaderDelegate
@optional
- (void) refreshQuestionsVC;
- (void) refreshAnswersVC;
- (void) refershDetailedAnswersVC;

@end

@class QuestionsVC;
@class BannerView;
@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
	UITableView		*myTable;
	id <DownloaderDelegate> delegate;
	NSMutableData			*activeDownload;
	NSURLConnection			*urlConnection;
	QuestionsVC				*obj_QuestionsVC;
   
    // banner
    BannerView              *banner;
    BOOL                    isBannerAnimating;
    BOOL                    loadFirstBanner;
    
    // info view
    UIView                  *infoView;
    BOOL                    isInfoVisible;

}

@property (nonatomic, assign) id <DownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property  BOOL  isBannerAnimating;

- (void) loadTable;
- (void) loadAskaCategoryVC;
- (void) loadAskaQuestionVC;
- (void) loadQuestionsVC;
- (void) loadPersonalAssistantVC;
- (void) loadPersonalShoppingAssistantVC;
- (void) downloadQuestions;

// just update the token and latlang
- (void) updateToken;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;

// scroller
- (void) prepareScrollView;
- (void) buttonAction:(id)sender;
@end
