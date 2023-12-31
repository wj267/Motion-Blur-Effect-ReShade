# Motion-Blur-Effect-ReShade
A basic motion blur effect written for ReShade

## User Warning
I think these effects are pretty interesting and potentially useful, but I have also found them to cause motion sickness and eyestrain during testing.

The "Motion Delta" effects in particular can cause bright flickering lights which may be dangerous to those with Epilepsy.

Please excercise discretion when using these effects.

## Attribution
Skeleton taken from "Crosire" in this thread on the ReShade forums. I just defined what the Pixel Shader section should actually do.
https://reshade.me/forum/shader-discussion/69-access-to-previous-frames

## Installation
Copy the ".fx" files to the "reshade-shaders" directory for a game you have attached ReShade to.

## Description

### Motion Blur
Creates a motion blur effect by interpolating betweent the previous frame and the current frame.
A slider is provided to adjust the intensity by changing the blend between the two frames.

**Note:** At high blend values (>0.9) the image will effectively freeze due to the domination of the previous frame over the current. This is fixed by reducing the blend value.

### Motion Blur 2
As above, but now calculates the interpolation between the last four frames. The creates more of an afterimage effect than a smear effect.
A slider is provided to adjust the intensity by changing the blend between the frames.

### Motion Delta
Calculates the change between the current and previous frames, adds the difference to the current frame, then blends between the results.
A slider is provided to adjust the intensity by changing the blend.
A number field is provided to adjust the intensity by scaling up the difference between frames. Higher values will make bright objects brighter and leave shadows behind them.

**Note:** This effect can cause pronounced flickering, especially at high scaling values. Use discretion.

### Motion Delta 2
Calculates the change between the current and the average of the previous four frames, adds the difference to the current frame, then blends between the results.
A slider is provided to adjust the intensity by changing the blend.
A number field is provided to adjust the intensity by scaling up the difference between frames. Higher values will make bright objects brighter and leave shadows behind them.

**Note:** This effect is gentler than the first version, but can still cause pronounced flickering, especially at high scaling values. Use discretion.
