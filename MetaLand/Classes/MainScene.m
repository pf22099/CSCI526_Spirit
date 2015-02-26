//
//  HelloWorldScene.m
//  MetaLand
//
//  Created by Weiwei Zheng on 6/3/14.
//  Copyright Weiwei Zheng 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "MainScene.h"
#import "IntroScene.h"
#import "Robot.h"
#import "Background.h"

#import "CCAnimatedSprite.h"
#import "CCAnimation.h"
#import "CCAnimationCache.h"


// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation mainScene
{
    CCSprite *_robot;
    Background *_background;
    CCPhysicsNode *_physicsWorld;
    int touches;
    
    float _scrollSpeed;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (mainScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    //[[OALSimpleAudio sharedInstance] playBg:@"background-music-acc.caf" loop:YES];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [self addChild:background z:0];
   
    //Create the physics world
    [self createPhysicsWorld];
    [self initialScrollingBackground];
    
    // Add a robot and enemies
    [self addRobot];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.1f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
//    //Create a physics world
//    _physicsWorld = [CCPhysicsNode node];
//    _physicsWorld.gravity = ccp(0,-500.0f);
//    _physicsWorld.debugDraw = NO;
//    _physicsWorld.collisionDelegate = self;
//    [self addRobot];
//    [self addChild:_physicsWorld];
    
    //Set up global variables
    _scrollSpeed = 10;
    

	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Add all scene related code here.
// -----------------------------------------------------------------------
-(void)createPhysicsWorld {
    //Create physics-world
    _physicsWorld = [CCPhysicsNode node];
    
    _physicsWorld.gravity = ccp(0, -500);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
}

//Create our scrolling background
-(void)initialScrollingBackground {
    _background = [Background node];
    
//    if (_targetScene==0)
//        [self addRecordSign:_background._background1];
//    else if(_targetScene==1)
//        [self addRecordSign:_background._background2];
    
    [_physicsWorld addChild:_background];
}

-(void)addRobot
{
 //Add robot
 //_robot = [CCSprite spriteWithImageNamed:@"robot.png"];
 _robot = [Robot createCharacter:CHARACTER_ROBOT_RUN];
 _robot.position  = ccp(self.contentSize.width/8,self.contentSize.height/2);
 _robot.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _robot.contentSize} cornerRadius:0];
 _robot.physicsBody.collisionGroup = @"robotGroup";
 _robot.physicsBody.collisionType = @"robotCollision";
    [_physicsWorld addChild:_robot z:1];
}

-(void)addCoins:(CCTime)dt
{

}

-(void)addMissle:(CCTime)dt
{
    
}


// -----------------------------------------------------------------------
#pragma mark - Add all realtime thread control related code here
// -----------------------------------------------------------------------
-(void)update:(CCTime)delta {
    [self backgroundScroll : _scrollSpeed];
}
-(void)backgroundScroll : (float)delta {
    //Move background and all attached staff
    for (float i = 0.0f; i<delta; i+=.1f) {
        _background._background1.position = ccp(_background._background1.position.x - .1, _background._background1.position.y);
        _background._background2.position = ccp(_background._background2.position.x - .1, _background._background2.position.y);
        _background._ground.position = ccp(_background._ground.position.x - .1, _background._ground.position.y);
    }
    
    //If _flagGround is a little far away from the right edge, generate a new ground
    //CCLOG(@"!!!%f",flag.position.x);
//    if (counter >= 200) {
//        //CCLOG(@"!!!!!!%f <> %f",_background._flagGround.position.x + [_background._flagGround boundingBox].size.width - 1,self.contentSize.width);
//        if (_background._background1.position.x <= 0) {
//            [self generateGround:_background._background2];
//        }
//        if (_background._background2.position.x <= 0) {
//            [self generateGround:_background._background1];
//        }
//    }
    
    if (_background._background1.position.x <= -_background._background1.contentSize.width+1) {
        
        _background._background1.position = ccp(_background._background2.position.x + [_background._background2 boundingBox].size.width - 1, _background._background1.position.y );
        
        [_background._background1 removeAllChildrenWithCleanup:YES];
        
//        if (_sceneCounter==_record/100)
//        {
//            [self addRecordSign:_background._background1];
//        }
//        _sceneCounter++;
//        
        [self generateGround:_background._background1];
        
    }
    else if (_background._background2.position.x <= -_background._background2.contentSize.width+1) {
        
        _background._background2.position = ccp(_background._background1.position.x + [_background._background1 boundingBox].size.width - 1, _background._background2.position.y );
        
        [_background._background2 removeAllChildrenWithCleanup:YES];
        
        
//        if (_sceneCounter==_record/100)
//        {
//            [self addRecordSign:_background._background2];
//        }
//        _sceneCounter++;
//         */
        [self generateGround:_background._background2];
    }
}

