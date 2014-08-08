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

@interface Grid : CCSprite

- (void)spawnDice;
//- (void)resetCombo;
- (void)loadLevel;
//- (NSSet *)removeMatches;
- (void)pause;
- (void)unpause;


@property (nonatomic, assign) GridState currentGridState;
@property (nonatomic, assign) NSInteger match;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger targetScore;
@property (nonatomic, assign) NSInteger possibilities;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger combo;
@property (nonatomic, assign) float timer;
@property (nonatomic, assign) float levelSpeed;
@property (nonatomic, assign) BOOL paused;

@end
