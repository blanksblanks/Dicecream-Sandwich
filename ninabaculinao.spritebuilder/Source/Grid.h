//
//  Grid.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Chain.h"

typedef NS_ENUM(NSInteger, GridState) {
    GridStateSpawningDice,
    GridStateFallingDice,
    GridStateFillingHoles,
    GridStateActivatingSpecials,
    GridStateHandlingMatches
};

//@class Gameplay;

@interface Grid : CCSprite

- (void)spawnDice;
- (void)loadLevel;
- (void)pause;
- (void)unpause;

@property (nonatomic, assign) GridState currentGridState;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger targetScore;
@property (nonatomic, assign) NSInteger possibilities;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger combo;
@property (assign, nonatomic) NSInteger comboMultiplier;
@property (nonatomic, assign) float timer;
@property (nonatomic, assign) float levelSpeed;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) BOOL touchEnabled;
@property (nonatomic, assign) BOOL gameOver;
//@property (nonatomic, strong) OALSimpleAudio *audio;
//@property (nonatomic, strong) Gameplay *gameplay;
@property (nonatomic, assign) NSInteger chains; // in calculate score
@property (nonatomic, assign) NSInteger chainsPerMin; // in game end
@property (nonatomic, assign) NSInteger sixChains; // in calculate score
@property (nonatomic, assign) NSInteger perfectMatches; // in calculate score
@property (nonatomic, assign) NSInteger streak; // not being used right now
@property (nonatomic, assign) NSInteger allClear; // TODO: needs a score bonus


@end
