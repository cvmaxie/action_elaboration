/// @description destroy/pause after playing once
if (y < room_height) {
    instance_destroy();
} else {
    image_speed = 0;
    image_index = 3;
	y = random_range(room_height, room_height + 4);
}