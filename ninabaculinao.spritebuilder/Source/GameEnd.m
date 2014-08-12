//
//  GameEnd.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameEnd.h"
#import "GameState.h"
#import "Grid.h"
#import "StatsMenu.h"

@implementation GameEnd {
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_bestLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_chainsLabel;
    CCLabelTTF *_timeLabel;
    
}

- (void) didLoadFromCCB {
    _scoreLabel.string = [NSString stringWithFormat:@"SCORE: %i", [GameState sharedInstance].currentScore];
    _bestLabel.string = [NSString stringWithFormat:@"BEST: %i", [GameState sharedInstance].bestScore];
}

- (void) stats {
    StatsMenu *statsMenu = (StatsMenu*) [CCBReader load:@"StatsMenu"];
    statsMenu.position = self.position;
    [self addChild:statsMenu];
    [self removeFromParent];
}

- (void) home {
    CCLOG(@"home button pressed");
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
    
}


@end
