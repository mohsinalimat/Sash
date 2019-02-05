//
//  AYTouchView.h
//  AYGestureHelpView
//
//  Created by Ayan Yenbekbay on 10/22/15.
//  Copyright © 2015 Ayan Yenbekbay. All rights reserved.
//

extern NSTimeInterval const kTapAnimationDuration;
extern NSTimeInterval const kDoubleTapAnimationDuration;
extern NSTimeInterval const kSwipeAnimationDuration;
extern NSTimeInterval const kLongPressAnimationDuration;

@interface AYTouchView : UIView

#pragma mark Properties

/**
 *  Start point for the motion in the swipe animation.
 */
@property (nonatomic) CGPoint startPoint;
/**
 *  End point for the motion in the swipe animation.
 */
@property (nonatomic) CGPoint endPoint;

#pragma mark Methods

/**
 *  Adds an animation resembling a tap gesture.
 */
- (void)addTapAnimation;
/**
 *  Adds an animation resembling a double tap gesture.
 */
- (void)addDoubleTapAnimation;
/**
 *  Adds an animation resembling a swipe gesture.
 *  @warning Specify <code>startPoint</code> and <code>endPoint</code> before calling this method.
 */
- (void)addSwipeAnimation;
/**
 *  Adds an animation resembling a long press gesture.
 */
- (void)addLongPressAnimation;

@end
