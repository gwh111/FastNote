//
//  InputViewController.m
//  FastWord
//
//  Created by gwh on 2019/11/4.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "InputViewController.h"
#import "HomeViewController.h"

@interface InputViewController () <UITextViewDelegate, CC_LabelGroupDelegate> {
    
    CC_TextView *textView;
    
    CC_View *menuView;
    CC_LabelGroup *menuGroup;
    
    NSUInteger colorIndex;
    BOOL isUpdate;
    
    NSArray *noteColors;
    
    CC_Button *sampleButton;
}

@property (nonatomic, retain) NoteModel *contentModel;

@end

@implementation InputViewController

- (void)cc_viewWillLoad {
    
    self.cc_title = @"📝...";
    
    menuView = ccs.View
    .cc_size(WIDTH(), RH(100))
    .cc_addToView(self);
    
    menuGroup = ccs.LabelGroup;
    menuGroup.delegate = self;
    [menuGroup updateType:CCLabelAlignmentTypeLeft width:WIDTH() stepWidth:RH(3) sideX:RH(5) sideY:RH(5) itemHeight:RH(35) margin:RH(35)];
    menuGroup.top = 0;
    [menuView cc_addSubview:menuGroup];
    
    sampleButton = [self menuButton];
    sampleButton
    .cc_frame(RH(5), RH(5), RH(80), RH(35))
    .cc_setTitleForState(Language.noteBackColorText, UIControlStateNormal);
    sampleButton.right = WIDTH() - RH(10);
    
    noteColors = ShareData.noteColors;
    if (_summaryModel) {
        
        _contentModel = [NoteStore getContentModelWithSummaryModel:_summaryModel];
        isUpdate = YES;
        
        NSMutableArray *textList = ccs.mutArray;
        NSMutableArray *selectList = ccs.mutArray;
        for (int i = 0; i < noteColors.count; i++) {
            if (i == _summaryModel.colorIndex) {
                [selectList addObject:@"1"];
            } else {
                [selectList addObject:@"0"];
            }
            [textList addObject:@""];
        }
        [menuGroup updateLabels:textList selected:selectList];
        
        [sampleButton setBackgroundColor:noteColors[_summaryModel.colorIndex]];
        
    } else {
        
        _summaryModel = [ccs init:NoteModel.class];
        _contentModel = [ccs init:NoteModel.class];
        isUpdate = NO;
        
        NSString *createTime = ccs.nowTimeTimestamp;
        _summaryModel.createTime = createTime;
        _contentModel.createTime = createTime;

        NSMutableArray *textList = ccs.mutArray;
        NSMutableArray *selectList = ccs.mutArray;
        for (int i = 0; i < noteColors.count; i++) {
            if (i == 0) {
                [selectList addObject:@"1"];
            } else {
                [selectList addObject:@"0"];
            }
            [textList addObject:@""];
        }
        [menuGroup updateLabels:textList selected:selectList];
        
    }
    
    
    NSString *dateStr = [ccs string:@"%@", NSDate.date];
    dateStr = [dateStr substringToIndex:19];
    
    // draw
    ccs.Label
    .cc_frame(RH(10), 0, RH(200), RH(30))
    .cc_textColor(UIColor.darkGrayColor)
    .cc_font(RF(14))
    .cc_text(dateStr)
    .cc_addToView(self);
    
    textView = ccs.TextView
    .cc_frame(RH(5), RH(30), WIDTH() - RH(10), self.cc_displayView.height - textView.top - RH(50))
    .cc_textColor(UIColor.blackColor)
//    .cc_backgroundColor(UIColor.yellowColor)
    .cc_font(RF(SettingManage.shared.fontSize))
    .cc_delegate(self)
    .cc_addToView(self);
    
    if (_contentModel.content.length > 0) {
        textView.text = _contentModel.content;
    }
    
    if (!isUpdate) {
        [textView becomeFirstResponder];
    } else {
        [self textViewDidEndEditing:textView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    
//    CC_Button *deleteButton = [self menuButton];
//    deleteButton
//    .cc_frame(RH(5), RH(50), RH(60), RH(35))
//    .cc_setTitleForState(@"删除", UIControlStateNormal);

    CC_Button *cancelButton = [self menuButton];
    cancelButton
    .cc_frame(RH(5), RH(50), RH(60), RH(35))
    .cc_setTitleForState(Language.cancelText, UIControlStateNormal);
    [cancelButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        [ccs dismissViewController];
    }];
    
    CC_Button *reviewButton = [self menuButton];
    reviewButton
    .cc_frame(RH(70), RH(50), RH(60), RH(35))
    .cc_setTitleForState(Language.reviewText, UIControlStateNormal);
    [reviewButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        [self->textView resignFirstResponder];
    }];
    
    CC_Button *finishButton = [self menuButton];
    finishButton
    .cc_frame(RH(70), RH(50), RH(60), RH(35))
    .cc_setTitleForState(Language.finishText, UIControlStateNormal);
    [finishButton cc_addTappedOnceDelay:.1 withBlock:^(CC_Button *btn) {
        [self complete];
    }];
    
    finishButton.right = WIDTH() - RH(5);
    reviewButton.right = finishButton.left - RH(5);
    
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
    .cc_addToView(menuView);
}

