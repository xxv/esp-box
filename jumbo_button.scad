use <shapes.scad>;

$fs=0.5;
$fa=0.5;

min_height = 35;
body_size = [75, 75, min_height + 8];
body_round_radius = 5;

opening = [56, 56.2];

top_wall_thickness = 6;
wall_thickness = 2;
bottom_wall_thickness = 3;

inner_body = body_size - [wall_thickness, wall_thickness, top_wall_thickness];

m3_heatset_depth = 4.5;
m3_heatset_dia = 4;

m3_button_head_depth = 2;
m3_button_head_dia = 6;
m3_screw_dia = 3.3;

d1_mini_board = [26, 35, 1.1];
board_lift = 4;

function center_xy(a, b) = [(a.x - b.x)/2, (a.y - b.y)/2, 0];
function center_x(a, b) = [(a.x - b.x)/2, 0, 0];
function center_y(a, b) = [0, (a.y - b.y)/2, 0];
function xy(a) = [a.x, a.y, 0];
function xy_z(a, z) = [a.x, a.y, z];

smidge = 0.01;

//intersection() { union() {
translate([0, wall_thickness, board_lift])
  translate(center_x(body_size, d1_mini_board))
    d1_mini_mockup();

jumbo_button_housing_top();
translate([0, 0, -bottom_wall_thickness])
  jumbo_button_housing_bottom();

button_volume = xy_z(opening, min_height);
#translate([0, 0, body_size.z - button_volume.z])
translate(center_xy(body_size, button_volume))
  cube(button_volume);

//  } cube([body_size.x/2, 100, 100]); }


module jumbo_button_housing_bottom() {
  difference() {
    rounded_cube(xy_z(body_size, bottom_wall_thickness), body_round_radius);

    translate(xy(body_size)/2)
      for (rot = [0 : 90 : 360 - 1])
        rotate(rot)
          translate(xy(body_size)/2)
            translate([-body_round_radius, -body_round_radius, -smidge]) {
              cylinder(d=m3_button_head_dia, h=m3_button_head_depth);
              cylinder(d=m3_screw_dia, h=6);
            }
  }

  brace = 5;
  wall = 2;
  board_lip = d1_mini_board.z + 0.5;
  board_extra = 0.5;

  translate(center_x(body_size, d1_mini_board))
    translate([0, wall_thickness, bottom_wall_thickness]) {
      translate([-wall, 0])
        cube([d1_mini_board.x + 2, brace + wall, board_lift]);
        translate([0, 0, board_lift]) {
          for (x = [-wall, d1_mini_board.x - wall])
            translate([x, 0])
              cube([wall, brace + 1, x < 0 ? board_lip : board_lip - 0.5]);
        }
        difference() {
          translate([-wall, d1_mini_board.y - brace])
            cube([d1_mini_board.x + wall * 2, brace + wall, board_lift + board_lip]);
          translate([0, 0, board_lift]) {
            cube(xy_z(d1_mini_board, 3) + [0, board_extra, 0]);
            cutout = [18, brace + board_extra, 1];
            translate(center_x(d1_mini_board, cutout) + [0, d1_mini_board.y - brace - smidge, -cutout.z])
              cube(cutout + [0, smidge, smidge]);
          }
        }
        translate([-wall, d1_mini_board.y - brace, board_lift + board_lip])
          cube([d1_mini_board.x + wall * 2, brace + wall, 2]);
    }
}

module d1_mini_mockup() {
  board = d1_mini_board;
  usb_port = [7.5, 5, 2];
  wifi = [12, 15, 3.1];

  translate([0, 0, 0]) {
    difference() {
      color("blue")
        cube(board);
      translate([board.x - 2 + smidge, -smidge, -smidge])
        cube([2, 7, 2]);
    }

  color("silver")
    translate([0, 0, board.z])
      translate(center_x(board, usb_port))
        cube(usb_port);
    }

  color("silver")
      translate([0, 0, -wifi.z])
      translate(center_xy(board, wifi))
        cube(wifi);
}

module jumbo_button_housing_top() {

  difference() {
    rounded_cube(body_size, body_round_radius);

    usb_cord_cutout = [12, wall_thickness * 2, 10];
    translate([0, -smidge, 0])
    translate(center_x(body_size, usb_cord_cutout))
      cube(usb_cord_cutout);

    difference() {
      translate([0, 0, -smidge])
        translate(center_xy(body_size, inner_body))
          rounded_cube(inner_body + [0, 0, smidge], body_round_radius);

      translate(xy(body_size)/2)
        for (rot = [0 : 90 : 360 - 1])
          rotate(rot)
            translate(xy(body_size)/2)
              rotate([-25, 0, -45])
                translate([0, -body_round_radius - 1, -8])
                  cylinder(r=body_round_radius, h=30);
    }

    translate(xy(body_size)/2)
      for (rot = [0 : 90 : 360 - 1])
        rotate(rot)
          translate(xy(body_size)/2)
            translate([-body_round_radius, -body_round_radius, -smidge])
              cylinder(d=m3_heatset_dia, h=m3_heatset_depth);

    translate(center_xy(body_size, opening))
      translate([0, 0, smidge * 2])
        cube([opening.x, opening.y, body_size.z]);
  }
}

