//
//  AboutViewController.m
//  FastWord
//
//  Created by gwh on 2019/11/6.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "AboutViewController.h"
#import <StoreKit/StoreKit.h>

@interface AboutViewController () <UITextViewDelegate>

@end

@implementation AboutViewController

- (void)cc_viewWillLoad {
   
    self.cc_title = @"关于";
}

- (void)cc_viewDidLoad {
	 // Do any additional setup after loading the view.
    
    NSMutableAttributedString *att = ccs.mutableAttributedString;
    [att cc_appendAttStr:Language.aboutText1 color:UIColor.darkGrayColor  font:RF(16)];
    if (!Language.isChinese) {
        NSString *link = Language.aboutLink;
        [att cc_appendAttStr:link color:UIColor.darkGrayColor font:RF(16)];
        [att addAttribute:NSLinkAttributeName value:link range:NSMakeRange(att.length - link.length, link.length)];
        [att cc_appendAttStr:Language.aboutText2 color:UIColor.darkGrayColor  font:RF(16)];
    }
    
    CC_TextView *textView = ccs.TextView;
    textView
    .cc_frame(RH(5), 0, WIDTH() - RH(10), self.cc_displayView.height - RH(40))
    .cc_textColor(UIColor.darkGrayColor)
    .cc_font(RF(16))
    .cc_editable(NO)
    .cc_delegate(self)
    .cc_addToView(self);
    textView.attributedText = att;
    
    CC_Button *rateButton = ccs.Button;
    rateButton
    .cc_frame(WIDTH()/2 - RH(40), self.cc_displayView.height - RH(60), RH(80), RH(40))
    .cc_setTitleColorForState(UIColor.blackColor, UIControlStateNormal)
    .cc_font(RF(16))
    .cc_setTitleForState(Language.rateText, UIControlStateNormal)
    .cc_cornerRadius(4)
    .cc_borderColor(UIColor.blackColor)
    .cc_borderWidth(1)
    .cc_addToView(self);
    [rateButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        [self rate];
    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return YES;
}

- (void)rate {
    int rateType = 0;
    if (@available(iOS 10.3, *)) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {// iOS 10.3 以上支持
            
            int rand = arc4random()%10;
            if (rand > 5) {
                
                rateType = 1;
                [[UIApplication sharedApplication].keyWindow endEditing:YES];
                [SKStoreReviewController requestReview];
            }else{
                
            }
        }
    }
    
    if (rateType == 0) {
        [ccs showAltOn:self title:Language.thanksText msg:Language.helpRateText bts:@[Language.laterText, Language.gotoRateText] block:^(int index, NSString *name) {
            if (index == 1) {

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1487045573"]];
            }
        }];
    } else if (rateType == 1) {
        if (@available(iOS 10.3, *)) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }
    }
}

@end
