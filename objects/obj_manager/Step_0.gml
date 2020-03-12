/// @description spawning new platforms
if (platnum < plat_amt) { //while there are less than the intended number of platforms
    for (var i = 0; i < plat_amt; i++) { //SPAWN EACH PLATFORM
        var new_x = random_range(0 + plat_w / 2, room_width - plat_w / 2); //NEW X: random x position for each platform
        var new_y = random_range(0 + buffer, room_height - buffer / 2); //NEW Y: random y position within designated vertical threshold
        if (collision_rectangle(new_x - plat_w - padding, new_y - plat_h - padding, new_x + plat_w + padding, new_y + plat_h + padding, obj_platform, false, false) == noone) {
            delaytime--; //start delay timer for spawning platform
            if (delaytime == 0) { //when timer is over
                instance_create_layer(new_x, new_y, "Instances", obj_platform); //create each new platform
                delaytime = spawndelay; //reset timer
            }
        }
    }
}