//
//  Background.h
//  MetaLand
//
//  Created by yuwen lian on 6/16/14.
//  Copyright (c) 2014 MetaLand Team. All rights reserved.
//

#import "cocos2d.h"

@interface Background : CCNode {
    CCSprite *_ground;
    CCSprite *_background1;
    CCSprite *_background2;
    CCSprite *_topBackground;
    float positionRecoder;
    float groundLengthRecoder;
    CCSprite *_flagGround;
    CCSprite *_currentBackground;
}

@property (atomic) CCSprite *_ground;
@property (atomic) CCSprite *_background1;
@property (atomic) CCSprite *_background2;
@property (atomic) CCSprite *_topBackground;
@property (atomic) float positionRecoder;
@property (atomic) float groundLengthRecoder;
@property (atomic) CCSprite *_flagGround;
@property (atomic) CCSprite *_currentBackground;

+(CCSprite*)generateFlyingGround;

@end
