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
#import "GameState.h"
#import "GameAudio.h"

@implementation PauseMenu {
    CCButton *_homeButton;
    CCButton *_musicButton;
    CCButton *_helpButton;
    CCButton *_sfxButton;
    CCButton *_restartButton;
    CCButton *_resumeButton;
    CCButton *_musicCross;
    CCButton *_sfxCross;
}

- (void)didLoadFromCCB {
    [GameState sharedInstance].popUp = FALSE;
    [self toggleButtonsOn];
}

- (void) update:(CCTime) delta {
    if ([GameState sharedInstance].popUp) {
        [self toggleButtonsOff];
    } else if (![GameState sharedInstance].popUp) {
        [self toggleButtonsOn];
    }
    _musicCross.visible = [GameState sharedInstance].musicPaused;
    _sfxCross.visible = [GameState sharedInstance].sfxPaused;
    [[GameAudio sharedHelper] pauseSFX:[GameState sharedInstance].sfxPaused];
}

- (void) toggleButtonsOff {
        _homeButton.enabled = false;
        _musicButton.enabled = false;
        _sfxButton.enabled = false;
        _helpButton.enabled = false;
        _restartButton.enabled = false;
        _resumeButton.enabled = false;
}

- (void) toggleButtonsOn {
        _homeButton.enabled = true;
        _musicButton.enabled = true;
        _sfxButton.enabled = true;
        _helpButton.enabled = true;
        _restartButton.enabled = true;
        _resumeButton.enabled = true;
}


- (void) resume {
    [MGWU logEvent:@"resume_pressed" withParams:nil];
    [[GameAudio sharedHelper] playPopSound];
    
    [self.grid unpause];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:ccp(0, 25)];
    [self runAction:moveTo];
    
    [self scheduleBlock:^(CCTimer *timer) {
        [self removeFromParent];
    } delay:0.2];
}

// TODO: "Are you sure?" pop up
- (void) restart {
    [MGWU logEvent:@"restart_pressed_in_gameplay" withParams:nil];
    [[GameAudio sharedHelper] playPopSound];

    CCScene *gamePlay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlay];
}

- (void) help {
    [MGWU logEvent:@"help_pressed_in_gameplay" withParams:nil];
    [[GameAudio sharedHelper] playPopSound];

    [GameState sharedInstance].popUp = TRUE;
    HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu"];
    [helpMenu setPositionType:CCPositionTypeNormalized];
    helpMenu.position = ccp(0.5, 0.53); // or consider .scale = 0.8f;
    [self.parent addChild:helpMenu];

}

- (void) music {
    [MGWU logEvent:@"music_toggled" withParams:nil];
    [[GameAudio sharedHelper] playPopSound];
    [GameState sharedInstance].musicPaused = ![GameState sharedInstance].musicPaused;
}

- (void) sfx {
    [GameState sharedInstance].sfxPaused = ![GameState sharedInstance].sfxPaused;
}

// TODO: "Are you sure?" pop up
- (void) home {
    [MGWU logEvent:@"home_pressed_in_gameplay" withParams:nil];
    [[GameAudio sharedHelper] playPopSound];
    if (![GameState sharedInstance].musicPaused){
        [[GameAudio sharedHelper] playMainTheme];
    }
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
