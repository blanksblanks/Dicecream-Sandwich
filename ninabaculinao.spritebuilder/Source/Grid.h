//
//  Grid.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Chain.h"

@interface Grid : CCSprite

- (void)spawnDice;
//- (NSSet *)removeMatches;

@property (nonatomic, assign) NSInteger match;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) float timer;

@end
