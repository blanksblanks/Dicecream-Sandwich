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
    HelpMenu *helpMenu;
    HelpMenu *helpMenu2;
    HelpMenu *helpMenu3;
    CCButton *_playButton;
    CCButton *_helpButton;
    CCButton *_creditsButton;
}

-(void)didLoadFromCCB {
    [GameState sharedInstance].popUp = false;
    self.clickable = true;
}

- (void) update:(CCTime) delta {
    CCLOG(@"%hhd", [GameState sharedInstance].popUp);
    if ([GameState sharedInstance].popUp == TRUE) { // while popup is open, buttons should be disabled
        self.clickable = false; // only works for first help popup for some reason...
        [self toggleButtons];
    } else if ([GameState sharedInstance].popUp == FALSE) { // reset clickability
        self.clickable = true;
        [self toggleButtons];
    }

}

- (void)play {
    [MGWU logEvent:@"play_pressed_in_mainscene" withParams:nil];
    
    if (self.clickable == TRUE) {
        self.clickable = FALSE; // can only click play once / this doesn't work either, but that's okay
        [self performSelector:@selector(sandwichSpinAway)];
        [self scheduleBlock:^(CCTimer *timer) {
            CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
            [[CCDirector sharedDirector] replaceScene:gameplayScene];
        } delay:1.5];
    }
}

-(void) help {
    [MGWU logEvent:@"help_pressed_in_mainscene" withParams:nil];
    
    if (self.clickable) {
        [GameState sharedInstance].popUp = TRUE;
        helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpStart"];
//        helpMenu2 = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpCont"];
//        helpMenu3 = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpEnd"];
        [helpMenu setPositionType:CCPositionTypeNormalized];
        helpMenu.position = ccp(0.5, 0.53); // or consider .scale = 0.8f;
        [self.parent addChild:helpMenu];
    }
}

-(void) toggleButtons {
    if (!self.clickable) {
        _playButton.enabled = false;
        _helpButton.enabled = false;
        _creditsButton.enabled = false;
    } else {
        _playButton.enabled = true;
        _helpButton.enabled = true;
        _creditsButton.enabled = true;
    }
}

-(void) credits {
    [MGWU logEvent:@"credits_pressed_in_mainscene" withParams:nil];
    
    CCScene *creditsScene = [CCBReader loadAsScene:@"Credits"];
    [[CCDirector sharedDirector] pushScene:creditsScene];
}

- (void)sandwichSpinAway {
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"sandwichSpinAway"];
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio preloadEffect:@"8-bit-boing.wav"];
    // play sound effect
    [audio playEffect:@"8-bit-boing.wav"];
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
