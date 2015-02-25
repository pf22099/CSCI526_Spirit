//
//  Background.m
//  MetaLand
//
//  Created by Xiangmin Liang 02/24/2015.
//  Copyright (c) 2015 Spirit Team. All rights reserved.
//

#import "Background.h"

@implementation Background {
    int _screenWidth;
    int _screenHeight;
}

@synthesize _ground;
@synthesize _background1;
@synthesize _background2;
@synthesize _topBackground;

// -----------------------------------------------------------------------
#pragma mark - Initialize the background
// -----------------------------------------------------------------------
-(id)init {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Initialize the screen size
    _screenWidth = [[UIScreen mainScreen] bounds].size.height;
    _screenHeight = [[UIScreen mainScreen] bounds].size.width;
    
    // Create the sprites
    
    [self createBackgroundSprite];
    [self createGroundSprite];
    [self createTopBackgroundSprite];
        
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Create background sprites
// -----------------------------------------------------------------------
-(void)createGroundSprite {
    _ground = [CCSprite spriteWithImageNamed:@"pd_ground.png"];
    _ground.anchorPoint = CGPointZero;
    _ground.position = ccp(0, 20);
    _ground.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ground.contentSize} cornerRadius:0];
    _ground.physicsBody.type = CCPhysicsBodyTypeStatic;
    _ground.physicsBody.collisionType = @"groundCollision";
    
    [self addChild:_ground];
}

-(void)createBackgroundSprite {
    _background1 = [CCSprite spriteWithImageNamed:@"background2.jpg"];
    _background1.anchorPoint = CGPointZero;
    _background1.position = CGPointZero;
    /*
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Bg1" fontName:@"Verdana-Bold" fontSize:15];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.5f, 0.5f);
    [_background1 addChild:label];
    */
    _background2 = [CCSprite spriteWithImageNamed:@"background2.jpg"];
    _background2.anchorPoint = CGPointZero;
    _background2.position = ccp(_background1.contentSize.width-1, 0);
    /*
    CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Bg2" fontName:@"Verdana-Bold" fontSize:15];
    label2.positionType = CCPositionTypeNormalized;
    label2.position = ccp(0.5f, 0.5f);
    [_background2 addChild:label2];
     */
    
    [self addChild:_background1];
    [self addChild:_background2];
}

-(void)createTopBackgroundSprite {
    _topBackground = [CCSprite spriteWithImageNamed:@"topBackground.png"];
    _topBackground.anchorPoint = ccp(0, 0);
    _topBackground.position = ccp(0, _screenHeight - _topBackground.contentSize.height);
    _topBackground.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _topBackground.contentSize} cornerRadius:0];
    _topBackground.physicsBody.type = CCPhysicsBodyTypeStatic;
    _topBackground.opacity = 0;
    
    [self addChild:_topBackground];
}

@end
