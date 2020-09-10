//
//  TextStore.m
//  FastWord
//
//  Created by gwh on 2019/11/6.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "NoteStore.h"

@implementation NoteStore

static NSString *TABLE_SUMMARY = @"NotesSummary";
static NSString *TABLE_CONTENT = @"NotesContent";

+ (NSArray *)getList {
    return [ccs.dataBaseStore query:NoteModel.class where:nil orderBy:@"createTime" desc:YES limit:0 tableName:TABLE_SUMMARY];
    return [ccs.dataBaseStore query:NoteModel.class tableName:TABLE_SUMMARY];
}

+ (NoteModel *)getContentModelWithSummaryModel:(NoteModel *)model {
    NSArray *list = [ccs.dataBaseStore query:NoteModel.class where:[ccs string:@"createTime='%@'", model.createTime] tableName:TABLE_CONTENT];
    if (list.count > 0) {
        return list[0];
    }
    return nil;
}

+ (void)addSummaryModel:(NoteModel *)model {
    [ccs.dataBaseStore insert:model tableName:TABLE_SUMMARY];
}

+ (void)updateSummaryModel:(NoteModel *)model {
//    [self deleteSummaryModel:model];
//    [self addSummaryModel:model];
    [ccs.dataBaseStore update:model where:[ccs string:@"createTime='%@'", model.createTime] tableName:TABLE_SUMMARY];
}

+ (void)deleteSummaryModel:(NoteModel *)model {
    [ccs.dataBaseStore delete:TABLE_SUMMARY where:[ccs string:@"createTime='%@'", model.createTime]];
}

+ (void)addContentModel:(NoteModel *)model {
    [ccs.dataBaseStore insert:model tableName:TABLE_CONTENT];
}

+ (void)updateContentModel:(NoteModel *)model {
//    [self deleteContentModel:model];
//    [self addContentModel:model];
    [ccs.dataBaseStore update:model where:[ccs string:@"createTime='%@'", model.createTime] tableName:TABLE_CONTENT];
}

+ (void)deleteContentModel:(NoteModel *)model {
    [ccs.dataBaseStore delete:TABLE_CONTENT where:[ccs string:@"createTime='%@'", model.createTime]];
}

@end
