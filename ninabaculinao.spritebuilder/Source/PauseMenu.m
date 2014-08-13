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

- (void) resume {
    CCLOG(@"game button pressed");
    [self.grid unpause];
    self.audio.paused = FALSE;
    [self removeFromParent];
    
}
- (void) restart {
    CCScene *gamePlay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlay];
}

- (void) help {
    
}

- (void) settings {
    
}

- (void) home {
    CCLOG(@"home button pressed");
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}


@end
