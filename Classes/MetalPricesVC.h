//
//  MetalPricesVC.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 3/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MetalPricesVC : UIViewController <UIWebViewDelegate> {
	int				index;
	UIWebView		*myWebView;
	BOOL			isGoBack;
}
@property int index;


- (void)goBackward ;
- (void)goForward ;
- (void) doReferesh ;
- (void) doStop;
- (void) prepareToolBar;
@end
