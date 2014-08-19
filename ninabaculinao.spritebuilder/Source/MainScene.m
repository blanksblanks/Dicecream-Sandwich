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
    CCButton *_playButton;
    CCButton *_helpButton;
    CCButton *_creditsButton;
}

-(void)didLoadFromCCB {
    self.clickable = true;
}

- (void) update:(CCTime) delta {
    if (helpMenu.cancelled) { // reset clickability
        self.clickable = true;
//        [self toggleButtons];
    } 
}

- (void)play {
    if (self.clickable) {
        self.clickable = false;
    [self performSelector:@selector(sandwichSpinAway)];
        [self scheduleBlock:^(CCTimer *timer) {
            CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
            [[CCDirector sharedDirector] replaceScene:gameplayScene];
        } delay:1.5];
    }
}

-(void) help {
    if (self.clickable) {
//    [self toggleButtons];
        helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpStart"];
        [helpMenu setPositionType:CCPositionTypeNormalized];
        helpMenu.position = ccp(0.5, 0.53); // or consider .scale = 0.8f;
        [self.parent addChild:helpMenu];
        self.clickable = false;
    }
}

-(void) toggleButtons {
    _playButton.togglesSelectedState = false;
    _helpButton.togglesSelectedState = false;
    _creditsButton.togglesSelectedState = false;
}

-(void) credits {
    if (self.clickable) {
    CCScene *creditsScene = [CCBReader loadAsScene:@"Credits"];
    [[CCDirector sharedDirector] pushScene:creditsScene];
    }
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
