///@description variable definitions
//set amount of platforms, and space them evenly vertically
#region VARIABLE DEFINITIONS: PLATFORMS
//SPAWNING
plat_amt = 50; //PLATFORM AMOUNT: set the desired amount of platforms here
plat_w = sprite_get_width(spr_level4); //PLATFORM WIDTH: to spawn them away from edge of screen
plat_h = sprite_get_height(spr_level1);
buffer = room_height/2; //PLATFORM BUFFER: how many spaces (at the top) the platform should NOT be drawn in (for breathing room at top)
padding = 2; //extra space between platforms
spawndelay = 40; //how long the spawn delay should be for the platforms
platnum = instance_number(obj_platform); //number that will check how many platforms there are at any time
//GROWTH
framerate = 10; //platform framerate
grow_timer = 200;
#endregion

#region VARIABLE DEFININITONS: PLAYERS
global.player_w = sprite_get_width(spr_blorb); //PLAYER WIDTH: get width of player sprite

#endregion

#region INITIALIZING
delaytime = spawndelay //setting intial "spawn delay" for platforms

//SPAWN FIRST PLATFORM: random x position and random y position
instance_create_layer(random_range(0 + plat_w / 2, room_width - plat_w / 2), random_range(buffer, room_height - buffer / 4), "Instances", obj_platform); //create each new platform

//SPAWN PLAYERS
instance_create_layer(room_width * .3, room_height, "Instances", obj_blorb); //spawn blorb (child of player object)
instance_create_layer(room_width * .6, room_height, "Instances", obj_blarb); //spawn blarb (child of player object)
#endregion

#region PARTICLES
with (obj_players) {
parts= part_system_create(); //ink spray for player death

spray = part_type_create();
part_type_shape(spray, pt_shape_pixel);
part_type_size(spray, .5, 2, .01, .01);
part_type_speed(spray, 0, 0, 0, 0.1);
part_type_life(spray, 20, 30);
part_type_color1(spray, c_black);
part_type_alpha2(spray, 1.0, .9);
//part_type_orientation(spray, 0, 45, 1, 0, 0);
part_type_gravity(spray, 0.01, 90);

emitter = part_emitter_create(parts);

charging= part_system_create(); //jump sparks for player jump/charging

sparks = part_type_create();
part_type_shape(sparks, pt_shape_pixel);
part_type_size(sparks, .1, 1.8, .01, .01);
part_type_speed(sparks, 0, 0, 0, 0.1);
part_type_life(sparks, 20, 60);
part_type_color1(sparks, c_white);
part_type_alpha2(sparks, 1.0, .75);
//part_type_orientation(spray, 0, 45, 1, 0, 0);
part_type_gravity(sparks, 0.01, 90);

sparkling = part_emitter_create(charging);
}
#endregion