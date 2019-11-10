//
//  ViewController.m
//  FastWord
//
//  Created by gwh on 2019/11/4.
//  Copyright 2019 gwh. All rights reserved.
//

#import "HomeViewController.h"
#import "InputViewController.h"
#import "AboutViewController.h"
#import "ManageViewController.h"
#import "SettingViewController.h"
#import "MoreLib.h"

@interface HomeViewController () <CC_LabelGroupDelegate> {
    CC_ScrollView *noteScrollView;
    CC_LabelGroup *noteGroup;
    CC_LabelGroup *menuGroup;
    
    NSArray *noteList;
    NSArray *noteColorList;
    
    NSString *TEXT_NEW;
    NSString *TEXT_SETTING;
    NSString *TEXT_MANAGE;
    NSString *TEXT_RECOMMAND;
    NSString *TEXT_ABOUT;
    
    BOOL hasLoad;
}

@end

@implementation HomeViewController

- (void)cc_dismisViewController {
    
    [self update];
}

- (void)cc_viewWillLoad {
    
    self.cc_title = Language.fastNoteText;

    noteScrollView = ccs.ScrollView
    .cc_frame(0, 0, WIDTH(), self.cc_displayView.height - RH(100))
    .cc_addToView(self);
    
    noteGroup = ccs.LabelGroup;
    noteGroup.delegate = self;
    [noteGroup updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(5) sideX:RH(5) sideY:RH(5) itemHeight:RH(35) margin:RH(10)];
    noteGroup.top = 0;
    [noteScrollView cc_addSubview:noteGroup];
    
    CC_View *menuView = ccs.View;
    menuView.cc_frame(0, self.cc_displayView.height - RH(100), WIDTH(), RH(100))
    .cc_addToView(self);

    menuGroup = ccs.LabelGroup;
    menuGroup.delegate = self;
    [menuGroup updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(5) sideX:RH(5) sideY:RH(5) itemHeight:RH(40) margin:RH(50)];
    menuGroup.top = 0;
    [menuView cc_addSubview:menuGroup];
}

- (void)cc_viewDidLoad {
    
    TEXT_NEW = [Language newText];
    TEXT_SETTING = [Language settingText];
    TEXT_MANAGE = [Language manageText];
    TEXT_RECOMMAND = [Language recommandText];
    TEXT_ABOUT = [Language aboutText];
    
    [menuGroup updateLabels:@[TEXT_NEW, TEXT_MANAGE, TEXT_SETTING, TEXT_RECOMMAND, TEXT_ABOUT] selected:nil];
    
    [self presentNew];
    
}

- (void)cc_viewWillAppear {
    
    if (hasLoad == NO) {
        hasLoad = YES;
    } else {
        [self update];
    }
}

- (void)update {
    [ccs gotoThread:^{

        self->noteList = [NoteStore getList];
        NSArray *colors = [ShareData noteColors];
        NSMutableArray *summaryList = ccs.mutArray;
        NSMutableArray *colorList = ccs.mutArray;
        int count = (int)self->noteList.count;
        for (int i = 0; i < count; i++) {
            NoteModel *model = self->noteList[i];
            NSString *summary = model.summary;
            CCLOG(@"%d", (int)SettingManage.shared.maxTextCount);
            if (summary.length > SettingManage.shared.maxTextCount) {
                summary = [summary substringToIndex:SettingManage.shared.maxTextCount];
            }
            [summaryList addObject:summary];
            [colorList addObject:colors[model.colorIndex]];
        }
        self->noteColorList = colorList;
        
        [ccs gotoMain:^{
            
            float plusHeight = SettingManage.shared.fontSizeIndex * RH(5);
            float plusMargin = SettingManage.shared.fontSizeIndex * RH(7);
            
            [self->noteGroup updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(5) sideX:RH(5) sideY:RH(5) itemHeight:RH(35) + plusHeight margin:RH(10) + plusMargin];
            [self->noteGroup updateLabels:summaryList selected:nil];
        }];
    }];
}

- (void)labelGroup:(CC_LabelGroup *)group button:(UIButton *)button tappedAtIndex:(NSUInteger)index {
    
    if (group == noteGroup) {
        
        InputViewController *vc = [ccs init:InputViewController.class];
        vc.summaryModel = noteList[index];
        [ccs presentViewController:vc withNavigationControllerStyle:UIModalPresentationFullScreen];
    
    } else if (group == menuGroup) {

        NSString *name = button.titleLabel.text;
        if ([name isEqualToString:TEXT_NEW]) {
            [self presentNew];
        } else if ([name isEqualToString:TEXT_ABOUT]) {
            AboutViewController *vc = [ccs init:AboutViewController.class];
            [ccs pushViewController:vc];
        }  else if ([name isEqualToString:TEXT_MANAGE]) {
            ManageViewController *vc = [ccs init:ManageViewController.class];
            [ccs pushViewController:vc];
        }  else if ([name isEqualToString:TEXT_SETTING]) {
            SettingViewController *vc = [ccs init:SettingViewController.class];
            [ccs pushViewController:vc];
        }  else if ([name isEqualToString:TEXT_RECOMMAND]) {
            [MoreLib addMoreLibAt:self.view];
        }
    }
    
}

- (void)presentNew {
    InputViewController *vc = [ccs init:InputViewController.class];
    [ccs presentViewController:vc withNavigationControllerStyle:UIModalPresentationFullScreen];
}

- (void)labelGroup:(CC_LabelGroup *)group initWithButton:(UIButton *)button {
    if (group == noteGroup) {

        button.titleLabel.font = RF(SettingManage.shared.fontSize);
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];

        button.cc_cornerRadius(RH(5));
        if (!SettingManage.shared.hiddenBorder) {
            button.cc_borderWidth(1);
            button.cc_borderColor(UIColor.blackColor);
        }
        
        [button setBackgroundColor:noteColorList[button.tag - 100]];
        
    } else if (group == menuGroup) {

        button.backgroundColor = RGBA(0, 0, 0, 0.1);
        button.titleLabel.font = RF(16);
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        button.cc_cornerRadius(RH(5));
        button.cc_borderWidth(1);
        button.cc_borderColor(UIColor.blackColor);
    }
}

- (void)labelGroupInitFinish:(CC_LabelGroup *)group {
    
    if (group.height > noteScrollView.height) {
        noteScrollView.contentSize = CGSizeMake(WIDTH(), group.height);
    } else {
        noteScrollView.contentSize = CGSizeMake(WIDTH(), noteScrollView.height);
    }
}


@end
