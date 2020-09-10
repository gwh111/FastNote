//
//  TipModel.m
//  FastWord
//
//  Created by gwh on 2019/11/6.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel

- (void)start {
    
    
}

- (UIColor *)getColor {
    return ShareData.noteColors[_colorIndex];
}

- (void)setSummary:(NSString *)summary {
    _summary = summary;
    _height = [self getStringHeightWithText:summary font:RF(16) viewWidth:(WIDTH()-RH(50))/2] + RH(25);
}

- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;

   // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}

@end
