///@description set amount of platforms, and space them evenly vertically
#region VARIABLES
/*I defined these here so that if I want to modify anything later, it is easy to do*/
plat_amt = 50; //PLATFORM AMOUNT: set the desired amount of platforms here
plat_w = sprite_get_width(spr_level4); //PLATFORM WIDTH: to spawn them away from edge of screen
plat_h = sprite_get_height(spr_level1);
buffer = plat_h * 5; //PLATFORM BUFFER: how many spaces (at the top) the platform should NOT be drawn in (for breathing room at top)
padding = 3; //extra space between platforms
spawndelay = 60; //how long the spawn delay should be for the platforms
global.player_w = sprite_get_width(spr_blorb); //PLAYER WIDTH: get width of player sprite
platnum = instance_number(obj_platform); //number that will check how many platforms there are at any time
delaytime = spawndelay //setting intial "spawn delay" for platforms
#endregion

//SPAWN FIRST PLATFORM: random x position and random y position
instance_create_layer(random_range(0 + plat_w / 2, room_width - plat_w / 2), random_range(0 + buffer, room_height - buffer / 2), "Instances", obj_platform); //create each new platform

//SPAWN PLAYERS
instance_create_layer(room_width * .3, room_height, "Instances", obj_blorb); //spawn blorb (child of player object)
instance_create_layer(room_width * .6, room_height, "Instances", obj_blarb); //spawn blarb (child of player object)
