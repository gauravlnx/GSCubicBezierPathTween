//
//  GSCubicBezierPathTween.h
//  GSSparrowBezierQuad
//
//  Created by Gaurav on 10/10/13.
//  Copyright (c) 2013 Gaurav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPEventDispatcher.h"
#import "SPAnimatable.h"
#import "SPTransitions.h"
#import "SPMacros.h"
#import "BBCubicBezierPath.h"

@interface GSCubicBezierPathTween : SPEventDispatcher <SPAnimatable>

/// Initializes a tween with a target, duration (in seconds) and a transition function.
/// _Designated Initializer_.
- (id)initWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time transition:(NSString*)transition;

/// Initializes a tween with a target, a time (in seconds) and a linear transition
/// (`SP_TRANSITION_LINEAR`).
- (id)initWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time;

/// Factory method.
+ (id )tweenWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time transition:(NSString *)transition;

/// Factory method.
+ (id)tweenWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time;

/// ----------------
/// @name Properties
/// ----------------

/// The target object that is animated.
@property (nonatomic, readonly) id target;

/// The transition method used for the animation.
@property (weak, nonatomic, readonly) NSString *transition;

/// The total time the tween will take (in seconds).
@property (nonatomic, readonly) double totalTime;

/// The time that has passed since the tween was started (in seconds).
@property (nonatomic, readonly) double currentTime;

/// The delay before the tween is started.
@property (nonatomic, assign) double delay;

/// The number of times the tween will be executed. Set to 0 to tween indefinitely. (Default: 1)
@property (nonatomic, assign) int repeatCount;

/// The number seconds to wait between repeat cycles. (Default: 0)
@property (nonatomic, assign) double repeatDelay;

/// Indicates if the tween should be reversed when it is repeating. If enabled,
/// every second repetition will be reversed. (Default: `NO`)
@property (nonatomic, assign) BOOL reverse;

/// Do you want to update the angle of the target object based on the tangent of the curve?
@property (nonatomic, assign) BOOL updateAngle;

/// If updating the target's angle, this allows for a default offset to be applied throughout the animation.
@property (nonatomic, assign) float angleOffset;

/// A block that will be called when the tween starts (after a possible delay).
@property (nonatomic, copy) SPCallbackBlock onStart;

/// A block that will be called each time the tween is advanced.
@property (nonatomic, copy) SPCallbackBlock onUpdate;

/// A block that will be called each time the tween finishes one repetition
/// (except the last, which will trigger 'onComplete').
@property (nonatomic, copy) SPCallbackBlock onRepeat;

/// A block that will be called when the tween is complete.
@property (nonatomic, copy) SPCallbackBlock onComplete;

@end
