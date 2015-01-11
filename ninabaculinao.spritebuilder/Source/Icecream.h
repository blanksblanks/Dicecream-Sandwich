//
//  Icecream.h
//  Dicewich
//
//  Created by Nina Baculinao on 1/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Icecream : CCNode

@property (nonatomic, strong) CCAnimationManager* animationManager;
-(void) spin;
-(void) spinAway;

@end
