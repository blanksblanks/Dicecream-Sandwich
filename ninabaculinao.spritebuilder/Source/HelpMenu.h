//
//  HelpMenu.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface HelpMenu : CCNode

//typedef NS_ENUM(NSInteger, HelpStage) {
//    HelpStageStart,
//    HelpStageCont,
//    HelpStageEnd,
//};

- (void) cancel;
- (void) next;

@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) BOOL cancelled;

@end
