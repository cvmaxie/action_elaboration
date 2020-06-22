show_debug_message(jump_spd);

image_speed = 0; //never animate player automatically - code will change the sprite
if (keyboard_check_pressed(ord("R"))) room_restart(); //press R to restart

#region LEFT / RIGHT CONTROLS
if (!ko) { //if player hasn't been killed, it can move
    if (keyboard_check(left_control)) { //left input
        x_spd -= x_accel; //increase spd by accel each frame
        image_xscale = 1; //facing default direction
    }
    if (keyboard_check(right_control)) { //right input
        x_spd += x_accel; //decrease speed by accel each frame
        image_xscale = -1; //facing opposite of default direction
    }
}
#endregion

#region X MOVEMENT + SIDE WALL COLLISION
x += x_spd; //change x position using the x_spd
x_spd *= 0.9; //slow down each frame (after keypress)

//SIDEWAYS WALL COLLISIONS
if (x < global.player_w / 2) { //left wall collision
    x = global.player_w / 2; //put player back outside wall
    x_spd = -1 * x_spd; //bounce off wall
}

if (x > room_width - global.player_w) { //right wall collision
    x = room_width - global.player_w;
    x_spd = -1 * x_spd;
}
#endregion
if (!place_meeting(x, bbox_bottom, obj_solids)) {
    standing = false;
}
#region Y MOVEMENT + BOUNCING
var new_y; //new y pos
if (keyboard_check_released(jumpkey) && standing) { //jump on release
    if (image_index > 5) {
        image_index = 0;
    }
    standing = false;
    y_spd = jump_spd;
    audio_play_sound(boing, 1, false);
}
if (!standing) { //if not on a surface to counter gravity
    y_spd += grav; //gravity pulling down player
}
if (y_spd > 0) { //if yspeed > 0, player is going down
    image_index = 1; //show moving down sprite
    for (var dist_moved = 0; dist_moved < y_spd; dist_moved++) { //y speed is threshold for distance moved
        new_y = y + dist_moved; //move 1 pixel at a time
        var collidewith = instance_place(x, new_y, obj_solids); //identify the solid (if any) that will be in player's path
        if (collidewith != noone) { //solid is in path
            if (collidewith.object_index == obj_launcher) { //if the solid is the launcher
                image_index = 0; //show moving up sprite
                dead = false; //he is risen
                launch = true; //initiate launch code
                y_spd = 0; //stop moving for now
                y += 1; //move one pixel outside the launcher (to stop triggering collision)
                x = random_range(0 + sprite_width, room_width - sprite_width);
            } else if (!ko) { //all other bounces
                if (place_meeting(x, y, obj_platform) == false) { //he is now above so he can bouce
                    if (collidewith.object_index == obj_platform) { //if he bouce on platform
                        y_spd = 0;
                        standing = true;
                        squish = true;
                        if (collidewith.delete_me_in == 0) { //tell the platform to delete itself in 10 frames
                            collidewith.delete_me_in = 125; //set delete timer
                        }
                    } else if (bbox_bottom <= collidewith.bbox_top && !collidewith.ko && collidewith.y_spd >= 0) { //if he is bouncing on TOP of him
                        instance_create_layer(collidewith.x, collidewith.y, "Instances", obj_ink); //ink death graphic
                        collidewith.image_index = 6; //ko sprite
                        audio_play_sound(kosound, 1, false);
                        collidewith.ko = true; //he has been knocked out
                        collidewith.standing = false; //he cannot stand on platforms
                        show_debug_message("HE DIED")
                        points++; //add points to this blorby
                        collidewith.points--; //subtract points from dead blorby
                        alarm[0] = 10; //shake the screen using the alarm
                        sleep(80); //freeze the screen
                    } else if (y < room_height && bbox_bottom <= collidewith.bbox_top) {
                        standing = false;
                        y_spd = jump_spd; //BOUCE
                        image_index = 0; //show moving up sprite 
                    }
                    break;
                }
            }
        }
    }
} else { //no collision, going up
    new_y = y + y_spd; //move y normally
}
y = new_y; //always set ypos to new y
if (y <= sprite_height) { // keep them from going over top of screen
    y = sprite_height;
}
#endregion

#region SPRITE ANIMATION + JUMP SPEED
if (standing) {
    if (keyboard_check(jumpkey) && !squish) { //if on a surface to jump off
        image_speed = 1;
        jump_spd += charge;
        //create charging particle
        part_emitter_region(charging, sparkling, x - 10, x + 10, y, y + 10, ps_shape_ellipse, ps_distr_gaussian);
        part_emitter_burst(charging, sparkling, sparks, 2); //stream 5 particles every second
        if (image_index > 5) {
            image_speed = 0;
        }
    } else {
        if (!squish && image_index <= 3 && abs(x_spd) > .1) { //if not squishing and moving sideways
            if (keyboard_check(left_control) || keyboard_check(right_control)) { //walking left or right
                image_speed = .5;
                if (image_index == 3 && alarm[1] == -1) {
                    image_speed = 0;
                    alarm[1] = 7;
                }
            }
        } else if (squish) { //squish when landing on platform
            jump_spd = default_jump; //reset jump speed upon landing
            image_speed = 1;
            if (image_index > 3) {
                image_speed = 0;
                squish = false; //stop animation
            }
        } else { //standing on platform, no interactivity
            image_speed = 0;
            image_index = 3;
        }
    }
} else { //falling, no interactivity
    image_speed = 0
    if (y_spd > 0) {
        image_index = 1;
    }
}
#endregion

#region LAUNCH CODE
if (launch) { //when launch is true, initiate LAUNCH TIMER
    ko = false;
    y_spd = 0; //don't move
    launchtime++; //start counting up
    if (launchtime == 100) { //when the timer is complete
        audio_play_sound(revive, 1, false);
        jump_spd = default_jump; //reset jump speed
        y_spd = jump_spd * 2.5; //bounce HIGH
        launchtime = 0; //reset the timer
        launch = false; //no more launching
    }
}
#endregion

#region FALLING OFF
if (y >= room_height && y_spd > 0 && !dead) {
    instance_create_layer(x, room_height, "Instances", obj_ink);
    audio_play_sound(fall, 1, false);
    points--;
    jump_spd = default_jump; //reset jump speed
    dead = true;
}
#endregion