//
//  GameState.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

static NSString *const GAME_STATE_SCORE_KEY = @"GameStateScoreKey";

@implementation GameState {
//    int best;
    
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
//        NSInteger *currentScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentScore"] intValue];
//        NSInteger *bestScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] intValue];
//        [[NSUserDefaults standardUserDefaults] integerForKey:@"best"];
        
    }
    
    return self;
}

#pragma mark - Setter Override

//- (void)setCurrentScore:(NSInteger)currentScore {
////    if (currentScore > _currentScore) {
//        _currentScore = currentScore;
//        NSNumber *scoreNumber = [NSNumber numberWithInteger:currentScore];
//        
//        // store change
//        [[NSUserDefaults standardUserDefaults]setObject:scoreNumber forKey:@"currentScore"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
////    }
//}

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
//    if ((int) _currentScore > best){
//        [[NSUserDefaults standardUserDefaults] setInteger:(int)_currentScore forKey:@"best"];
//        
//    }




@end
