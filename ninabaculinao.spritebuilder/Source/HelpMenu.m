//
//  HelpMenu.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HelpMenu.h"

@implementation HelpMenu

-(void)next {
    switch (self.step) {
        case 0: {
            HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpCont"];
            [helpMenu setPositionType:CCPositionTypeNormalized];
            helpMenu.position = ccp(0.5, 0.5);
            [self.parent addChild:helpMenu];
            [self removeFromParent];
        }
        case 1: {
            HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpEnd"];
            [helpMenu setPositionType:CCPositionTypeNormalized];
            helpMenu.position = ccp(0.5, 0.5);
            [self.parent addChild:helpMenu];
            [self removeFromParent];
        }
        case 2: {
            [self cancel];
        }
    }
}

-(void)cancel {
    [self removeFromParent];
}

@end
