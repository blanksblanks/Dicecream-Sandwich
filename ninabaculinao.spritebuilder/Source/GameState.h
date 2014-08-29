//
//  GameState.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCNode.h"


static NSString *const GAME_STATE_SCORE_NOTIFICATION = @"GameState_ScoreChanged";
static NSString *const GAME_STATE_LEVEL_NOTIFICATION = @"GameState_LevelChanged";
static NSString *const GAME_STATE_CHAINS_NOTIFICATION = @"GameState_ChainsChanged";
static NSString *const GAME_STATE_CHAINSPERMIN_NOTIFICATION = @"GameState_ChainsPerMinChanged";
static NSString *const GAME_STATE_6CHAINS_NOTIFICATION = @"GameState_6ChainsChanged";
static NSString *const GAME_STATE_PERFECTMATCHES_NOTIFICATION = @"GameState_PerfectMatchesChanged";
static NSString *const GAME_STATE_STREAK_NOTIFICATION = @"GameState_StreakChanged";
static NSString *const GAME_STATE_ALLCLEAR_NOTIFICATION = @"GameState_AllClearChanged";
static NSString *const GAME_STATE_TIME_NOTIFICATION = @"GameState_TimeChanged";

@interface GameState : NSObject

@property (nonatomic, assign) NSInteger currentScore;
@property (nonatomic, assign) NSInteger currentLevel;
@property (nonatomic, assign) NSInteger currentChains;
@property (nonatomic, assign) NSInteger currentChainsPerMin;
@property (nonatomic, assign) NSInteger current6Chains;
@property (nonatomic, assign) NSInteger currentPerfectMatches;
@property (nonatomic, assign) NSInteger currentStreak;
@property (nonatomic, assign) NSInteger currentAllClear;
@property (nonatomic, assign) NSInteger currentTime;

@property (nonatomic, assign) NSInteger bestScore;
@property (nonatomic, assign) NSInteger bestLevel;
@property (nonatomic, assign) NSInteger bestChains;
@property (nonatomic, assign) NSInteger bestChainsPerMin;
@property (nonatomic, assign) NSInteger best6Chains;
@property (nonatomic, assign) NSInteger bestPerfectMatches;
@property (nonatomic, assign) NSInteger bestStreak;
@property (nonatomic, assign) NSInteger bestAllClear;
@property (nonatomic, assign) NSInteger bestTime;

@property (nonatomic, assign) BOOL popUp;
@property (nonatomic, assign) BOOL musicPaused;

+ (instancetype) sharedInstance;


@end
