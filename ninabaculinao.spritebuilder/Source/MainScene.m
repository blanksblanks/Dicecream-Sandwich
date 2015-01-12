//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameState.h"
#import "GameAudio.h"
#import "ABGameKitHelper.h"
#import "HelpMenu.h"
#import "Icecream.h"

@implementation MainScene {
    BOOL playPressed;
    CCAnimationManager* animationManager;
    Icecream* sandwich;
    CCButton *_playButton;
    CCButton *_helpButton;
    CCButton *_creditsButton;
    CCButton *_levelButton;
    CCButton *_gameCenterButton;
}

-(void)didLoadFromCCB {
    [[GameAudio sharedHelper] playMainTheme];
    animationManager = self.animationManager;
    [GameState sharedInstance].popUp = FALSE;
    playPressed = FALSE;
    [[ABGameKitHelper sharedHelper] reportScore:[GameState sharedInstance].bestScore forLeaderboard:@"Score"];
}

- (void) update:(CCTime) delta {
    if ([GameState sharedInstance].popUp || playPressed) {
        [self toggleButtonsOff];
    } else { // if (![GameState sharedInstance].popUp && !playPressed) { // reset clickability
        [self toggleButtonsOn];
    }
}

- (void) toggleButtonsOn {
    _playButton.enabled = true;
    _helpButton.enabled = true;
    _creditsButton.enabled = true;
    _levelButton.enabled = true;
    _gameCenterButton.enabled = true;
    animationManager.paused = false;
}

- (void) toggleButtonsOff {
    _playButton.enabled = false;
    _helpButton.enabled = false;
    _creditsButton.enabled = false;
    _levelButton.enabled = false;
    _gameCenterButton.enabled = false;
    animationManager.paused = true;
}

- (void)play {
    [MGWU logEvent:@"play_pressed_in_mainscene" withParams:nil];
    playPressed = true;
    [[GameAudio sharedHelper] playPopSound];
//    [audio stopBg];
    [GameState sharedInstance].levelSelected = 1;
//    [self sandwichSpinAway];
//    [self performSelector:@selector(sandwichSpinAway)];
    
    [self scheduleBlock:^(CCTimer *timer) {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    } delay:1.0];
}

# pragma mark - Button selectors

-(void) help {
    [MGWU logEvent:@"help_pressed_in_mainscene" withParams:nil];
    [[GameAudio sharedHelper] playPopSound];
    [GameState sharedInstance].popUp = TRUE;
    HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu"];
    [helpMenu setPositionType:CCPositionTypeNormalized];
    helpMenu.position = ccp(0.5, 0.53); // or consider .scale = 0.8f;
    [self addChild:helpMenu];
}


-(void) credits {
    [MGWU logEvent:@"credits_pressed_in_mainscene" withParams:nil];
    [[GameAudio sharedHelper] playPopSound];
    CCScene *creditsScene = [CCBReader loadAsScene:@"Credits"];
    [[CCDirector sharedDirector] pushScene:creditsScene];
}

- (void) level {
    [MGWU logEvent:@"level_pressed_in_mainscene" withParams:nil];
    [[GameAudio sharedHelper] playPopSound];
    CCScene *levelScene = [CCBReader loadAsScene:@"LevelMenu"];
    [[CCDirector sharedDirector] replaceScene:levelScene];
}

- (void) gameCenter {
    [[GameAudio sharedHelper] playPopSound];
    [[ABGameKitHelper sharedHelper] showLeaderboard:@"Score"];
}

- (void)reset {
    [GameState sharedInstance].levelsUnlocked = 1;
    [GameState sharedInstance].tutorialMode = true;
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

# pragma mark - Sound and animation

//- (void)sandwichSpinAway {
//    CCAnimationManager* am = sandwich.animationManager;
//    [am runAnimationsForSequenceNamed:@"spinAway"];
//    [audio preloadEffect:@"8-bit-boing.wav"];
//    [audio playEffect:@"8-bit-boing.wav"];
//}
//


@end