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
}

- (void)play {
    CCLOG(@"play button pressed");
    [self performSelector:@selector(sandwichSpinAway)];
    [self scheduleBlock:^(CCTimer *timer) {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    } delay:1.5];
}

-(void) help {
    HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpStart"];
    [helpMenu setPositionType:CCPositionTypeNormalized];
    helpMenu.position = ccp(0.5, 0.53); // or consider .scale = 0.8f;
    [self.parent addChild:helpMenu];
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

/* TODO: Calculate score system method - ended up doing it manually
 
 -(void)didLoadFromCCB {
 
 // Access score system dictionary
 NSInteger face = 0;
 NSInteger match;
 NSInteger perfectMatch;
 
 NSString*sspath = [[NSBundle mainBundle] pathForResource:@"ScoreSystem" ofType:@"plist"];
 NSDictionary *ssroot = [NSDictionary dictionaryWithContentsOfFile:sspath];
 
 NSArray *scoreSystem = [ssroot objectForKey: @"ScoreSystem"];
 
 NSDictionary *ssdict = scoreSystem[face-1];
 match = [ssdict[@"score"] intValue];
 perfectMatch = [ssdict[@"double"] intValue];
 
 // Access levels dictionary
 
 NSInteger level = 0;
 NSInteger possibilities;
 
 NSString*lpath = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
 NSDictionary *lroot = [NSDictionary dictionaryWithContentsOfFile:lpath];
 
 NSArray *levels = [lroot objectForKey: @"Levels"];
 
 NSDictionary *ldict = levels[level-1];
 possibilities = [ldict[@"possibilities"] intValue];
 
 // Calculate target scores
 // for each level, take all possibilities, get average, and multiply by desired moves
 
 }
 
 */

@end
