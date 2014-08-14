//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameState.h"

@implementation MainScene {
}

- (void)play {
    CCLOG(@"play button pressed");
    [self performSelector:@selector(sandwichSpinAway)];
    [self scheduleBlock:^(CCTimer *timer) {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    } delay:1.5];
}

- (void)sandwichSpinAway {
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"sandwichSpinAway"];
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
