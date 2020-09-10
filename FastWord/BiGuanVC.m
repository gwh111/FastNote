//
//  ViewController.m
//  BiGuan
//
//  Created by gwh on 2020/2/6.
//  Copyright 2020 gwh. All rights reserved.
//

#import "BiGuanVC.h"
#import "Data.h"
#import "CC_ShareUI+CC.h"

@interface BiGuanVC ()

@property (nonatomic, retain) NSMutableArray *selectsArr;

@end

@implementation BiGuanVC

- (void)cc_viewWillLoad {
    
    self.cc_title = @"我的闭关记录📝";
    
    NSArray *list = Data.shared.stateList;
    
    CC_ShareUI.shared.itemTitleLabel
    .cc_text(@"这是我闭关的第 n 天")
    .cc_addToView(self);
    
    CC_ShareUI.shared.itemDesLabel
    .cc_top(RH(50))
    .cc_left(RH(10))
    .cc_textAlignment(NSTextAlignmentLeft)
    .cc_text(@"我的状态")
    .cc_addToView(self);
    
    _selectsArr = ccs.mutArray;

    for (int i = 0; i < list.count; i++) {

        CC_LabelGroup *group1 = ccs.LabelGroup;
        group1.tag = 1000 + i;
        [group1 updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(10) sideX:RH(10) sideY:RH(10) itemHeight:RH(35) margin:RH(10)];
        group1.top = i * RH(50) + RH(90);
        group1.delegate = self;
        NSMutableArray *mutList = ccs.mutArray;
        [mutList addObject:list[i][@"name"]];
        [mutList addObjectsFromArray:list[i][@"items"]];
        NSMutableArray *selects = ccs.mutArray;
        for (int i = 0; i < mutList.count; i++) {
            if (i == mutList.count - 1) {
                [selects addObject:@"1"];
            } else {
                [selects addObject:@"0"];
            }
        }
        [group1 updateLabels:mutList selected:selects];
        [self.cc_displayView addSubview:group1];
    }
    
    NSArray *list2 = Data.shared.productsList;
    
    ccs.ui.itemDesLabel
    .cc_top(RH(450))
    .cc_left(RH(10))
    .cc_textAlignment(NSTextAlignmentLeft)
    .cc_text(@"物资储备")
    .cc_addToView(self);

    for (int i = 0; i < list2.count; i++) {

        CC_LabelGroup *group1 = ccs.LabelGroup;
        group1.tag = 2000 + i;
        [group1 updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(10) sideX:RH(10) sideY:RH(10) itemHeight:RH(35) margin:RH(10)];
        group1.top = i * RH(50) + RH(490);
        group1.delegate = self;
        NSMutableArray *mutList2 = ccs.mutArray;
        [mutList2 addObject:list2[i][@"name"]];
        [mutList2 addObjectsFromArray:list2[i][@"items"]];
        NSMutableArray *selects = ccs.mutArray;
        for (int i = 0; i < mutList2.count; i++) {
            if (i == mutList2.count - 2) {
                [selects addObject:@"1"];
            } else {
                [selects addObject:@"0"];
            }
        }
        [group1 updateLabels:mutList2 selected:selects];
        [self.cc_displayView addSubview:group1];
    }
    
    ccs.ui.itemDesLabel
    .cc_top(RH(1150))
    .cc_text(@"")
    .cc_addToView(self);
    
    CC_Button *bt =
    ccs.ui.wordButton
    .cc_bottom(self.view.height - ccs.safeBottom)
    .cc_setTitleColorForState(UIColor.whiteColor,UIControlStateNormal)
    .cc_setBackgroundColorForState(COLOR_LIGHT_BLUE,UIControlStateNormal)
    .cc_setTitleForState(@"完成",UIControlStateNormal)
    .cc_addToView(self.view);
    [bt cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        
//        NSDate *date = NSDate.cc_localDate;
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        NSDate *localDate = [date dateByAddingTimeInterval:interval];
        
        NSString *dateStr = date.cc_convertToString;
        if (!dateStr) {
            date = NSDate.date;
            dateStr = date.cc_convertToString;
        }
        dateStr = [dateStr substringToIndex:10];
        NSLog(@"%@",dateStr);
        
        NSString *content = @"这是我闭关的第 n 天";
        content = [content stringByAppendingString:@"\n我的状态\n"];
        
        for (int i = 0; i < list.count; i++) {
            NSString *name = list[i][@"name"];
            NSArray *items = list[i][@"items"];
            CC_LabelGroup *group = [self.cc_displayView viewWithTag:1000 + i];
            for (int m = 0; m < items.count; m++) {
                CC_Button *button = [group viewWithTag:100 + m + 1];
                if (button.selected) {
                    NSString *item = items[m];
                    NSLog(@"%@",item);
                    content = [content stringByAppendingFormat:@"%@：%@\n",name,item];
                }
            }
        }
        
        content = [content stringByAppendingString:@"物资储备\n"];
        
        for (int i = 0; i < list2.count; i++) {
            NSString *name = list2[i][@"name"];
            NSArray *items = list2[i][@"items"];
            CC_LabelGroup *group = [self.cc_displayView viewWithTag:2000 + i];
            for (int m = 0; m < items.count; m++) {
                CC_Button *button = [group viewWithTag:100 + m + 1];
                if (button.selected) {
                    NSString *item = items[m];
                    NSLog(@"%@",item);
                    content = [content stringByAppendingFormat:@"%@：%@\n",name,item];
                }
            }
        }
        
        NSLog(@"content%@",content);
        
        [ccs popViewControllerFrom:self userInfo:content];
    }];
    
    [self cc_adaptUI];
}

- (void)labelGroup:(CC_LabelGroup *)group initWithButton:(UIButton *)button {
    button
    .cc_setTitleColorForState(UIColor.blackColor, UIControlStateNormal)
    .cc_setTitleColorForState(UIColor.whiteColor, UIControlStateSelected)
    .cc_setBackgroundColorForState(COLOR_LIGHT_BLUE,UIControlStateSelected);
    
    if (button.tag != 100) {
        button
        .cc_cornerRadius(4)
        .cc_borderColor(UIColor.grayColor)
        .cc_borderWidth(1);
    }
}
- (void)labelGroup:(CC_LabelGroup *)group button:(UIButton *)button tappedAtIndex:(NSUInteger)index {
    
    if (index == 0) {
        return;
    }
    [group clearSelect];
    [group updateSelect:YES atIndex:index];
}
- (void)labelGroupInitFinish:(CC_LabelGroup *)group {
    
}

@end
