//
//  Language.m
//  FastWord
//
//  Created by gwh on 2019/11/6.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "Language.h"

@implementation Language

+ (int)isChinese {
    if ([ccs defaultValueForKey:@"isChinese"]) {
        return [[ccs defaultValueForKey:@"isChinese"] intValue];
    }
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage containsString:@"zh"]) {
        [ccs saveDefaultKey:@"isChinese" value:@"1"];
        return 1;
    }
    [ccs saveDefaultKey:@"isChinese" value:@"0"];
    return 0;
}

+ (NSString *)aboutText1 {
    if ([self isChinese]) {
        return @"我们的定位是 ‘快速’，‘简单’，‘易用’。\n\n我搜索了很多笔记应用发现它们都不能比这个应用更快记录。它们有的会在启动后显示广告页，有的会弹出使用指导，还有的展示一些华丽的图片，这都不是我想要的。有的时候我只是想快速记录一些东西，越快越好。\n\n所以我做了这款应用。没有弹窗广告，没有使用指南，没有华丽的图片。在app启动后，所有的代码都为快速准备输入界面而执行，尽可能快速让你记录。稍后也可做一些编辑使笔记更漂亮。\n\n因为我们也没有弹窗打分，如果你能在你方便的时候打分，我们非常感谢~";
    }
    return @"Our main goal is 'Fast', 'Easy' and 'Clear'. \n\nI have searched many note apps but none of them can go to input page as fast as this one. When open an app, someone will pop an AD page, someone will show guid, or display some gorgeous picture, this will make me furious. Because sometimes I just want to write something down as soon as possible. \n\nSo I write this app, no Ad pop up, no guid, no gorgeous picture, onece you open the app, all the code is running for prepare for you an input environment. So that you can write something down as soon as possible. Later you can do some configure or settings to make it beautiful. \n\nAnd the code is open source on '";
}

+ (NSString *)aboutLink {
    return @"https://github.com/gwh111/bench_ios";
}

+ (NSString *)aboutText2 {
    return @"', welcome to commit new features. \n\nBecause there's no pop up rating window, please help to rate when it is convenient for you.";
}

+ (NSString *)newText {
    if ([self isChinese]) {
        return @"新建一个";
    }
    return @"Create new one";
}

+ (NSString *)settingText {
    if ([self isChinese]) {
        return @"设置";
    }
    return @"Setting";
}

+ (NSString *)manageText {
    if ([self isChinese]) {
        return @"管理";
    }
    return @"Manage";
}

+ (NSString *)recommandText {
    if ([self isChinese]) {
        return @"推荐";
    }
    return @"Recommand";
}

+ (NSString *)aboutText {
    if ([self isChinese]) {
        return @"关于";
    }
    return @"About";
}

+ (NSString *)fastNoteText {
    if ([self isChinese]) {
        return @"快速记录📝";
    }
    return @"Fast Note 📝";
}

+ (NSString *)noteBackColorText {
    if ([self isChinese]) {
        return @"文字底色";
    }
    return @"Color";
}

+ (NSString *)cancelText {
    if ([self isChinese]) {
        return @"取消";
    }
    return @"Cancel";
}

+ (NSString *)reviewText {
    if ([self isChinese]) {
        return @"预览";
    }
    return @"Review";
}

+ (NSString *)finishText {
    if ([self isChinese]) {
        return @"完成";
    }
    return @"Finish";
}

+ (NSString *)youWriteNotingText {
    if ([self isChinese]) {
        return @"你还什么都没有填呢~";
    }
    return @"Write somthing~";
}

+ (NSString *)rateText {
    if ([self isChinese]) {
        return @"评分";
    }
    return @"Rate";
}

+ (NSString *)thanksText {
    if ([self isChinese]) {
        return @"感谢体验";
    }
    return @"Thanks";
}

+ (NSString *)helpRateText {
    if ([self isChinese]) {
        return @"无奈我们的下载量依然不多，我们坚决不刷榜，这位大侠可以帮助评论推广一下吗？";
    }
    return @"Could you help to rate in AppStore?";
}

+ (NSString *)laterText {
    if ([self isChinese]) {
        return @"以后再说";
    }
    return @"Later";
}

+ (NSString *)gotoRateText {
    if ([self isChinese]) {
        return @"去评论";
    }
    return @"Goto rate";
}

+ (NSString *)deleteSuccessText {
    if ([self isChinese]) {
        return @"删除成功~";
    }
    return @"Delete success~";
}

+ (NSString *)showMaxTextCountText {
    if ([self isChinese]) {
        return @"显示摘要最大字数？";
    }
    return @"Summary max size？";
}

+ (NSString *)littleText {
    if ([self isChinese]) {
        return @"少";
    }
    return @"little";
}

+ (NSString *)middleText {
    if ([self isChinese]) {
        return @"中";
    }
    return @"middle";
}

+ (NSString *)lotsText {
    if ([self isChinese]) {
        return @"多";
    }
    return @"lots";
}

+ (NSString *)fontsizeText {
    if ([self isChinese]) {
        return @"字体大小？";
    }
    return @"Fontsize？";
}

+ (NSString *)smallText {
    if ([self isChinese]) {
        return @"小";
    }
    return @"small";
}

+ (NSString *)bigText {
    if ([self isChinese]) {
        return @"大";
    }
    return @"big";
}

+ (NSString *)deleteAskText {
    if ([self isChinese]) {
        return @"删除二次确认？";
    }
    return @"Need delete ask？";
}

+ (NSString *)yesText {
    if ([self isChinese]) {
        return @"是";
    }
    return @"yes";
}

+ (NSString *)noText {
    if ([self isChinese]) {
        return @"否";
    }
    return @"no";
}

+ (NSString *)hiddenBorderText {
    if ([self isChinese]) {
        return @"隐藏边框？";
    }
    return @"Hidden border？";
}

+ (NSString *)saveText {
    if ([self isChinese]) {
        return @"保存";
    }
    return @"Save";
}

+ (NSString *)deleteText {
    if ([self isChinese]) {
        return @"删除";
    }
    return @"Delete";
}

+ (NSString *)noticeText {
    if ([self isChinese]) {
        return @"提示";
    }
    return @"Notice";
}

+ (NSString *)youWantDeleteAskText {
    if ([self isChinese]) {
        return @"确认删除吗？";
    }
    return @"You really want to delete?";
}

@end
