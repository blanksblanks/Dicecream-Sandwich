//
//  Grid.h
//  ninabaculinao
//
//  Created by Nina Baculinao on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Grid : CCSprite
{
    CCPhysicsNode *_physicsNode;
}
- (void)makeNewDicePair;

@property (nonatomic, assign) int score;



@end
