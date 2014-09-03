//
//  GameState.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

static NSString *const GAME_STATE_SCORE_KEY = @"GameStateScoreKey";
static NSString *const GAME_STATE_LEVEL_KEY = @"GameStateLevelKey";
static NSString *const GAME_STATE_CHAINS_KEY = @"GameStateChainsKey";
static NSString *const GAME_STATE_CHAINSPERMIN_KEY = @"GameStateChainsPerMinKey";
static NSString *const GAME_STATE_6CHAINS_KEY = @"GameState6ChainsKey";
static NSString *const GAME_STATE_PERFECTMATCHES_KEY = @"GameStatePerfectMatchesKey";
static NSString *const GAME_STATE_STREAK_KEY = @"GameStateStreakKey";
static NSString *const GAME_STATE_ALLCLEAR_KEY = @"GameStateAllClearKey";
static NSString *const GAME_STATE_TIME_KEY = @"GameStateTimeKey";

@implementation GameState {
}

+ (instancetype) sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{_sharedObject = [[self alloc] init]; });
    return _sharedObject;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        NSNumber *bestScore = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_SCORE_KEY];
        self.bestScore = [bestScore integerValue];
        self.currentScore = 0;
        NSNumber *bestLevel = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_LEVEL_KEY];
        self.bestLevel = [bestLevel integerValue];
        self.currentLevel = 0;
        NSNumber *bestChains = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_CHAINS_KEY];
        self.bestChains = [bestChains integerValue];
        self.currentLevel = 0;
        NSNumber *bestChainsPerMin = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_CHAINSPERMIN_KEY];
        self.bestChainsPerMin = [bestChainsPerMin integerValue];
        self.currentChainsPerMin = 0;
        NSNumber *best6Chains = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_6CHAINS_KEY];
        self.best6Chains = [best6Chains integerValue];
        self.current6Chains = 0;
        NSNumber *bestPerfectMatches = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_PERFECTMATCHES_KEY];
        self.bestPerfectMatches = [bestPerfectMatches integerValue];
        self.currentPerfectMatches = 0;
        NSNumber *bestStreak = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_STREAK_KEY];
        self.currentStreak = [bestStreak integerValue];
        self.currentStreak = 0;
        NSNumber *bestAllClear = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_ALLCLEAR_KEY];
        self.currentAllClear = [bestAllClear integerValue];
        self.currentAllClear = 0;
        NSNumber *bestTime = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_TIME_KEY];
        self.currentTime = [bestTime integerValue];
        self.currentTime = 0;
        
        self.levelsUnlocked = 0;
    }
    return self;
}

#pragma mark - Setter Override


- (void)setBestScore:(NSInteger)bestScore {
//    if (_currentScore > _bestScore) {
        _bestScore = bestScore;
        NSNumber *scoreNumber = [NSNumber numberWithInteger:bestScore];
    // broadcast change
    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_SCORE_NOTIFICATION object:scoreNumber];
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:scoreNumber forKey:GAME_STATE_SCORE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)setBestLevel:(NSInteger)bestLevel {
    _bestLevel = bestLevel;
    NSNumber *levelNumber = [NSNumber numberWithInteger:bestLevel];
    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_LEVEL_NOTIFICATION object:levelNumber];
    
    [[NSUserDefaults standardUserDefaults]setObject:levelNumber forKey:GAME_STATE_LEVEL_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)setBestChains:(NSInteger)bestChains {
    _bestChains = bestChains;
    NSNumber *chainsNumber = [NSNumber numberWithInteger:bestChains];
    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_CHAINS_NOTIFICATION object:chainsNumber];
    
    [[NSUserDefaults standardUserDefaults]setObject:chainsNumber forKey:GAME_STATE_CHAINS_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)setBestChainsPerMin:(NSInteger)bestChainsPerMin {
    _bestChainsPerMin = bestChainsPerMin;
    NSNumber *chainsPerMinNumber = [NSNumber numberWithInteger:bestChainsPerMin];
    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_CHAINSPERMIN_NOTIFICATION object:chainsPerMinNumber];
    
    [[NSUserDefaults standardUserDefaults]setObject:chainsPerMinNumber forKey:GAME_STATE_CHAINSPERMIN_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)setBest6Chains:(NSInteger)best6Chains {
    _best6Chains = best6Chains;
    NSNumber *sixChainsNumber = [NSNumber numberWithInteger:best6Chains];
    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_6CHAINS_NOTIFICATION object:sixChainsNumber];
    
    [[NSUserDefaults standardUserDefaults]setObject:sixChainsNumber forKey:GAME_STATE_6CHAINS_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)setBestPerfectMatches:(NSInteger)bestPerfectMatches {
    _bestPerfectMatches = bestPerfectMatches;
    NSNumber *perfectMatchesNumber = [NSNumber numberWithInteger:bestPerfectMatches];
    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_PERFECTMATCHES_NOTIFICATION object:perfectMatchesNumber];
    
    [[NSUserDefaults standardUserDefaults]setObject:perfectMatchesNumber forKey:GAME_STATE_PERFECTMATCHES_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)setBestStreak:(NSInteger)bestStreak {
    _bestStreak = bestStreak;
    NSNumber *streakNumber = [NSNumber numberWithInteger:bestStreak];
    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_STREAK_NOTIFICATION object:streakNumber];
    
    [[NSUserDefaults standardUserDefaults]setObject:streakNumber forKey:GAME_STATE_STREAK_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setBestAllClear:(NSInteger)bestAllClear {
    _bestAllClear = bestAllClear;
    NSNumber *allClearNumber = [NSNumber numberWithInteger:bestAllClear];
    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_ALLCLEAR_NOTIFICATION object:allClearNumber];
    
    [[NSUserDefaults standardUserDefaults]setObject:allClearNumber forKey:GAME_STATE_ALLCLEAR_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setBestTime:(NSInteger)bestTime {
    _bestTime = bestTime;
    NSNumber *timeNumber = [NSNumber numberWithInteger:bestTime];
    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_TIME_NOTIFICATION object:timeNumber];
    
    [[NSUserDefaults standardUserDefaults]setObject:timeNumber forKey:GAME_STATE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end
