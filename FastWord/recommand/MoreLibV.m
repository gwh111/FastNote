//
//  MoreLibV.m
//  tower
//
//  Created by gwh on 2019/1/23.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "MoreLibV.h"

@interface MoreLibV()<CC_LabelGroupDelegate>{
    UIView *popV;
    CC_TextView *desT;
    CC_LabelGroup *group;
    UIImageView *imageV;
    
    NSArray *list;
    NSUInteger currentIndex;
    
    CC_Button *tapBt;
}

@end

@implementation MoreLibV

- (void)dismiss {
    [UIView animateWithDuration:.5f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, .5);
        self.frame = CGRectMake(0, 0, WIDTH(), HEIGHT());
        self.alpha = 0;
        [UIView animateWithDuration:.5f animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    return self;
}

- (void)initUI {
    
    float h = RH(450);
    
    popV = ccs.View;
    popV.frame = CGRectMake(0, HEIGHT() - h - ccs.safeBottom, WIDTH(), h);
    [self addSubview:popV];
    popV.backgroundColor = UIColor.blackColor;
    
    CC_ImageView *up = ccs.ImageView;
    up.frame = CGRectMake(0, 0, WIDTH(), RH(50));
    up.image = [UIImage imageNamed:@"fadeToUp"];
    up.bottom = popV.top;
    [self addSubview:up];
    
    CC_ImageView *bottom = ccs.ImageView;
    bottom.frame = CGRectMake(0, 0, WIDTH(), RH(50));
    bottom.image = [UIImage imageNamed:@"fadeToBottom"];
    bottom.top = popV.bottom;
    [self addSubview:bottom];
    
    CC_Button *close = ccs.Button;
    close.frame = CGRectMake(0, 0, WIDTH(), popV.top);
    [self addSubview:close];
    [close cc_addTappedOnceDelay:.1 withBlock:^(UIButton *button) {
        [self dismiss];
    }];
    
    imageV = ccs.ImageView;
    imageV.frame = CGRectMake(0, 0, WIDTH(), RH(250));
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [popV addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"ui/test2.jpg"];
    
    tapBt = ccs.Button;
    tapBt.frame = CGRectMake(WIDTH()/2 - RH(40), RH(200), RH(80), RH(40));
    tapBt.backgroundColor = RGBA(0, 0, 0, .6);
    [tapBt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [tapBt setTitle:@"AppStore" forState:UIControlStateNormal];
    tapBt.cc_cornerRadius(4);
    [popV addSubview:tapBt];
    
    group = ccs.LabelGroup;
    group.delegate = self;
    [group updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(10) sideX:RH(10) sideY:RH(10) itemHeight:RH(35) margin:RH(20)];
    [popV addSubview:group];
    
    desT = ccs.TextView;
    desT.frame = CGRectMake(RH(10), RH(310), WIDTH() - RH(20), RH(120));
    desT.backgroundColor = [UIColor clearColor];
    desT.textColor = UIColor.whiteColor;
    desT.editable = NO;
    desT.selectable = NO;
    desT.font = RF(16);
    [popV addSubview:desT];
    desT.text = @"刷新重新打开";
    
    NSDictionary *moreLib = [ccs sandboxPlistWithPath:@"moreLib"];
    if (moreLib) {
        self->list = moreLib[@"list"];
        [self updateDes];
    }
    
    [ccs.httpTask get:@"http://gwhgame.oss-cn-hangzhou.aliyuncs.com/moreLib.json" params:nil model:nil finishBlock:^(NSString *error, HttpModel *result) {
        
        if (error) {
            return ;
        }
        
        NSMutableArray *mutArr = ccs.mutArray;
        for (int i = 0; i < [result.resultDic[@"list"] count]; i++) {
            NSDictionary *dic = result.resultDic[@"list"][i];
            if (![dic[@"bid"]isEqualToString:CC_BundleStore.cc_appBid]) {
                [mutArr addObject:dic];
            }
        }
        self->list = mutArr;
        [self updateDes];
        [ccs saveToSandboxWithData:result.resultDic toPath:@"moreLib" type:@"plist"];
    }];
}

- (void)updateDes {
    if (list.count <= currentIndex) {
        return;
    }
    NSDictionary *dic = list[currentIndex];
    [imageV cc_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
    if (dic[@"imgType"]) {
        imageV.contentMode = [dic[@"imgType"] intValue];
    }
    
    desT.text = dic[@"des"];
    
    NSMutableArray *names = ccs.mutArray;
    for (int i = 0; i < list.count; i++) {
        [names addObject:list[i][@"name"]];
    }
    [group updateLabels:names selected:nil];
    
    NSString *urlStr = dic[@"download"];
    [tapBt cc_addTappedOnceDelay:.1 withBlock:^(UIButton *button) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }];
}

- (void)labelGroup:(CC_LabelGroup *)group button:(UIButton *)button tappedAtIndex:(NSUInteger)index {
    
    NSString *name = button.titleLabel.text;
    CCLOG(@"%@",name);
    currentIndex = index;
    [self updateDes];
    
}

- (void)labelGroup:(CC_LabelGroup *)group initWithButton:(UIButton *)button {
    button.titleLabel.font = RF(16);
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.cc_cornerRadius(RH(5));
    button.cc_borderWidth(1);
    button.cc_borderColor(UIColor.whiteColor);
    
    [button setBackgroundColor:RGBA(255, 255, 255, 0.1)];
}

- (void)labelGroupInitFinish:(CC_LabelGroup *)group {
    
    group.top = RH(250);
}

@end
