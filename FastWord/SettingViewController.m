//
//  SettingViewController.m
//  FastWord
//
//  Created by gwh on 2019/11/7.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)cc_viewWillLoad {
    
    self.cc_title = Language.settingText;
   
    float height = RH(50);
    
    ccs.Label
    .cc_frame(RH(10), RH(10), RH(200), RH(35))
    .cc_font(RF(16))
    .cc_textColor(UIColor.darkGrayColor)
    .cc_text(Language.showMaxTextCountText)
    .cc_addToView(self);
    
    {
        CC_Button *selectButton = [self menuButton];
        selectButton
        .cc_backgroundColor(RGBA(0, 0, 0, 0.2));
        
        CC_Button *smallButton = [self menuButton];
        smallButton
        .cc_frame(RH(70), RH(10), RH(60), RH(35))
        .cc_setTitleForState(Language.littleText, UIControlStateNormal);
        [smallButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
            
            [SettingManage.shared setMaxTextCountIndex:2];
            selectButton.frame = btn.frame;
        }];
        smallButton.right = WIDTH() - RH(10);
        
        CC_Button *middleButton = [self menuButton];
        middleButton
        .cc_frame(RH(70), RH(10), RH(60), RH(35))
        .cc_setTitleForState(Language.middleText, UIControlStateNormal);
        [middleButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
            
            [SettingManage.shared setMaxTextCountIndex:1];
            selectButton.frame = btn.frame;
        }];
        middleButton.right = smallButton.left - RH(10);
        
        CC_Button *bigButton = [self menuButton];
        bigButton
        .cc_frame(RH(70), RH(10), RH(60), RH(35))
        .cc_setTitleForState(Language.lotsText, UIControlStateNormal);
        [bigButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
            
            [SettingManage.shared setMaxTextCountIndex:0];
            selectButton.frame = btn.frame;
        }];
        bigButton.right = middleButton.left - RH(10);
        
        int index = SettingManage.shared.maxTextCountIndex;
        if (index == 0) {
            selectButton.frame = smallButton.frame;
        } else if (index == 1) {
            selectButton.frame = middleButton.frame;
        } else if (index == 2) {
            selectButton.frame = bigButton.frame;
        }
        [self cc_addSubview:selectButton];
    }
    
    ccs.Label
    .cc_frame(RH(10), RH(10) + height, RH(200), RH(35))
    .cc_font(RF(16))
    .cc_textColor(UIColor.darkGrayColor)
    .cc_text(Language.fontsizeText)
    .cc_addToView(self);
    
    {
        CC_Button *selectButton = [self menuButton];
        selectButton
        .cc_backgroundColor(RGBA(0, 0, 0, 0.2));
        
        CC_Button *smallButton = [self menuButton];
        smallButton
        .cc_frame(RH(70), RH(10) + height, RH(60), RH(35))
        .cc_setTitleForState(Language.smallText, UIControlStateNormal);
        [smallButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {

            [SettingManage.shared setFontSizeIndex:2];
            selectButton.frame = btn.frame;
        }];
        smallButton.right = WIDTH() - RH(10);
        
        CC_Button *middleButton = [self menuButton];
        middleButton
        .cc_frame(RH(70), RH(10) + height, RH(60), RH(35))
        .cc_setTitleForState(Language.middleText, UIControlStateNormal);
        [middleButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
            
            [SettingManage.shared setFontSizeIndex:1];
            selectButton.frame = btn.frame;
        }];
        middleButton.right = smallButton.left - RH(10);
        
        CC_Button *bigButton = [self menuButton];
        bigButton
        .cc_frame(RH(70), RH(10) + height, RH(60), RH(35))
        .cc_setTitleForState(Language.bigText, UIControlStateNormal);
        [bigButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
            
            [SettingManage.shared setFontSizeIndex:0];
            selectButton.frame = btn.frame;
        }];
        bigButton.right = middleButton.left - RH(10);
        
        int index = SettingManage.shared.fontSizeIndex;
        if (index == 0) {
            selectButton.frame = smallButton.frame;
        } else if (index == 1) {
            selectButton.frame = middleButton.frame;
        } else if (index == 2) {
            selectButton.frame = bigButton.frame;
        }
        [self cc_addSubview:selectButton];
    }
    
    ccs.Label
    .cc_frame(RH(10), RH(10) + height * 2, RH(200), RH(35))
    .cc_font(RF(16))
    .cc_textColor(UIColor.darkGrayColor)
    .cc_text(Language.deleteAskText)
    .cc_addToView(self);
    
    {
        CC_Button *selectButton = [self menuButton];
        selectButton
        .cc_backgroundColor(RGBA(0, 0, 0, 0.2));
        
        CC_Button *bigButton = [self menuButton];
        bigButton
        .cc_frame(RH(70), RH(10) + height * 2, RH(60), RH(35))
        .cc_setTitleForState(Language.noText, UIControlStateNormal);
        [bigButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
            
            [SettingManage.shared setDeleteAskIndex:0];
            selectButton.frame = btn.frame;
        }];
        bigButton.right = WIDTH() - RH(10);
        
        CC_Button *middleButton = [self menuButton];
        middleButton
        .cc_frame(RH(70), RH(10) + height * 2, RH(60), RH(35))
        .cc_setTitleForState(Language.yesText, UIControlStateNormal);
        [middleButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
            
            [SettingManage.shared setDeleteAskIndex:1];
            selectButton.frame = btn.frame;
        }];
        middleButton.right = bigButton.left - RH(10);
        
        int index = SettingManage.shared.deleteAsk;
        if (index == 0) {
            selectButton.frame = bigButton.frame;
        } else if (index == 1) {
            selectButton.frame = middleButton.frame;
        }
        [self cc_addSubview:selectButton];
    }
    
    ccs.Label
    .cc_frame(RH(10), RH(10) + height * 3, RH(200), RH(35))
    .cc_font(RF(16))
    .cc_textColor(UIColor.darkGrayColor)
    .cc_text(Language.hiddenBorderText)
    .cc_addToView(self);
    
    {
        CC_Button *selectButton = [self menuButton];
        selectButton
        .cc_backgroundColor(RGBA(0, 0, 0, 0.2));
        
        CC_Button *bigButton = [self menuButton];
        bigButton
        .cc_frame(RH(70), RH(10) + height * 3, RH(60), RH(35))
        .cc_setTitleForState(Language.noText, UIControlStateNormal);
        [bigButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
            
            [SettingManage.shared setHiddenBorderIndex:0];
            selectButton.frame = btn.frame;
        }];
        bigButton.right = WIDTH() - RH(10);
        
        CC_Button *middleButton = [self menuButton];
        middleButton
        .cc_frame(RH(70), RH(10) + height * 3, RH(60), RH(35))
        .cc_setTitleForState(Language.yesText, UIControlStateNormal);
        [middleButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
            
            [SettingManage.shared setHiddenBorderIndex:1];
            selectButton.frame = btn.frame;
        }];
        middleButton.right = bigButton.left - RH(10);
        
        int index = SettingManage.shared.hiddenBorder;
        if (index == 0) {
            selectButton.frame = bigButton.frame;
        } else if (index == 1) {
            selectButton.frame = middleButton.frame;
        }
        [self cc_addSubview:selectButton];
    }
    
    CC_Button *saveButton = [self menuButton];
    saveButton
    .cc_frame(WIDTH()/2 - RH(40), self.cc_displayView.height - RH(60), RH(80), RH(40))
    .cc_setTitleForState(Language.saveText, UIControlStateNormal);
    [saveButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        
        [SettingManage.shared save];
        [ccs popViewController];
    }];
}

- (void)cc_viewDidLoad {
	 // Do any additional setup after loading the view.
}

- (CC_Button *)menuButton {
    return ccs.Button
    .cc_setTitleColorForState(UIColor.blackColor, UIControlStateNormal)
    .cc_font(RF(16))
    .cc_cornerRadius(4)
    .cc_borderColor(UIColor.blackColor)
    .cc_borderWidth(1)
    .cc_addToView(self);
}

@end
