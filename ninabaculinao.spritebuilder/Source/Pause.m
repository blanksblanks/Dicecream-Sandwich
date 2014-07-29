//
//  Pause.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Pause.h"

@implementation Pause

- (void) home {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void) game {
    [[CCDirector sharedDirector] popScene];
}

@end
