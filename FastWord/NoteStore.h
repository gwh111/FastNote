//
//  TextStore.h
//  FastWord
//
//  Created by gwh on 2019/11/6.
//  Copyright © 2019 gwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteStore : NSObject

+ (NSArray *)getList;
+ (NoteModel *)getContentModelWithSummaryModel:(NoteModel *)model;

+ (void)addSummaryModel:(NoteModel *)model;
+ (void)updateSummaryModel:(NoteModel *)model;
+ (void)deleteSummaryModel:(NoteModel *)model;

+ (void)addContentModel:(NoteModel *)model;
+ (void)updateContentModel:(NoteModel *)model;
+ (void)deleteContentModel:(NoteModel *)model;

@end

NS_ASSUME_NONNULL_END
