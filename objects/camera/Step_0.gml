#region CAMERA SHAKE
var players = instance_number(obj_players); //average y position between plagers
var ypos = 0;
for (i = 0; i < players; i++) {
    var thisplayer = instance_find(obj_players, i);
    if (!thisplayer.ko) {
        ypos += thisplayer.y - 0.5 * cheight; //center alive players
    } else {
        ypos += room_height - cheight; //register dead players as bottom of room
    }
}
if (players > 0) {
    ypos /= players; //divide averager by # of players
}
x = 0;
y = lerp(y, ypos, 0.4); //lerp for smooth movement

cam_y = camera_get_view_y(view_camera[0]); //spring camera to target using the spring formula
cam_vel_y += 0.05 * (y - cam_y);
cam_vel_y *= 0.8
cam_y += cam_vel_y;

cam_y = max(cam_y, 0);//clamp position to room boundaries
cam_y = min(cam_y, room_height - cheight);

//set the position of the camera
camera_set_view_pos(view_camera[0], x, cam_y);
#endregion

#region CAMERA SHAKE
with(obj_players) {
    if (alarm[0] > 0) { //shaking the screen using Alarm0
        var camx = camera_get_view_x(view_camera[0]); //get old position
        var camy = camera_get_view_y(view_camera[0]);

        var newx = camx + irandom_range(-alarm[0] * 2, alarm[0] * 2); //create new position using alarm
        var newy = camy + irandom_range(-alarm[0] * 2, alarm[0] * 2);

        camera_set_view_pos(view_camera[0], newx, newy); //set new position using alarm
    }
}
#endregion