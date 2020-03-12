/// @description growing and disappearing platforms
//DELETING PLATFORMS
//delete_me_in gets set to a positive number when the player bounces on platform
if (delete_me_in > 0) { //set a latency timer for deleting collided platform
	if (delete_me_in < 50) {
    image_index = 4;
    image_speed = framerate;
	}
    if (image_index > 5) {
        image_speed = 0;
    }
    delete_me_in -= 1; //count down each frame
    if (delete_me_in == 0) { //when timer is complete
        instance_destroy(); //destroy platform
    }
}

//GROWING AND CHANGING PLATFORM SPRITE
if (grow_in > 0) { //if the grow timer isn't done
    grow_in--; //count down the timer
}

if (grow_in == 0) { //when the grow timer is done
    if (sprite_index == spr_level1) { //level 1 > level 2
        grow_in = grow_timer; //reset timer
        image_speed = framerate;
        sprite_index = spr_level2 //change to next sprite
        image_index = 1; //start at first frame of animation
    } else if (sprite_index == spr_level2) { //level 2 > level 3
        grow_in = grow_timer;
        image_speed = framerate;
        sprite_index = spr_level3
        image_index = 1;
    } else if (sprite_index == spr_level3) { //level 3 > level 4
        image_speed = framerate;
        sprite_index = spr_level4;
        image_index = 1;
    }
}

//PLAYING PLATFORM ANIMATION W/O LOOP
if (image_index > 2) {
    image_speed = 0;
}