include <ns_board_dimensions.scad>;

module base() {
  cube(
    size=[
      ns_board_width,
      ns_board_height,
      ns_board_thickness
    ]
  );
}

module hole_puncher(height = 10) {
  cylinder(
    $fn = 25,
    h = height,
    r = screw_hole_clearance / 2,
    center = true
  );
}

module hole_tube(height = 10) {
  cylinder(
    $fn = 25,
    h = height,
    r = screw_standoff_width / 2,
    center = true
  );
}

module screw_hole_punchers() {
  translate(bottom_left_screw_center_origin) hole_puncher();
  translate(bottom_right_screw_center_origin) hole_puncher();
  translate(top_left_screw_center_origin) hole_puncher();
  translate(top_right_screw_center_origin) hole_puncher();
}

module base_with_holes() {
  difference() {
    base();
    screw_hole_punchers();
  }
}

module standoff(height = 10) {
  translate([0, 0, height / 2]) difference() {
    hole_tube(height);
    hole_puncher(height + 1);
  }
}

module screw_hole_standoffs(height = 10) {
  translate(concat(bottom_left_screw_center_origin, ns_board_thickness)) standoff();
  translate(concat(bottom_right_screw_center_origin, ns_board_thickness)) standoff();
  translate(concat(top_left_screw_center_origin, ns_board_thickness)) standoff();
  translate(concat(top_right_screw_center_origin, ns_board_thickness)) standoff();
}

module base_with_legs() {
  union() {
    base_with_holes();
    screw_hole_standoffs();
  }
}

// module round_corner(size = 3, height=10, bottom=true, left=true) {
//   half = size / 2;
//   slice_size = 0.1 + half;
//   difference() {
//     difference() {
//       cube(size=[size, size, height]);
//       translate([half, half]) cylinder($fn = 50, r = half, h = height + .1);
//     }
//     translate([-0.0001 + half, -0.0001]) cube(size=[slice_size, slice_size, height + .2]);
//     translate([-0.0001, half]) cube(size=[slice_size, slice_size, height + .2]);
//     translate([half, half + 0.0001]) cube(size=[slice_size, slice_size, height + .2]);
//   }
// }

// difference() {
//   round_corner(height=10.1);
//   cube(size=[1.6, 1.6, 10]);
// }

base_with_legs();
