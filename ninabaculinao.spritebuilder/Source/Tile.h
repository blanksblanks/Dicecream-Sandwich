//
//  Tile.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Tile : CCSprite

@property (nonatomic, assign) BOOL isOccupied;

-(id)initTile;

@end
