//
//  MoreLib.m
//  tower
//
//  Created by gwh on 2019/1/23.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "More.h"

@implementation More

- (void)dismiss {
    [UIView animateWithDuration:.5f animations:^{
        self.displayView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.displayView removeFromSuperview];
    }];
}

- (void)cc_setup {
    
    [self initUI];
}

- (void)initUI {
    
    float h = RH(550);
    
    _displayView = ccs.View;
    _displayView.backgroundColor = RGBA(0, 0, 0, .5);
    _displayView.frame = CGRectMake(0, 0, WIDTH(), HEIGHT());
    _displayView.alpha = 0;
    [UIView animateWithDuration:.5f animations:^{
        self.displayView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    _popV = ccs.View;
    _popV.frame = CGRectMake(0, HEIGHT() - h, WIDTH(), h);
    [_displayView addSubview:_popV];
    _popV.backgroundColor = UIColor.blackColor;
    
    CC_ImageView *up = ccs.ImageView;
    up.frame = CGRectMake(0, 0, WIDTH(), RH(50));
    up.image = [UIImage imageNamed:@"ui/fadeToUp"];
    up.bottom = _popV.top;
    [_displayView addSubview:up];
    
    CC_ImageView *bottom = ccs.ImageView;
    bottom.frame = CGRectMake(0, 0, WIDTH(), RH(50));
    bottom.image = [UIImage imageNamed:@"ui/fadeToBottom"];
    bottom.top = _popV.bottom;
    [_displayView addSubview:bottom];
    
    CC_Button *close = ccs.Button;
    close.frame = CGRectMake(0, 0, WIDTH(), _popV.top);
    [_displayView addSubview:close];
    [close cc_addTappedOnceDelay:.1 withBlock:^(UIButton *button) {
        [self dismiss];
    }];
    
    _imageV = ccs.ImageView;
    _imageV.frame = CGRectMake(0, 0, WIDTH(), RH(250));
    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    [_popV addSubview:_imageV];
    _imageV.image = [UIImage imageNamed:@"ui/test2.jpg"];
    
    _jumpBtn = ccs.Button;
    _jumpBtn.frame = CGRectMake(WIDTH()/2 - RH(40), RH(200), RH(80), RH(40));
    _jumpBtn.backgroundColor = RGBA(0, 0, 0, .5);
    [_jumpBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [_jumpBtn setTitle:@"去看看" forState:UIControlStateNormal];
    _jumpBtn.cc_cornerRadius(4);
    [_popV addSubview:_jumpBtn];
    
    _group = ccs.LabelGroup;
    _group.frame = CGRectMake(0, RH(250), 0, 0);
    [_group updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(8) sideX:RH(8) sideY:RH(8) itemHeight:RH(40) margin:RH(30)];
    [_popV addSubview:_group];
    [_group updateLabels:@[] selected:nil];
    
    _desT = ccs.TextView;
    _desT.frame = CGRectMake(RH(10), RH(310), WIDTH() - RH(20), RH(150));
    _desT.backgroundColor = [UIColor clearColor];
    _desT.textColor = COLOR_WHITE;
    _desT.editable = NO;
    _desT.selectable = NO;
    _desT.font = RF(16);
    [_popV addSubview:_desT];
    _desT.text = @"请打开网络后再试一次";
    
    NSDictionary *moreLib = [ccs sandboxPlistWithPath:@"moreLib"];
    if (moreLib) {
        self.list = moreLib[@"list"];
        [self updateDes];
    }
    
    [ccs.httpTask get:@"http://gwhgame.oss-cn-hangzhou.aliyuncs.com/moreLib.json" params:nil model:nil finishBlock:^(NSString *error, HttpModel *result) {
        
        if (error) {
            return ;
        }
        
        NSMutableArray *mutArr = ccs.mutArray;
        for (int i = 0; i < [result.resultDic[@"list"] count]; i++) {
            NSDictionary *dic = result.resultDic[@"list"][i];
            if (![dic[@"bid"]isEqualToString:[ccs appBid]]) {
                [mutArr addObject:dic];
            }
        }
        self.list = mutArr;
        [self updateDes];
        [ccs saveToSandboxWithData:result.resultDic toPath:@"moreLib" type:@"plist"];
    }];
}

- (void)updateDes {
    if (_list.count <= _currentIndex) {
        return;
    }
    NSDictionary *dic = _list[_currentIndex];
    [_imageV cc_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
    if (dic[@"imgType"]) {
        _imageV.contentMode = [dic[@"imgType"] intValue];
    }
    
    _desT.text = dic[@"des"];
    
    [_group addItemInitBlock:^(CC_Button *btn, CC_LabelGroup *group) {
        btn.backgroundColor = RGBA(255, 255, 255, 0.2);
        btn.titleLabel.font = RF(16);
        btn.cc_cornerRadius(RH(5));
        btn.cc_setTitleColorForState(COLOR_LIGHT_ORANGE,UIControlStateSelected);
    }];
    WS(weakSelf)
    [_group addGroupUpdateBlock:^(CC_LabelGroup *group) {
        weakSelf.desT.top = group.bottom;
    }];
    [_group addSelectBlock:^(CC_Button *btn, NSUInteger index, CC_LabelGroup *group) {
        weakSelf.currentIndex = index;
        [weakSelf updateDes];
    }];
    NSMutableArray *names = ccs.mutArray;
    for (int i = 0; i < _list.count; i++) {
        [names addObject:_list[i][@"name"]];
    }
    [_group updateLabels:names selectedIndex:_currentIndex];
    
    NSString *urlStr = dic[@"download"];
    [_jumpBtn cc_addTappedOnceDelay:.1 withBlock:^(UIButton *button) {
        
        if (@available(iOS 10.0, *)) {
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:urlStr] options:ccs.mutDictionary completionHandler:^(BOOL success) {
                
            }];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
        
    }];
}

@end
