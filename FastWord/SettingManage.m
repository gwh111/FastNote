//
//  SettingManage.m
//  FastWord
//
//  Created by gwh on 2019/11/7.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "SettingManage.h"

@interface SettingManage () {
    NSUInteger STATIC_MAX_TEXT_COUNT;
    NSUInteger STATIC_MIDDLE_TEXT_COUNT;
    NSUInteger STATIC_MIN_TEXT_COUNT;
}

@end

@implementation SettingManage

static NSString *MAX_TEXT_COUNT = @"maxTextCount";
static NSString *FONT_SIZE = @"fontSize";
static NSString *DELETE_ASK = @"deleteAsk";
static NSString *HIDDEN_BORDER = @"hiddenBorder";

+ (instancetype)shared {
    return [ccs registerSharedInstance:self block:^{
        if (![ccs defaultValueForKey:MAX_TEXT_COUNT]) {
            [ccs saveDefaultKey:MAX_TEXT_COUNT value:@(15)];
        }
        SettingManage.shared.maxTextCount = [[ccs defaultValueForKey:MAX_TEXT_COUNT]integerValue];
        
        if (![ccs defaultValueForKey:FONT_SIZE]) {
            [ccs saveDefaultKey:FONT_SIZE value:@(16)];
        }
        SettingManage.shared.fontSize = [[ccs defaultValueForKey:FONT_SIZE]integerValue];
        
        if (![ccs defaultValueForKey:DELETE_ASK]) {
            [ccs saveDefaultKey:DELETE_ASK value:@(YES)];
        }
        SettingManage.shared.deleteAsk = [[ccs defaultValueForKey:DELETE_ASK]integerValue];
        
        if (![ccs defaultValueForKey:HIDDEN_BORDER]) {
            [ccs saveDefaultKey:HIDDEN_BORDER value:@(NO)];
        }
        SettingManage.shared.hiddenBorder = [[ccs defaultValueForKey:HIDDEN_BORDER]integerValue];
    }];
}

- (NSUInteger)MAX_TEXT_COUNT {
    STATIC_MAX_TEXT_COUNT = 45;
    if (Language.isChinese) {
        STATIC_MAX_TEXT_COUNT = 20;
    }
    return STATIC_MAX_TEXT_COUNT;
}

- (NSUInteger)MIDDLE_TEXT_COUNT {
    STATIC_MIDDLE_TEXT_COUNT = 30;
    if (Language.isChinese) {
        STATIC_MIDDLE_TEXT_COUNT = 12;
    }
    return STATIC_MIDDLE_TEXT_COUNT;
}

- (NSUInteger)MIN_TEXT_COUNT {
    STATIC_MIN_TEXT_COUNT = 15;
    if (Language.isChinese) {
        STATIC_MIN_TEXT_COUNT = 7;
    }
    return STATIC_MIN_TEXT_COUNT;
}

- (void)save {

    [ccs saveDefaultKey:MAX_TEXT_COUNT value:@(_maxTextCount)];
    [ccs saveDefaultKey:FONT_SIZE value:@(_fontSize)];
    [ccs saveDefaultKey:DELETE_ASK value:@(_deleteAsk)];
    [ccs saveDefaultKey:HIDDEN_BORDER value:@(_hiddenBorder)];
}

- (int)maxTextCountIndex {
    if (_maxTextCount == self.MAX_TEXT_COUNT) {
        return 2;
    }
    if (_maxTextCount == self.MIDDLE_TEXT_COUNT) {
        return 1;
    }
    return 0;
}

- (int)fontSizeIndex {
    if (_fontSize == 24) {
        return 2;
    }
    if (_fontSize == 20) {
        return 1;
    }
    return 0;
}

- (int)deleteAskIndex {
    if (_deleteAsk == YES) {
        return 1;
    }
    return 0;
}

- (int)hiddenBorderIndex {
    if (_hiddenBorder == YES) {
        return 0;
    }
    return 1;
}

- (void)setMaxTextCountIndex:(int)index {
    if (index == 2) {
        _maxTextCount = self.MIN_TEXT_COUNT;
    }
    if (index == 1) {
        _maxTextCount = self.MIDDLE_TEXT_COUNT;
    }
    if (index == 0) {
        _maxTextCount = self.MAX_TEXT_COUNT;
    }
}

- (void)setFontSizeIndex:(int)index {
    if (index == 2) {
        _fontSize = 16;
    }
    if (index == 1) {
        _fontSize = 20;
    }
    if (index == 0) {
        _fontSize = 24;
    }
}

- (void)setDeleteAskIndex:(int)index {
    if (index == 1) {
        _deleteAsk = YES;
    }
    if (index == 0) {
        _deleteAsk = NO;
    }
}

- (void)setHiddenBorderIndex:(int)index {
    if (index == 1) {
        _hiddenBorder = YES;
    }
    if (index == 0) {
        _hiddenBorder = NO;
    }
}

@end
