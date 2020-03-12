/// @description Insert description here
// You can write your code in this editor
display_set_gui_size(display_get_width()/2, display_get_height()/2); //scale gui to game scale
display_set_gui_maximise(3, 3, 0, 0); //resize gui to fit camera
draw_set_font(scorefont); //set font

c_blorby = make_color_hsv(276, 125, 180); //blorby score color
c_blarby = make_color_hsv(57, 125, 180); //blarby score color
draw_set_halign(fa_left);
draw_text_color(10, 10, obj_blorb.points, c_blorby, c_blorby, c_blorby, c_blorby, 1); //show the score w/color
draw_set_halign(fa_right);
draw_text_color(room_width - 10, 10, obj_blarb.points, c_blarby, c_blarby, c_blarby, c_blarby, 1);