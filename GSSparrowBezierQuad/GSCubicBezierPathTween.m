//
//  GSCubicBezierPathTween.m
//  GSSparrowBezierQuad
//
//  Created by Gaurav on 10/10/13.
//  Copyright (c) 2013 Gaurav. All rights reserved.
//

#import "GSCubicBezierPathTween.h"
#import "BBCubicBezierPath.h"

#define TRANS_SUFFIX  @":"

typedef float (*FnPtrTransition) (id, SEL, float);

@interface GSCubicBezierPathTween ()

@property (nonatomic) float tStart;
@property (nonatomic) float tCurrent;
@property (nonatomic) float tEnd;

@property (nonatomic, readwrite, strong) BBCubicBezierPath *path;


@end

@implementation GSCubicBezierPathTween
{
    int _currentCycle;
    SEL _transition;
    IMP _transitionFunc;
}


- (id)initWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time transition:(NSString*)transition
{
    if ((self = [super init]))
    {
        _target = target;
        self.path = path;
        _totalTime = MAX(0.0001, time); // zero is not allowed
        _currentTime = 0;
        _delay = 0;
        _repeatCount = 1;
        _currentCycle = -1;
        _reverse = NO;
        self.updateAngle = YES;
        self.angleOffset = 0;
        _tEnd = 1.0;
        
        // create function pointer for transition
        NSString *transMethod = [transition stringByAppendingString:TRANS_SUFFIX];
        _transition = NSSelectorFromString(transMethod);
        if (![SPTransitions respondsToSelector:_transition])
            [NSException raise:SP_EXC_INVALID_OPERATION
                        format:@"transition not found: '%@'", transition];
        _transitionFunc = [SPTransitions methodForSelector:_transition];
    }
    return self;
}

- (id)initWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time
{
    return [self initWithTarget:target path:path time:time transition:SP_TRANSITION_LINEAR];
}

#pragma mark - SPAnimatable
- (void)advanceTime:(double)time
{
    if (time == 0.0 || (_repeatCount == 1 && _currentTime == _totalTime))
        return; // nothing to do
    else if ((_repeatCount == 0 || _repeatCount > 1) && _currentTime == _totalTime)
        _currentTime = 0.0;
    
    double previousTime = _currentTime;
    double restTime = _totalTime - _currentTime;
    double carryOverTime = time > restTime ? time - restTime : 0.0;
    _currentTime = MIN(_totalTime, _currentTime + time);
    BOOL isStarting = _currentCycle < 0 && previousTime <= 0 && _currentTime > 0;
    
    if (_currentTime <= 0) return; // the delay is not over yet
    
    if (isStarting)
    {
        _currentCycle++;
        if (_onStart) _onStart();
    }
    
    float ratio = _currentTime / _totalTime;
    BOOL reversed = _reverse && (_currentCycle % 2 == 1);
    FnPtrTransition transFunc = (FnPtrTransition) _transitionFunc;
    Class transClass = [SPTransitions class];
    
    float transitionValue = reversed ?
    1.0f - transFunc(transClass, _transition, 1.0f - ratio) :
    transFunc(transClass, _transition, ratio);
    
    if (previousTime <= 0 && self.currentTime > 0) {
        self.tStart = self.tCurrent;
    }
    // This should always be 1
    float tDelta = self.tEnd - self.tStart;
    
    self.tCurrent = self.tStart + tDelta * transitionValue;
    
    // Get the mx and my for the current value of t
    
    float mx = [self.path mx:self.tCurrent];
    float my = [self.path my:self.tCurrent];
    
    // Set the x & y property of our target.
    [self.target setValue:[NSNumber numberWithFloat:mx] forKey:@"x"];
    [self.target setValue:[NSNumber numberWithFloat:my] forKey:@"y"];
    
    if(self.updateAngle == YES) {
        float trad = [self.path tmrad:self.tCurrent];
        [self.target setValue:[NSNumber numberWithFloat:trad + self.angleOffset] forKey:@"rotation"];
    }
    
    if (_onUpdate) _onUpdate();
    
    if (previousTime < _totalTime && _currentTime >= _totalTime)
    {
        if (_repeatCount == 0 || _repeatCount > 1)
        {
            _currentTime = -_repeatDelay;
            _currentCycle++;
            self.tCurrent = self.tStart;
            if (_repeatCount > 1){
                _repeatCount--;
                
            }
            if (_onRepeat) _onRepeat();
            if (_reverse) {
                self.tCurrent = self.tEnd; // since tweens not necessarily end with endValue
                self.tEnd = self.tStart;
            }
        }
        else
        {
            [self dispatchEventWithType:SP_EVENT_TYPE_REMOVE_FROM_JUGGLER];
            if (_onComplete) _onComplete();
        }
        
    }
    
    if (carryOverTime)
        [self advanceTime:carryOverTime];
}

- (NSString*)transition
{
    NSString *selectorName = NSStringFromSelector(_transition);
    return [selectorName substringToIndex:selectorName.length - [TRANS_SUFFIX length]];
}

- (BOOL)isComplete
{
    return _currentTime >= _totalTime && _repeatCount == 1;
}

- (void)setDelay:(double)delay
{
    _currentTime = _currentTime + _delay - delay;
    _delay = delay;
}

+ (id)tweenWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time transition:(NSString *)transition
{
    return [[self alloc] initWithTarget:target path:path time:time transition:transition];
}

/// Factory method.
+ (id )tweenWithTarget:(id)target path:(BBCubicBezierPath*)path time:(double)time;
{
    return [[self alloc] initWithTarget:target path:path time:time];
}

@end
