//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameState.h"
#import "HelpMenu.h"

@implementation MainScene {
    CCButton *_playButton;
    CCButton *_helpButton;
    CCButton *_creditsButton;
    OALSimpleAudio *audio;
}

-(void)didLoadFromCCB {
    audio = [OALSimpleAudio sharedInstance];
    [GameState sharedInstance].popUp = FALSE;
    [self toggleButtonsOn];
}

- (void) update:(CCTime) delta {
    if ([GameState sharedInstance].popUp) {
        [self toggleButtonsOff];
    } else if (![GameState sharedInstance].popUp) { // reset clickability
        [self toggleButtonsOn];
    }
}

- (void) toggleButtonsOff {
        _playButton.enabled = false;
        _helpButton.enabled = false;
        _creditsButton.enabled = false;
}

- (void) toggleButtonsOn {
        _playButton.enabled = true;
        _helpButton.enabled = true;
        _creditsButton.enabled = true;
}

- (void)play {
    [MGWU logEvent:@"play_pressed_in_mainscene" withParams:nil];
    
    [self toggleButtonsOff];
    [self performSelector:@selector(sandwichSpinAway)];
    [self scheduleBlock:^(CCTimer *timer) {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    } delay:1.5];
}

- (void)sandwichSpinAway {
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"sandwichSpinAway"];

    [audio preloadEffect:@"8-bit-boing.wav"];
    [audio playEffect:@"8-bit-boing.wav"];
}


-(void) help {
    [MGWU logEvent:@"help_pressed_in_mainscene" withParams:nil];
    
    [audio preloadEffect:@"bubble-pop1.wav"];
    [audio playEffect:@"bubble-pop1.wav"];

    [GameState sharedInstance].popUp = TRUE;
    HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu"];
    [helpMenu setPositionType:CCPositionTypeNormalized];
    helpMenu.position = ccp(0.5, 0.53); // or consider .scale = 0.8f;
    [self addChild:helpMenu];
}


-(void) credits {
    [MGWU logEvent:@"credits_pressed_in_mainscene" withParams:nil];
    
    [audio preloadEffect:@"bubble-pop1.wav"];
    [audio playEffect:@"bubble-pop1.wav"];
    
    CCScene *creditsScene = [CCBReader loadAsScene:@"Credits"];
    [[CCDirector sharedDirector] pushScene:creditsScene];
}

- (void)reset {
    [GameState sharedInstance].bestScore = 0;
    [GameState sharedInstance].bestLevel = 0;
    [GameState sharedInstance].bestTime = 0;
    [GameState sharedInstance].bestChains = 0;
    [GameState sharedInstance].bestChainsPerMin = 0;
    [GameState sharedInstance].best6Chains = 0;
    [GameState sharedInstance].bestPerfectMatches = 0;
    [GameState sharedInstance].bestStreak = 0;
    [GameState sharedInstance].bestAllClear = 0;
}

@end
