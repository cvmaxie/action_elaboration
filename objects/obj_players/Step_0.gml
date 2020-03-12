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
if (place_empty(x, bbox_bottom, obj_solids)) { standing = false;}
#region Y MOVEMENT + BOUNCING
var new_y; //new y pos
                    if (keyboard_check_pressed(jumpkey)) {
						standing = false;
                        y_spd = jump_spd;
                        //audio_play_sound(boing, 1, false);
                    }
if (!standing) {
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
            } else { //all other bounces
                if (place_meeting(x, y, collidewith) == false && ko == false) { //he is now above so he can bouce



                    if (collidewith.object_index == obj_platform) { //if he bouce on platform
                        y_spd = 0;
                        standing = true;
                        collidewith.delete = true;
                    } else {
						standing = false;
                        y_spd = jump_spd; //BOUCE
                        image_index = 0; //show moving up sprite 
                    }


                    break; //stop loop (stop changing new_y after a condition is met)
                }
            }
        }
    }
} else { //no collision
    new_y = y + y_spd; //move y normally
}
y = new_y; //always set ypos to new y

if (y <= sprite_height) { // keep them from going over top of screen
    y = sprite_height + 1;
}
#endregion

#region LAUNCH CODE
if (launch) { //when launch is true, initiate LAUNCH TIMER
    ko = false;
    y_spd = 0; //don't move
    launchtime++; //start counting up
    if (launchtime == 100) { //when the timer is complete
        //audio_play_sound(revive, 1, false);
        y_spd = jump_spd * 1.75; //bounce HIGH
        launchtime = 0; //reset the timer
        launch = false; //no more launching
    }
}
#endregion

#region PLAYER K.O.
with(obj_blorb) { //acting as BLORB
    if (ko) {
        image_index = 2;
    }
    if (place_meeting(x, y, obj_blarb) && !ko) { //colliding with blarb
        if (bbox_bottom <= obj_blarb.bbox_top && !obj_blarb.ko) { //if blorb's butt is above blarb's head and hes still alive
            instance_create_layer(obj_blarb.x, obj_blarb.y, "Instances", obj_ink); //make an ink where blarb died
            audio_play_sound(kosound, 1, false);;
            obj_blarb.ko = true; //blarb loses control
            show_debug_message("BLARBY DIED")
            points++; //add to his points
            camera.shake = 0; //reset shake intensity before starting new camera shake
            camera.camshake = true; //start new camera shake
        }
    }
}

with(obj_blarb) { //acting as BLARB
    if (ko) {
        image_index = 2;
    }
    if (place_meeting(x, y, obj_blorb) && !ko) { //colliding with blorb
        if (bbox_bottom <= obj_blorb.bbox_top && !obj_blorb.ko) {
            instance_create_layer(obj_blorb.x, obj_blorb.y, "Instances", obj_ink);
            audio_play_sound(kosound, 1, false);
            obj_blorb.ko = true;
            show_debug_message("BLORBY DIED")
            points++;
            camera.shake = 0;
            camera.camshake = true;
        }
    }
}
#endregion

#region FALLING OFF
if (y >= room_height && y_spd > 0 && !dead) {
    instance_create_layer(x, room_height, "Instances", obj_ink);
    //audio_play_sound(fall, 1, false);
    points--;
    dead = true;
}
#endregion