//Generate a new ground
-(void)generateGround : (CCSprite*)bg {
    float counter = 0;
    while (counter < bg.contentSize.width - 1) {
        CCSprite *spr = [Background generateFlyingGround];
        
        spr.scaleY = 0.5;
        int x = counter;
        int minY = bg.contentSize.height * 0.1;
        int maxY = bg.contentSize.height * 0.4;
        int randomY = arc4random()%(maxY-minY)+minY;
        spr.position = ccp(x,randomY);
        [bg addChild:spr];
        counter += [spr boundingBox].size.width + 20;
        CCLOG(@"++++++++++++++%lu",(unsigned long)bg.children.count);
    }
    //CCLOG(@"++++++++++++++");
}

//Andy.
//to refreah the robot's state when changing its shape
-(void)refreshRobot: (int) state
    pos_x: (CGFloat) px
    pos_y: (CGFloat) py
{
    //Change the robot's picture
    [_robot removeFromParentAndCleanup:YES];
    _robot = [Robot createCharacter:state];
    _robot.position = ccp(px, py);
    _robot.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _robot.contentSize} cornerRadius:0];
    _robot.physicsBody.collisionGroup = @"robotGroup";
    _robot.physicsBody.collisionType = @"robotCollision";
    [_physicsWorld addChild:_robot z:1];
}

// -----------------------------------------------------------------------
#pragma mark - Add all Collision related code here
// -----------------------------------------------------------------------

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCNode *)robot missileCollision:(CCNode *)missile
{
    [missile removeFromParent];
    [robot removeFromParent];
    return YES;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair robotCollision:(CCSprite *)robot groundCollision:(CCNode *)ground
{
    touches=0;
//    Change the robot's picture
//    CGFloat px = _robot.position.x;
//    CGFloat py = _robot.position.y;
//    [self refreshRobot:CHARACTER_ROBOT_RUN pos_x:px pos_y:py];
//    [_robot removeFromParentAndCleanup:YES];
//    _robot = [Robot createCharacter:CHARACTER_ROBOT_RUN];
//    _robot.position = ccp(px, py);
//    _robot.physicsBody.collisionGroup = @"robotGroup";
//    _robot.physicsBody.collisionType = @"robotCollision";
//    _robot.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _robot.contentSize} cornerRadius:0];
//    [_physicsWorld addChild:_robot z:1];


    return YES;
}

-(void)startGame
{
    
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    [self schedule:@selector(addMissle:) interval:0.1];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    touches++;
    CCLOG(@"TOUCHES: %d", touches);
    if (touches==3) {
            CGFloat px = _robot.position.x;
            CGFloat py = _robot.position.y;
           [self refreshRobot:CHARACTER_ROBOT_FLY pos_x:px pos_y:py];
            [_robot removeFromParentAndCleanup:YES];
            _robot = [Robot createCharacter:CHARACTER_ROBOT_FLY];
            _robot.position = ccp(px, py);
            _robot.physicsBody.collisionGroup = @"robotGroup";
            _robot.physicsBody.collisionType = @"robotCollision";
            [_physicsWorld addChild:_robot z:1];
        _robot.physicsBody.type=CCPhysicsBodyTypeStatic;
        return;
    }
    if(touches>3)
        return;
//    CGPoint touchLoc = [touch locationInNode:self];
//    
//    // Log touch location
//    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    //Change the robot's picture
    CGFloat px = _robot.position.x;
    CGFloat py = _robot.position.y;
    // Move our sprite to touch location

    
//   [self refreshRobot:CHARACTER_ROBOT_FLY pos_x:px pos_y:py];
//    [_robot removeFromParentAndCleanup:YES];
//    _robot = [Robot createCharacter:CHARACTER_ROBOT_FLY];
//    _robot.position = ccp(px, py);
//    _robot.physicsBody.collisionGroup = @"robotGroup";
//    _robot.physicsBody.collisionType = @"robotCollision";
//    [_physicsWorld addChild:_robot z:1];
    
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:0.3f position: ccp(px,110.0f+py)];
    _robot.physicsBody.velocity=CGPointZero;
    [_robot runAction:actionMove];
   

    
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if (touches==3) {
        CGFloat px = _robot.position.x;
        CGFloat py = _robot.position.y;
        [self refreshRobot:CHARACTER_ROBOT_FLY pos_x:px pos_y:py];
        [_robot removeFromParentAndCleanup:YES];
        _robot = [Robot createCharacter:CHARACTER_ROBOT_RUN];
        _robot.position = ccp(px, py);
        _robot.physicsBody.collisionGroup = @"robotGroup";
        _robot.physicsBody.collisionType = @"robotCollision";
        [_physicsWorld addChild:_robot z:1];

        _robot.physicsBody.type=CCPhysicsBodyTypeDynamic;
        return;
    }
        
//        [self refreshRobot:CHARACTER_ROBOT_FALL pos_x:px pos_y:py];
        //Change the robot's picture
//        [_robot removeFromParentAndCleanup:YES];
//        _robot = [Robot createCharacter:CHARACTER_ROBOT_FALL];
//        _robot.position = ccp(px, py);
//        _robot.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _robot.contentSize} cornerRadius:0];
//        _robot.physicsBody.collisionGroup = @"robotGroup";
//        _robot.physicsBody.collisionType = @"robotCollision";
//        [_physicsWorld addChild:_robot z:1];
}

//}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];
}

// -----------------------------------------------------------------------
@end
