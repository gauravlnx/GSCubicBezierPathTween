GSCubicBezierPathTween
======================

This is an forked update to [SparrowQuadBezier](https://github.com/somethingkindawierd/SparrowQuadBezier) for [Sparrow-framework](http://gamua.com/sparrow/) version 2+.

This includes an example project (not based on bare-bone project and should work as is).

Example
-------

A path is defined from many curves, like this:

```objective-c
BBCubicBezierPath *path = [[BBCubicBezierPath alloc] init];

[path addSegmentWithA:[SPPoint pointWithX:0.0 y:0.0]
                    b:[SPPoint pointWithX:0.0 y:height / 4]
                    c:[SPPoint pointWithX:width / 4 y:height / 4]
                    d:[SPPoint pointWithX:width / 4 y:height / 4]];

[path addSegmentWithA:[SPPoint pointWithX:width / 4 y:height / 4]
                    b:[SPPoint pointWithX:width - (width / 4) y:height / 4]
                    c:[SPPoint pointWithX:width - 10 y:height - (height / 4)]
                    d:[SPPoint pointWithX:width / 2 y:height / 2]];

[path addSegmentWithA:[SPPoint pointWithX:width / 2 y:height / 2]
                    b:[SPPoint pointWithX:10 y:height / 4]
                    c:[SPPoint pointWithX:(width / 4) y:height - (height / 4)]
                    d:[SPPoint pointWithX:width - (width / 4) y:height - (height / 4)]];

[path addSegmentWithA:[SPPoint pointWithX:width - (width / 4) y:height - (height / 4)]
                    b:[SPPoint pointWithX:width - (width / 4) y:height - (height / 4)]
                    c:[SPPoint pointWithX:width y:height - (height / 4)]
                    d:[SPPoint pointWithX:width y:height]];
```

The tween is just as simple as Sparrow's SPTween class

```objective-c
GSCubicBezierPathTween *bezTween = [BBCubicBezierPathTween tweenWithTarget:targetSprite
                                                                      path:path
                                                                      time:5.0
                                                                transition:SP_TRANSITION_EASE_IN_OUT];
bezTween.reverse = YES;
bezTween.repeatCount = 0;

[[SPStage mainStage].juggler addObject:bezTween];
```

Credits
-------

Full credits to its original author: Jon Beebe 
