//
//  KouZhaoVC.m
//  FastWord
//
//  Created by gwh on 2020/2/27.
//  Copyright © 2020 gwh. All rights reserved.
//

#import "KouZhaoVC.h"

@interface KouZhaoVC ()

@end

@implementation KouZhaoVC

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)cc_viewWillLoad {
   
    self.cc_title = @"抢口罩";
}

- (void)cc_viewDidLoad {
	 // Do any additional setup after loading the view.
    
    [self.cc_displayView cc_tappedInterval:.1 withBlock:^(id  _Nonnull view) {
        for (int i = 0; i < 3; i++) {
            CC_TextField *t = [self.cc_displayView viewWithTag:i + 100];
            [t resignFirstResponder];
        }
    }];
    
    NSArray *names = @[@"身份证号",@"手机号",@"地址"];
    for (int i = 0; i < names.count; i++) {
        ccs.ui.itemTitleLabel
        .cc_top(RH(10) + RH(100) * i)
        .cc_text(names[i])
        .cc_addToView(self);
        
        CC_TextField *t =
        ccs.TextField
        .cc_tag(i + 100)
        .cc_textAlignment(NSTextAlignmentCenter)
        .cc_placeholder(@"在这里输入")
        .cc_frame(RH(20), RH(60) + RH(100) * i, RH(200), RH(40))
        .cc_borderWidth(1)
        .cc_borderColor(UIColor.grayColor)
        .cc_cornerRadius(4)
        .cc_addToView(self);
        
        NSString *temp = [ccs getDefault:[ccs string:@"save%d",i]];
        t.text = temp;
    }
    
    [ccs.ui.warningButton
     .cc_backgroundColor(COLOR_LIGHT_BLUE)
     .cc_setTitleForState(@"保存",UIControlStateNormal)
     .cc_frame(RH(20), RH(320), RH(80), RH(50))
     .cc_addToView(self) addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        
        for (int i = 0; i < 3; i++) {
            CC_TextField *t = [self.cc_displayView viewWithTag:i + 100];
            
            [ccs saveDefaultKey:[ccs string:@"save%d",i] value:t.text];
        }
        
        [ccs showNotice:@"保存成功"];
    }];
    
    ccs.ui.itemDesLabel
    .cc_textAlignment(NSTextAlignmentLeft)
    .cc_numberOfLines(0)
    .cc_frame(RH(10),RH(380), WIDTH() - RH(20),RH(100))
    .cc_text(@"说明：\n按顺序填完后【保存】，点【开始】后每次从后台回来会自动复制下一行。")
    .cc_addToView(self);
    
    [ccs.ui.warningButton
     .cc_backgroundColor(COLOR_LIGHT_BLUE)
     .cc_setTitleForState(@"开始",UIControlStateNormal)
     .cc_frame(RH(120), RH(320), RH(80), RH(50))
     .cc_addToView(self) addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        
        if ([btn.titleLabel.text isEqualToString:@"停止"]) {
            Data.shared.kouzhaoCountStart = NO;
            btn.cc_setTitleForState(@"开始",UIControlStateNormal);
            return;
        }
        btn.cc_setTitleForState(@"停止",UIControlStateNormal);
        
        Data.shared.kouzhaoCountStart = YES;
        Data.shared.kouzhaoCount = 0;
        
        NSMutableArray *tempArr = ccs.mutArray;
        for (int i = 0; i < 3; i++) {
            CC_TextField *t = [self.cc_displayView viewWithTag:i + 100];
            [tempArr addObject:t.text];
        }
        Data.shared.kouzhaoTexts = tempArr;
        CC_TextField *t = [self.cc_displayView viewWithTag:0 + 100];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = t.text;
        
        [ccs showNotice:[ccs string:@"已复制：%@",t.text]];
    }];
    
}

@end
