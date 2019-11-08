//
//  SettingManage.h
//  FastWord
//
//  Created by gwh on 2019/11/7.
//  Copyright © 2019 gwh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingManage : NSObject

// 显示摘要字数？
// 字体大小？
// 删除二次提示？
// 显示边框？

@property (nonatomic, assign) NSUInteger maxTextCount;
@property (nonatomic, assign) NSUInteger fontSize;
@property (nonatomic, assign) BOOL deleteAsk;
@property (nonatomic, assign) BOOL hiddenBorder;

+ (instancetype)shared;
- (void)save;

- (NSUInteger)MAX_TEXT_COUNT;

- (int)maxTextCountIndex;
- (int)fontSizeIndex;
- (int)deleteAskIndex;
- (int)hiddenBorderIndex;

- (void)setMaxTextCountIndex:(int)index;
- (void)setFontSizeIndex:(int)index;
- (void)setDeleteAskIndex:(int)index;
- (void)setHiddenBorderIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
