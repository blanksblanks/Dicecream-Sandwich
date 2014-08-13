//
//  PauseMenu.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseMenu.h"
#import "HelpMenu.h"
#import "Grid.h"

@implementation PauseMenu {
    
}

- (void) resume {
    CCLOG(@"game button pressed");
    [self.grid unpause];
    self.audio.paused = FALSE;
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:ccp(0, 25)];
    [self runAction:moveTo];
    
    [self scheduleBlock:^(CCTimer *timer) {
        [self removeFromParent];
    } delay:0.2];
}

// TODO: "Are you sure?" pop up
- (void) restart {
    CCScene *gamePlay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlay];
}

- (void) help {
    HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpStart"];
    [helpMenu setPositionType:CCPositionTypeNormalized];
    helpMenu.position = ccp(0.5, 0.5);
    [self.parent addChild:helpMenu];
}

- (void) settings {
    if (!self.audio.muted) {
        self.audio.muted = true;
    } else {
        self.audio.muted = false;
    }
}

// TODO: "Are you sure?" pop up
- (void) home {
    CCLOG(@"home button pressed");
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}


@end
