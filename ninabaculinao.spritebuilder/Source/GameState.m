//
//  GameState.m
//  ninabaculinao
//
//  Created by Nina Baculinao on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

@implementation GameState {
    
}

+ (instancetype) sharedInstance {
    
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{_sharedObject = [[self alloc] init]; });
    return _sharedObject;

}

- (instancetype) init {
    
    self = [super init];
    if (self) {
    } return self;
}


@end
