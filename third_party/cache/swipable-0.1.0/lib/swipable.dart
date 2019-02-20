/*
*    Copyright 2018 Andrew Gu
*
*  Licensed under the Apache License, Version 2.0 (the "License");
*  you may not use this file except in compliance with the License.
*  You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*  See the License for the specific language governing permissions and
*  limitations under the License.
*/

/// # Swipable
///
/// Widget that can be animated in response to gestures, and calls event
/// handlers with custom swipe/flick gestures are detected. Animations and
/// gesture detection are parameterized.
///
/// [Swipable] is the only new [Widget] in this library, and accepts a [child]
/// that can be animated with a [Transform.scale], [Transform.translate],
/// [Transform.rotate] or [Opacity] as defined by user functions.
///
/// ## Animation
///
/// Animation tween functions receive a [SwipableInfo] containing:
///
///   - [position] the current location of the pointer along the x-axis
///   - [startPosition] the location of the pointer along the x-axis when the
///     gesture was initiated
///   - [lastPosition] the previous location of the pointer along the x-axis
///   - [contextWidth] the width of the provided [BuildContext], used to
///      calculate fractional values
///   - [fractionalPosition] the fraction of [contextWidth] represented by
///     [position]
///   - [delta] the difference between [pointer] and [startPosition]
///   - [fractionalDelta] the fraction of [contextWidth] represented by
///     [delta]
///   - [velocity] the difference between [pointer] and [lastPosition]
///   - [fractionalVelocity] the fraction of [contextWidth] represented by
///     [velocity]
///
/// Tween functions should not modify the [SwipableInfo] state they consume,
/// though this is still allowed for simpler code and to allow for advanced
/// customization (especially with altering [startPosition]).
///
/// The [tweenOpacity], [tweenRotation], and [tweenScale] functions should
/// yield [double]s. The [tweenTranslation] function should yield an [Offset].
///
/// ## Gesture Detection
///
/// The [onSwipe] and [onFling] event handler callback functions receive the
/// [SwipableInfo] state and the [DragEndDetails] and yield a [bool] that can be
/// used by [onFling] to cancel calling [onSwipe] if it yields `false`. These
/// event handlers are typically used to alter the [child] parameter. Simply
/// put, [onFling] will be called upon drag end if it meets the fling-related
/// parameters, and [onSwipe] will be called on drag end unless [onFling] yields
/// `false`.
///
///   - [maxFlingVelocity] is the greatest (inclusive) [velocity] of the
///     [DragEndDetails] that will result in the [onFling] event handler being
///     called.
///   - [minFlingDistance] is the smallest (inclusive) [delta] of the
///     [SwipableInfo] that will result in the [onFling] event handler being
///     called.
///   - [minFlingVelocity] is the smallest (inclusive) [velocity] of the
///     [DragEndDetails] that will result in the [onFling] event handler being
///     called.
/// 
/// The [onAction] event handler callback is called on any drag event, and takes
/// [SwipableInfo] state and drag event details. This is useful when extracting
/// data out of the [Swipable] for example in gesture-dependent animations.
library swipable;

export 'src/Swipable.dart';
