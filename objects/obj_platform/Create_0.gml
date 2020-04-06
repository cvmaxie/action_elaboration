/// @description set initial sprite, grow timer
framerate = obj_manager.framerate;
grow_timer = obj_manager.grow_timer;
image_speed = framerate;
sprite_index = spr_level1
grow_in = grow_timer;
delete_me_in = 0;

purple = make_color_rgb(254, 203, 219);
parts = part_system_create();

dust = part_type_create();
part_type_shape(dust, pt_shape_pixel);
part_type_size(dust, .5, 1, .01, .01);
part_type_speed(dust, 0, 0, 0, 0.1);
part_type_life(dust, 20, 60);
part_type_color1(dust, purple);
part_type_alpha2(dust, 1.0, .75);
//part_type_orientation(spray, 0, 45, 1, 0, 0);
part_type_gravity(dust, 0.01, 270);

emitter = part_emitter_create(parts);
