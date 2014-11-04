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
    CCButton *_levelButton;
//    CCButton *_tutorialButton;
//    CCButton *_leaderboardButton;
//    CCButton *_buttons[5];
//    NSArray *_buttonsArray;
    NSInteger count;
    BOOL playPressed;
    OALSimpleAudio *audio;
    CCAnimationManager* animationManager;
}

-(void)didLoadFromCCB {
    animationManager = self.animationManager;
    audio = [OALSimpleAudio sharedInstance];
    [GameState sharedInstance].popUp = FALSE;
    playPressed = FALSE;
    [self toggleButtonsOn];
}

- (void) update:(CCTime) delta {
    if ([GameState sharedInstance].popUp || playPressed) {
        [self toggleButtonsOff];
    } else if (![GameState sharedInstance].popUp && !playPressed) { // reset clickability
        [self toggleButtonsOn];
    }
}

- (void) toggleButtonsOn {
//    CCButton *_buttons[5] = {_playButton, _helpButton, _creditsButton, _levelButton, _leaderboardButton};
//    for (NSInteger i = 0; i > 5 ; i++) {
//        _buttons[i].enabled = true;
//    }
//    _buttonsArray = [NSArray arrayWithObjects:buttons count:5];
//    count = (sizeof buttons) / (sizeof buttons[0]);
    
    _playButton.enabled = true;
    _helpButton.enabled = true;
    _creditsButton.enabled = true;
    _levelButton.enabled = true;
    animationManager.paused = false;
    
//    _tutorialButton.enabled = true;
//    _leaderboardButton.enabled = true;
}

- (void) toggleButtonsOff {
    _playButton.enabled = false;
    _helpButton.enabled = false;
    _creditsButton.enabled = false;
    _levelButton.enabled = false;
    animationManager.paused = true;
    
//    _tutorialButton.enabled = false;
//    _leaderboardButton.enabled = false;
}

- (void)play {
    [MGWU logEvent:@"play_pressed_in_mainscene" withParams:nil];
    
    playPressed = true;
    [self playPopSound];

    
//    [animationManager runAnimationsForSequenceNamed:@"sandwichSpinAway"];

    
//    if ([GameState sharedInstance].tutorialMode) {
//    }

    [GameState sharedInstance].levelSelected = 1;
//    [self sandwichSpinAway];
//    [self performSelector:@selector(sandwichSpinAway)];
    
//    [self scheduleBlock:^(CCTimer *timer) {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
//    } delay:0.2];
}

# pragma mark - Button selectors

-(void) help {
    [MGWU logEvent:@"help_pressed_in_mainscene" withParams:nil];
    
    [self playPopSound];

    [GameState sharedInstance].popUp = TRUE;
    HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu"];
    [helpMenu setPositionType:CCPositionTypeNormalized];
    helpMenu.position = ccp(0.5, 0.53); // or consider .scale = 0.8f;
    [self addChild:helpMenu];
}


-(void) credits {
    [MGWU logEvent:@"credits_pressed_in_mainscene" withParams:nil];
    
    [self playPopSound];
    
    CCScene *creditsScene = [CCBReader loadAsScene:@"Credits"];
    [[CCDirector sharedDirector] pushScene:creditsScene];
}

- (void) level {
    [MGWU logEvent:@"level_pressed_in_mainscene" withParams:nil];
    
    [self playPopSound];
    
    CCScene *levelScene = [CCBReader loadAsScene:@"LevelMenu"];
    [[CCDirector sharedDirector] replaceScene:levelScene];
}
//
//- (void) tutorial {
//    [MGWU logEvent:@"tutorial_pressed_in_mainscene" withParams: nil];
//    [GameState sharedInstance].tutorialMode = true;
//    
//    [self play];
//}

//- (void)leaderboard {
//    [MGWU logEvent:@"level_pressed_in_mainscene" withParams:nil];
//    
//    [self playPopSound];
//    
//    CCScene *leaderboardScene = [CCBReader loadAsScene:@"Leaderboard"];
//    [[CCDirector sharedDirector] replaceScene:leaderboardScene];
//}

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

- (void)sandwichSpinAway {
    [animationManager runAnimationsForSequenceNamed:@"sandwichSpinAway"];
    
    [audio preloadEffect:@"8-bit-boing.wav"];
    [audio playEffect:@"8-bit-boing.wav"];
}

-(void)playPopSound {
    [audio preloadEffect:@"bubble-pop1.wav"];
    [audio playEffect:@"bubble-pop1.wav"];
}


@end