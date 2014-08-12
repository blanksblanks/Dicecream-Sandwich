//
//  GameEnd.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@class Grid;

@interface GameEnd : CCNode

- (void) resume;
- (void) restart;
- (void) help;
- (void) settings;
- (void) stats;
- (void) home;

@property (nonatomic, strong) Grid *grid;
@property (nonatomic, strong) OALSimpleAudio *audio;


@end
