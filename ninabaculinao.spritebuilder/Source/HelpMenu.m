//
//  HelpMenu.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HelpMenu.h"
#import "GameState.h"

@implementation HelpMenu

-(void)didLoadFromCCB {
    self.cancelled = false;
}

-(void)next {
    switch (self.step) {
        case 0: {
//            HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpCont"];
//            [helpMenu setPositionType:CCPositionTypeNormalized];
//            helpMenu.position = ccp(0.5, 0.53);
//            helpMenu.cancelled = false;
//            [self.parent addChild:helpMenu];
//            [GameState sharedInstance].popUpClosed = false;
//            [self removeFromParent];
            CCScene *helpMenu = [CCBReader loadAsScene:@"HelpMenu/Help2"];
            [[CCDirector sharedDirector] pushScene:helpMenu];
        }
        case 1: {
//            HelpMenu *helpMenu = (HelpMenu*) [CCBReader load:@"HelpMenu/HelpEnd"];
//            [helpMenu setPositionType:CCPositionTypeNormalized];
//            helpMenu.position = ccp(0.5, 0.53);
//            helpMenu.cancelled = false;
//            [self.parent addChild:helpMenu];
//            [GameState sharedInstance].popUpClosed = false;
//            [self removeFromParent];
            CCScene *helpMenu = [CCBReader loadAsScene:@"HelpMenu/Help3"];
            [[CCDirector sharedDirector] pushScene:helpMenu];
        }
        case 2: {
            [self cancel];
        }
    }
}

-(void)cancel {
//    [self removeFromParent];
////    self.cancelled = true;
//    [GameState sharedInstance].popUpClosed = true;
    [[CCDirector sharedDirector] popToRootScene];

}

@end
