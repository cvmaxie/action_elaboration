/// @description set initial depth, sprite frame, framerate
depth = 0;
image_speed = 0;
framerate = obj_manager.framerate;
image_index = 0;
dead = true; 
startpos = 0;
standing = false;
squish = false; //squish animation happens when player falls on platform
charge = -.04; //charging jump (increases the longer the key is held down)