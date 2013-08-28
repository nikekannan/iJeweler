/*
 *  Constants.h
 *  iJeweler
 *
 *  Created by Nikesh Kannan on 1/27/11.
 *  Copyright 2011 no. All rights reserved.
 *
 */

#import "MyJewelerAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "MySQLite.h"
#import "UIImageResize.h"
#import	<QuartzCore/QuartzCore.h>
#import "AskBannerQuestionVC.h"
#import "BannerView.h"
#import "Banner.h"


#define DELAY 3

// banner
#define ANIMATE_BANNER_AFTER_DELAY 5
#define kBannerWidth 320
#define kBannerHeight 60


// default text color
static const CGFloat r = 56.0/255.0;
static const CGFloat g = 84.0/255.0;
static const CGFloat b = 135.0/255.0;

// server URL
#define	URL	@"http://app.goxnetwork.com/myjeweler"
// local office
//#define URL @"http://localhost:8888/php/myjeweler"

#define MYID    [[NSUserDefaults standardUserDefaults] objectForKey:@"myid"];


// 0 - Supplier Version
// 1 - Jeweler version  ( test in device )
// 2 - Consumer version 
#define VERSION 0
// info text
#define JEWELER_INFO_TXT @"By tapping on the banner ad located at the bottom of your screen, you will be taken directly to that particular jeweler’s web site.\n\nBy tapping on the \"Ask a Question\" icon on the right, a dialog box will open in which you can ask a REAL jeweler any gems, jewelry, watch related question. Please be aware, your question will be sent to a REAL jeweler and your question must be gems, jewelry or watch related."

#define SUPPLIER_INFO_TXT @"By tapping on the banner ad located at the bottom of your screen, you will be taken directly to that particular service provider’s web site.\n\nBy tapping on the \"Ask a Question\" icon on the right, a dialog box will open in which you can ask a REAL Jewelry industry service provider any question. Please be aware, your question will be sent to a REAL jeweler/supplier."


// My Code

/*

 Supplier (com.goxnetwork.iJewelersupplier)
 1.0 - basic version
 1.1 - Banner Ad support
 1.2 - Minor bugs in app delegate
 1.3 - Google reverse geocode API change

 Jeweler (com.goxnetwork.iJewelerdis)
 1.2 - registration & PUSH issues
 1.3 - PSA & supplier ask a question featuer
 1.4 - Banner Ad support
 1.5 - Minor bugs in app delegate
 1.6 - Google reverse geocode API change

 Consumer (com.goxnetwork.iJewelerconsumer)
 1.3 - PUSH issues
 1.4 - PSA
 1.5 - Banner Ad support
 1.6 - Minor bugs in app delegate
 1.7 - Google reverse geocode API change

*/