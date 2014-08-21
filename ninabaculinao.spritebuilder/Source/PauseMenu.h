//
//  PauseMenu.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@class Grid;

@interface PauseMenu : CCNode

//- (void) resume;
//- (void) restart;
//- (void) help;
//- (void) settings;
//- (void) home;

@property (nonatomic, strong) Grid *grid;
@property (nonatomic, strong) OALSimpleAudio *audio;


@end
