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
@property (nonatomic) NSInteger highScore;


+ (instancetype) sharedInstance;

@end
