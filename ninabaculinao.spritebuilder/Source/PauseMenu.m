//
//  PauseMenu.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseMenu.h"
#import "Grid.h"

@implementation PauseMenu {
    
    
}

- (void) home {
    CCLOG(@"home button pressed");
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void) game {
    CCLOG(@"game button pressed");
    [self.grid unpause];
    [self removeFromParent];
//    [GameState sharedInstance].highScore;
    
}

@end
