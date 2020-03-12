/// @camera behavior
//keep in mind that camera origin is in the top left corner
x = 0; //camera is width of screen, x pos will always stay the same
cutoff = room_height * .66 //cutoff point - camera favors higher player
//Y POSITION
var cheight = camera_get_view_height(view_camera[0]); //get height of camera
//average between players
if (obj_blorb.y >= obj_blarb.y) { //if player 2 is higher
    if (obj_blorb.y >= cutoff) { //at a certain point, don't follow the lower player
        y = lerp(cutoff, obj_blarb.y, .5); //lerp between higher player and cutoff point
    } else {
        y = lerp(obj_blorb.y, obj_blarb.y, .5); //cam is below p2 and above p1
    }
    if (camshake) {
        y = lerp(obj_blorb.y, obj_blarb.y, .5) - shake;
    }
} else if (obj_blarb.y > obj_blorb.y) { //if player 1 is higher
    if (obj_blarb.y >= cutoff) {
        y = lerp(cutoff, obj_blorb.y, .5);
    } else {
        y = lerp(obj_blarb.y, obj_blorb.y, .5); //cam is below p1 and above p2
    }
    if (camshake) {
        y = lerp(obj_blarb.y, obj_blorb.y, .5) - shake;
    }
}

if (y > room_height - cheight / 2) { //if camera touches bottom
    y = room_height - cheight / 2; //don't go below the room
}

camera_y = y - cheight / 2; //camera's position is offset from this object
camera_set_view_pos(view_camera[0], 0, camera_y); //set engine's camera to follow this object

#region KO SHAKE
show_debug_message(shake);
if (camshake && !goback) { //if camshake (happens when a player gets ko'ed)
    shake += 1.5; //add 1 to "shake intensity"
    if (shake >= 25) { //when the "shake intensity" is > 25
        goback = true; //start subtracting from shake intensity
    }
}
if (goback) { //subtracting from shake intensity
    shake -= 1.5;
    if (shake <= 0) { //if subtracting from shake intensity is done
        camshake = false; //no more shaking
        goback = false; //no more going back
    }
}
#endregion