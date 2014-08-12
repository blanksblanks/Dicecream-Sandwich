//
//  GameState.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCNode.h"

@interface GameState : NSObject


//code goes here!
//@property (nonatomic) NSInteger highScore;

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

+ (instancetype) sharedInstance;


@end
