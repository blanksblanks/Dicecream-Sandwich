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
    [MGWU logEvent:@"resume_pressed" withParams:nil];
    
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
    [MGWU logEvent:@"restart_pressed_in_gameplay" withParams:nil];

    CCScene *gamePlay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlay];
}

- (void) help {
    [MGWU logEvent:@"help_pressed_in_gameplay" withParams:nil];
    
    HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpStart"];
    [helpMenu setPositionType:CCPositionTypeNormalized];
    helpMenu.position = ccp(0.5, 0.53); // or consider .scale = 0.8f;
    [self.parent addChild:helpMenu];
}

- (void) settings {
    [MGWU logEvent:@"music_toggled" withParams:nil];
    
// Four lines in one
//    if (!self.audio.muted) {
//        self.audio.muted = true;
//    } else {
//        self.audio.muted = false;
//    }
    self.audio.bgMuted = !self.audio.bgMuted;
}

// TODO: "Are you sure?" pop up
- (void) home {
    [MGWU logEvent:@"home_pressed_in_gameplay" withParams:nil];

    CCLOG(@"home button pressed");
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}


@end
