//
//  GameEnd.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameEnd.h"
#import "GameState.h"
#import "StatsMenu.h"
#import "Grid.h"

@implementation GameEnd {
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_bestLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_chainsLabel;
    CCLabelTTF *_timeLabel;
    CCLabelTTF *_endMessage;
    
    //TODO: custom game messages
}

- (void) didLoadFromCCB {
    _scoreLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].currentScore];
    _bestLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].bestScore];
}

- (void) stats {
    [MGWU logEvent:@"stats_pressed_in_gameend" withParams:nil];
    
    [_grid playPopSound];
//    [_grid.audio playEffect:@"bubble-pop1.wav"];
    
    StatsMenu *statsMenu = (StatsMenu*) [CCBReader load:@"StatsMenu"];
    [statsMenu setPositionType:CCPositionTypeNormalized];
    statsMenu.position = ccp(0.5, 0.5);
    [self.parent addChild:statsMenu];
    [self removeFromParent];
}

- (void) home {
    [MGWU logEvent:@"home_pressed_in_gameend" withParams:nil];
    
    [_grid playPopSound];
//    [_grid.audio playEffect:@"bubble-pop1.wav"];
    
    [self removeFromParent];

    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void) restart {
    [MGWU logEvent:@"restart_pressed_in_gameend" withParams:nil];
    
    [_grid playPopSound];
//    [_grid.audio playEffect:@"bubble-pop1.wav"];
    
    [self removeFromParent];
    
    CCScene *gamePlay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlay];
}



@end
