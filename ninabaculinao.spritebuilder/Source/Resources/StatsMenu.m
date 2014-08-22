//
//  StatsMenu.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StatsMenu.h"
#import "GameEnd.h"
#import "GameState.h"
#import "Grid.h"
#import "Gameplay.h"


@implementation StatsMenu {
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_chainsLabel;
    CCLabelTTF *_chainsPerMinLabel;
    CCLabelTTF *_sixChainsLabel;
    CCLabelTTF *_perfectMatchLabel;
//    CCLabelTTF *_streakLabel;
    CCLabelTTF *_allClearLabel;
    CCLabelTTF *_timeLabel;
}

- (void) didLoadFromCCB {
    [self performSelector:@selector(current)];
    _scoreLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentScore];
    _levelLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentLevel];
    _chainsLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentChains];
    _chainsPerMinLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentChainsPerMin];
    _sixChainsLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].current6Chains];
    _perfectMatchLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentPerfectMatches];
    //    _streakLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentStreak];
    // NSLog(@"Current clear: %i", [GameState sharedInstance].currentAllClear);
    _allClearLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentAllClear];    //    NSString* _timeString = [Gameplay convertAndUpdateTime:[GameState sharedInstance].currentTime];
    //    _timeLabel.string = _timeString;
    //    _timeLabel.string = [NSString stringWithFormat:@"%f", [GameState sharedInstance].currentTime];

}

- (void) current {
    _scoreLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentScore];
    _levelLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentLevel];
    _chainsLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentChains];
    _chainsPerMinLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentChainsPerMin];
    _sixChainsLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].current6Chains];
    _perfectMatchLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentPerfectMatches];
//    _streakLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentStreak];
    NSLog(@"Current clear: %i", [GameState sharedInstance].currentAllClear);
    _allClearLabel.string = [NSString stringWithFormat:@"%i", [GameState sharedInstance].currentAllClear];
//    NSString* _timeString = [Gameplay convertAndUpdateTime:[GameState sharedInstance].currentTime];
//    _timeLabel.string = _timeString;
//    _timeLabel.string = [NSString stringWithFormat:@"%f", [GameState sharedInstance].currentTime];
}

- (void) best {
    _scoreLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].bestScore];
    _levelLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].bestLevel];
    _chainsLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].bestChains];
    _chainsPerMinLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].bestChainsPerMin];
    _sixChainsLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].best6Chains];
    _perfectMatchLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].bestPerfectMatches];
//    _streakLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].bestStreak];
    _allClearLabel.string = [NSString stringWithFormat:@"%i", [GameState sharedInstance].bestAllClear];
    NSLog(@"Best clear: %i", [GameState sharedInstance].bestAllClear);
//    NSString* _timeString = [Gameplay convertAndUpdateTime:[GameState sharedInstance].bestTime];
//    _timeLabel.string = _timeString;
//    _timeLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].bestTime];
}

- (void) home {
    [MGWU logEvent:@"home_pressed_in_gameend" withParams:nil];
    
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void) restart {
    [MGWU logEvent:@"restart_pressed_in_gameend" withParams:nil];

    CCScene *gamePlay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlay];
}

- (void) back {
    GameEnd *gameEnd = (GameEnd*) [CCBReader load:@"GameEnd"];
    [gameEnd setPositionType:CCPositionTypeNormalized];
    gameEnd.position = ccp(0.5, 0.5);
    [self.parent addChild:gameEnd];
    [self removeFromParent];
}

@end
