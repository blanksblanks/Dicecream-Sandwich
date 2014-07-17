//
//  Tile.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tile.h"

@implementation Tile {
    CCLabelTTF *_valueLabel;
	CCNodeColor *_backgroundNode;
}

- (instancetype)initTile {
    self = [super init];
    if (self) {
        self.isOccupied = NO;
    }
    return self;
}

- (void) setIsOccupied:(BOOL)newState {
    _isOccupied = newState;
    self.visible = _isOccupied;
}


@end
