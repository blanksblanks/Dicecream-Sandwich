//
//  LevelMenu.m
//  Dicewich
//
//  Created by Nina Baculinao on 9/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelMenu.h"
#import "GameState.h"

@implementation LevelMenu {
    CCButton* _level1;
    CCButton* _level2;
    CCButton* _level3;
    CCButton* _level4;
    CCButton* _level5;
    CCButton* _level6;
    CCButton* _level7;
    CCButton* _level8;
    CCButton* _level9;
    CCButton* _level10;
    CCButton* _level11;
    CCButton* _level12;
    CCButton* _level13;
    CCButton* _level14;
    CCButton* _level15;
    CCButton* _level16;
    CCButton* _level17;
    CCButton* _level18;
    CCButton* _level19;
    CCButton* _level20;
}


-(void) didLoadFromCCB {
    // Only set icons for enabled if they unlock them
    // Create an array?
    CCButton* levels[20] = {_level1, _level2, _level3, _level4, _level5, _level6, _level7, _level8, _level9,
        _level11, _level12, _level13, _level14, _level15, _level16, _level17, _level18, _level19, _level20};
//    for (NSInteger i = 0; i >= 20; i++) {
//        levels[i].enabled = false;
//    }
    for (NSInteger j = [GameState sharedInstance].levelsUnlocked; j > 20; j++) {
        levels[j].enabled = true;
    }
}

-(void) level1 {
    [GameState sharedInstance].levelSelected = 1;
    [self loadGame];
}

-(void) level2 {
    [GameState sharedInstance].levelSelected = 2;
    [self loadGame];
}

-(void) level3 {
    [GameState sharedInstance].levelSelected = 3;
    [self loadGame];
}

-(void) level4 {
    [GameState sharedInstance].levelSelected = 4;
    [self loadGame];
}

-(void) level5 {
    [GameState sharedInstance].levelSelected = 5;
    [self loadGame];
}

-(void) level6 {
    [GameState sharedInstance].levelSelected = 6;
    [self loadGame];
}

-(void) level7 {
    [GameState sharedInstance].levelSelected = 7;
    [self loadGame];
}

-(void) level8 {
    [GameState sharedInstance].levelSelected = 8;
    [self loadGame];
}

-(void) level9 {
    [GameState sharedInstance].levelSelected = 9;
    [self loadGame];
}

-(void) level10 {
    [GameState sharedInstance].levelSelected = 10;
    [self loadGame];
}

-(void) level11 {
    [GameState sharedInstance].levelSelected = 11;
    [self loadGame];
}

-(void) level12 {
    [GameState sharedInstance].levelSelected = 12;
    [self loadGame];
}


-(void) level13 {
    [GameState sharedInstance].levelSelected = 13;
    [self loadGame];
}

-(void) level14 {
    [GameState sharedInstance].levelSelected = 14;
    [self loadGame];
}

-(void) level15 {
    [GameState sharedInstance].levelSelected = 15;
    [self loadGame];
}

-(void) level16 {
    [GameState sharedInstance].levelSelected = 16;
    [self loadGame];
}

-(void) level17 {
    [GameState sharedInstance].levelSelected = 17;
    [self loadGame];
}

-(void) level18 {
    [GameState sharedInstance].levelSelected = 18;
    [self loadGame];
}

-(void) level19 {
    [GameState sharedInstance].levelSelected = 19;
    [self loadGame];
}

-(void) level20 {
    [GameState sharedInstance].levelSelected = 20;
    [self loadGame];
}

-(void) loadGame {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void) home {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
