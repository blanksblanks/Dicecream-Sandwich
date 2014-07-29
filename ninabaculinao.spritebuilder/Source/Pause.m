//
//  Pause.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Pause.h"

@implementation Pause {
    
}

- (void) home {
    CCLOG(@"home button pressed");
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void) game {
    CCLOG(@"game button pressed");
    [[CCDirector sharedDirector] popScene];
}

@end
