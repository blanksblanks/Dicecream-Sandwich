//
//  HelpMenu.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HelpMenu.h"
#import "GameState.h"

@implementation HelpMenu {
    NSInteger step;
    CCNode *_help1;
    CCNode *_help2;
    CCNode *_help3;
}

-(void)didLoadFromCCB {
    step = 0;
    _help1.visible = true;
    _help2.visible = false;
    _help3.visible = false;
}

-(void)next {
    switch (step) {
        case 0: {
            _help1.visible = false;
            _help2.visible = true;
            break;
        }
        case 1: {
            _help2.visible = false;
            _help3.visible = true;
            break;
        }
        case 2: {
            [self cancel];
            break;
        }
    }
    step++;
}

-(void)cancel {
    [self removeFromParent];
    [GameState sharedInstance].popUp = FALSE;
}

@end
