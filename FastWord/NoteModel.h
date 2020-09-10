//
//  TipModel.h
//  FastWord
//
//  Created by gwh on 2019/11/6.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "CC_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteModel : CC_Model

@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) NSUInteger colorIndex;

@property (nonatomic, retain) NSString *updateTime;
@property (nonatomic, retain) NSString *createTime;

@property (nonatomic, assign) float height;

- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width;
- (UIColor *)getColor;

@end

NS_ASSUME_NONNULL_END