- (void)labelGroup:(CC_LabelGroup *)group button:(UIButton *)button tappedAtIndex:(NSUInteger)index {
    
    if (!button.titleLabel.text) {
        
        colorIndex = index;

        for (CC_Button *tempButton in group.subviews) {
            if (!tempButton.titleLabel.text) {
            
                tempButton.cc_borderWidth(0);
            }
        }
        
        button.cc_borderWidth(1);
        button.cc_borderColor(UIColor.blackColor);
        
        [sampleButton setBackgroundColor:noteColors[index]];
    } else {
        
        
        
    }
    
}

- (void)complete {
    
    NSString *content = textView.text;
    if (content.length < 1) {
        [ccs showNotice:Language.youWriteNotingText atView:self.view];
        return;
    }
    
    [textView resignFirstResponder];

    _contentModel.content = content;
    if (content.length > SettingManage.shared.MAX_TEXT_COUNT) {
        content = [content substringToIndex:SettingManage.shared.MAX_TEXT_COUNT];
    }
    _summaryModel.summary = content;
    _contentModel.summary = content;
    
    _summaryModel.updateTime = ccs.nowTimeTimestamp;
    _contentModel.updateTime = ccs.nowTimeTimestamp;
    
    _summaryModel.colorIndex = colorIndex;
    _contentModel.colorIndex = colorIndex;
    
    if (isUpdate) {
        
        [NoteStore updateSummaryModel:_summaryModel];
        [NoteStore updateContentModel:_contentModel];
    } else {

        [NoteStore addSummaryModel:_summaryModel];
        [NoteStore addContentModel:_contentModel];
    }
    
    [ccs dismissViewController];
}

- (void)labelGroup:(CC_LabelGroup *)group initWithButton:(UIButton *)button {
    button.titleLabel.font = RF(16);
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    button.cc_cornerRadius(RH(5));
    
    if (!button.titleLabel.text) {
        
        button.backgroundColor = noteColors[button.tag - 100];
        
        if (button.selected) {
            button.cc_borderWidth(1);
            button.cc_borderColor(UIColor.blackColor);
        }
        
    } else {

        button.cc_borderWidth(1);
        button.cc_borderColor(UIColor.blackColor);
    }
}

- (void)labelGroupInitFinish:(CC_LabelGroup *)group {
    
}

- (void)keyboardAction:(NSNotification *)sender {
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    float height = [value CGRectValue].size.height;
    CCLOG(@"%f", height);
    
    textView.height = self.cc_displayView.height - height - textView.top - RH(50);
    
    if (ccs.safeBottom <= 0) {
        textView.height = textView.height - RH(50);
    }
    
    menuView.top = textView.bottom;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    textView.height = self.cc_displayView.height - textView.top - RH(50) - ccs.safeBottom;
    
    if (ccs.safeBottom <= 0) {
        textView.height = textView.height - RH(50);
    }
    
    menuView.top = textView.bottom;
}

@end
