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


@implementation StatsMenu {
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_chainsLabel;
    CCLabelTTF *_chainsPerMinLabel;
    CCLabelTTF *_sixChainsLabel;
    CCLabelTTF *_perfectMatchLabel;
    CCLabelTTF *_streakLabel;
    CCLabelTTF *_allClearLabel;
    CCLabelTTF *_timeLabel;
}

- (void) didLoadFromCCB {
    _scoreLabel.string = [NSString stringWithFormat:@"SCORE: %li", (long)[GameState sharedInstance].currentScore];
}

- (void) home {
    CCLOG(@"home button pressed");
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void) restart {
    CCScene *gamePlay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlay];
}

@end
