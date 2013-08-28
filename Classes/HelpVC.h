//
//  HelpVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpVC : UIViewController <UIWebViewDelegate>
{
	UIWebView *wv;
	NSURL		*url;
}

@property (nonatomic, retain) NSURL *url;

@end
