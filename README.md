# Brief overview
This script was written as a commission.
The player's mouse movement across the screen is tracked
A corresponding animation to this movement is performed

# Details
When the player left mouse clicks, the coordinates of that mouse click are recorded
The player will then drag their mouse, releasing at a different point on the screen
These new coordinates are recorded

Using these coordinates, some simple mathematics is done
The distance and direction in which the mouse has moved is calculated
The direction has been abstracted into 8 compass points
North, North East, East, South East, South, South West, West, North West

The player must have dragged a minimum distance to proceed
If this is the case, the direction of the drag is matched to an animation
The animation in this instance is the movement of an NPC around the baseplate

Finally, a cooldown is set before the next drag can be registered

# Reflection
This was my first ever commission which I successfully completed quite quickly
I have since significantly improved my skills and efficiency of my scripting in Lua
