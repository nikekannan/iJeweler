//
//  AttachmentVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 15/02/11.
//  Copyright 2011 Deemag Infotech Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerView;
@interface AttachmentVC : UIViewController <UIWebViewDelegate>
{
	NSString		*qid;
	NSMutableArray	*attachmentArr;
	UIScrollView	*pageScrollView;
	UIActivityIndicatorView *activityIndicator;
    
    // banner
    BannerView              *banner;
    BOOL                    isBannerAnimating;
    BOOL                    loadFirstBanner;
    
    // info view
    UIView                  *infoView;
    BOOL                    isInfoVisible;

}

@property ( nonatomic, retain) NSString	*qid;
@property ( nonatomic, retain) NSMutableArray	*attachmentArr;
@property  BOOL  isBannerAnimating;

- (void) prepareScrollView;

// banner
- (void) animateBanner;
- (void) changeBanner;

//infoview
- (void) prepareInfoView;
- (void) animateInfoView;

@end
