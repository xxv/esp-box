use <esp_box.scad>;

body_size = [50, 42, 15];
body_round_radius = 5;

wall_thicknesses = [2, 2, 3];

*esp_box_top(body_size, body_round_radius, wall_thicknesses);
esp_box_bottom(body_size, body_round_radius, wall_thicknesses);
