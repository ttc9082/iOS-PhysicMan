//
//  TTViewController.m
//  PhysicMan
//
//  Created by Tong Tianqi on 2/19/14.
//  Copyright (c) 2014 Tong Tianqi. All rights reserved.
//


#import "TTMyScene.h"

@interface TTMyScene()
@property SKSpriteNode* mySquare;
@property SKSpriteNode* chest;
@property SKSpriteNode* rightFoot;
@property SKSpriteNode* leftFoot;
@property SKPhysicsJointFixed* chestWaistJoint;
@property SKPhysicsJointFixed* chestLeftarmJoint;
@property SKPhysicsJointFixed* chestRightarmJoint;
@property SKPhysicsJointFixed* waistLeftlegJoint;
@property SKPhysicsJointFixed* waistRightlegJoint;
@property SKPhysicsJointFixed* headChestFix;
@property SKPhysicsJointSpring* leftRightlegSpring;
@property SKPhysicsJointSpring* leftRightarmSpring;
@property SKPhysicsJointSpring* chestLeftlegSpring;
@property SKPhysicsJointSpring* chestRightlegSpring;
@property SKShapeNode* myCircle;
@property SKShapeNode* head;
@property SKShapeNode* chest1;
@property SKShapeNode* waist;
@property SKShapeNode* leftarm;
@property SKShapeNode* rightarm;
@property SKShapeNode* leftleg;
@property SKShapeNode* rightleg;
@end

@implementation TTMyScene

-(SKShapeNode*)addCircle:(CGPoint)Point withR:(int)radius
{
    _myCircle = [[SKShapeNode alloc]init];
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0, 0, radius, 0, M_PI*2, YES);
    _myCircle.path = myPath;
    [_myCircle setStrokeColor: [UIColor orangeColor]];
    _myCircle.fillColor =[UIColor greenColor];
    _myCircle.position = Point;
    _myCircle.physicsBody = [SKPhysicsBody
                             bodyWithCircleOfRadius:radius];
    [self addChild:_myCircle];
    return _myCircle;
}

-(SKSpriteNode*)addSquare:(CGPoint)Point withHeight:(int)height withWidth:(int)width{
    _mySquare = [[SKSpriteNode alloc]initWithColor:[SKColor orangeColor] size:CGSizeMake(width, height)];
    _mySquare.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_mySquare.size];
    [self addChild:_mySquare];
    return _mySquare;
}

-(void)activateJoint{
    _chestWaistJoint = [SKPhysicsJointFixed jointWithBodyA:_chest.physicsBody bodyB:_waist.physicsBody anchor:_chest.position];
    _chestLeftarmJoint = [SKPhysicsJointFixed jointWithBodyA:_chest.physicsBody bodyB:_leftarm.physicsBody anchor:_chest.position];
    _chestRightarmJoint = [SKPhysicsJointFixed jointWithBodyA:_chest.physicsBody bodyB:_rightarm.physicsBody anchor:_chest.position];
    _waistLeftlegJoint = [SKPhysicsJointFixed jointWithBodyA:_waist.physicsBody bodyB:_leftleg.physicsBody anchor:_waist.position];
    _waistRightlegJoint = [SKPhysicsJointFixed jointWithBodyA:_waist.physicsBody bodyB:_rightleg.physicsBody anchor:_waist.position];
    _leftRightarmSpring = [SKPhysicsJointSpring jointWithBodyA:_leftarm.physicsBody bodyB:_rightarm.physicsBody anchorA:_leftarm.position anchorB:_rightarm.position];
    _leftRightlegSpring = [SKPhysicsJointSpring jointWithBodyA:_leftleg.physicsBody bodyB:_rightleg.physicsBody anchorA:_leftleg.position anchorB:_rightleg.position];
    _chestRightlegSpring = [SKPhysicsJointSpring jointWithBodyA:_chest.physicsBody bodyB:_rightleg.physicsBody anchorA:_chest.position anchorB:_rightleg.position];
    _chestLeftlegSpring = [SKPhysicsJointSpring jointWithBodyA:_leftleg.physicsBody bodyB:_chest.physicsBody anchorA:_leftleg.position anchorB:_chest.position];
     _headChestFix = [SKPhysicsJointFixed jointWithBodyA:_head.physicsBody bodyB:_chest.physicsBody anchor:_head.position];
    [_chestRightlegSpring setFrequency:0.7];
    [_chestLeftlegSpring setFrequency:0.7];
    [_leftRightarmSpring setFrequency:0.1];
    [_leftRightarmSpring setDamping:1.3];
    [_leftRightlegSpring setFrequency:0.7];
    [self.physicsWorld addJoint:_chestWaistJoint];
    [self.physicsWorld addJoint:_chestLeftarmJoint];
    [self.physicsWorld addJoint:_chestRightarmJoint];
    [self.physicsWorld addJoint:_waistLeftlegJoint];
    [self.physicsWorld addJoint:_waistRightlegJoint];
    [self.physicsWorld addJoint:_chestLeftlegSpring];
    [self.physicsWorld addJoint:_chestRightlegSpring];
    [self.physicsWorld addJoint:_leftRightarmSpring];
    [self.physicsWorld addJoint:_leftRightlegSpring];
    [self.physicsWorld addJoint:_headChestFix];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self.physicsBody setRestitution:1];
        _head = [self addCircle:CGPointMake(160, 410) withR:30];
        _chest = [self addSquare:CGPointMake(160, 360) withHeight:30 withWidth:20];
        _waist = [self addCircle:CGPointMake(160, 240) withR:20];
        _leftarm = [self addCircle:CGPointMake(80, 300) withR:10];
        _rightarm = [self addCircle:CGPointMake(240, 300)withR:10];
        _leftleg = [self addCircle:CGPointMake(90, 120)withR:10];
        _rightleg = [self addCircle:CGPointMake(230, 120)withR:10];
        [self activateJoint];



        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (_chest.physicsBody.dynamic) {
        
        [_chest.physicsBody setDynamic:NO];
    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_chest setPosition:location];
        
        
        // [_mySquare1.physicsBody setDynamic:NO];
        //  [_mySquare2.physicsBody setDynamic:NO];
        
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_chest setPosition:location];
        
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    if (!_chest.physicsBody.dynamic) {
        [_chest.physicsBody setDynamic:YES];
    }
    //  [_mySquare1.physicsBody setDynamic:YES];
    //  [_mySquare2.physicsBody setDynamic:YES];
    
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (!_chest.physicsBody.dynamic) {
        [_chest.physicsBody setDynamic:YES];
    }
    //  [_mySquare1.physicsBody setDynamic:YES];
    //  [_mySquare2.physicsBody setDynamic:YES];
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end