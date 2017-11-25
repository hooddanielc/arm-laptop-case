include <libs/nutsnbolts/cyl_head_bolt.scad>
/**
 * Origin is next to SD card bottom, left
 */
module case_and_rim(
  front_rim = true,
  back_rim = true,
  case_thickness = 2.5,
  screw_hole_clearance = 2.75,
  screw_head_width = 5,
  screw_standoff_width = 5,
  base_without_legs = true,
  base_legs = true,
  leg_height = 5,
  rim_height = 16,
  socket_hole_relief = 2
) {

  ns_board_width = 85;
  ns_board_height = 54;

  // Screw Hole Position
  bottom_left_screw_center_origin = [4, 18.5];
  bottom_right_screw_center_origin = [81, 18.5];
  top_left_screw_center_origin = [4, 50];
  top_right_screw_center_origin = [81, 50];


  module nutcatch_m25() {
    rotate([180, 0, 180]) difference() {
      translate([0, 0, case_thickness / -2]) cube(size=[6, 10, case_thickness * 2], center=true);
      {
        nutcatch_sidecut("M2.5", l=100, clk=0.1, clh=0.1, clsl=0.1);
        hole_through(name="M2.5", l=50+5, cl=0.1, h=0, hcl=0.4);
      }
    }
  }

  module reversenutcatch_m25() {
    rotate([180, 0, 180]) {
      nutcatch_sidecut("M2.5", l=100, clk=0.1, clh=0.1, clsl=0.1);
      hole_through(name="M2.5", l=50+5, cl=0.1, h=0, hcl=0.4);
    }
  }

  module base() {
    translate([0, -case_thickness, 0]) cube(
      size=[
        ns_board_width, // + case_thickness * 2,
        ns_board_height + case_thickness * 2,
        case_thickness
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
    difference() {
      union() {
        cylinder(
          $fn = 25,
          h = height,
          r = screw_standoff_width / 2,
          center = true
        );
        translate([0, 0, -height / 2]) nutcatch_m25();
      }
      translate([0, 0, -height / 2]) reversenutcatch_m25();
    }
  }

  module screw_hole_punchers() {
    translate(bottom_left_screw_center_origin) hole_puncher();
    translate(bottom_right_screw_center_origin) hole_puncher();
    translate(top_left_screw_center_origin) hole_puncher();
    translate(top_right_screw_center_origin) hole_puncher();
  }

  module base_with_holes() {
    union() {
      difference() {
        base();
        screw_hole_punchers();
      }
    }
  }

  module standoff(height = 10) {
    translate([0, 0, height / 2]) difference() {
      hole_tube(height = height);
      hole_puncher(height = height + 1);
    }
  }

  module screw_hole_standoffs(height = 10) {
    translate(concat(bottom_left_screw_center_origin, case_thickness)) standoff(height=height);
    translate(concat(bottom_right_screw_center_origin, case_thickness)) standoff(height=height);
    translate(concat(top_left_screw_center_origin, case_thickness)) standoff(height=height);
    translate(concat(top_right_screw_center_origin, case_thickness)) standoff(height=height);
  }

  module base_with_legs() {
    union() {
      base_with_holes();
      screw_hole_standoffs(height = leg_height);
    }
  }

  module rims_with_holes() {
    r = socket_hole_relief; /* connector relief */
    t = case_thickness; /* thickness */
    h = rim_height; /* height */
    b = leg_height; /* bottom clearance */

    difference() {
      union() {
        /* front face */

        if (front_rim) {
          difference() {
            translate([0, -t, -b]) {
              cube([85, t, h]);
            }
            union() {
              translate([1 - (r/2), -t, 1 - (r/2)]) {
                cube([12 + r, 15, 1.5 + r]);
              }
              translate([17.5 - (r/2), -t, 2.5 - (r/2)]) {
                cube([14.5 + r, 9, 5 + r]);
              }
              translate([37.75 - (r/2), -t, 1 - (r/2)]) {
                cube([7.5 + r, 5.25 , 3 + r]);
              }
              translate([49.5 - (r/2), -t, 2 - (r/2)]) {
                cube([14 + r, 14 , 7 + r]);
              }
              translate([69.25 - (r/2), -t, 2 - (r/2)]) {
                cube([14 + r, 14 , 7 + r]);
              }
            }
          }
        }

        if (back_rim) {
          /* back face */
          difference() {
            translate([0, 54, -b]) {
              cube([85, t, h]);
            }
            translate([69 - (r/2), 42 + t, 1 - (r/2)]) {
              cube([9 + r, 12 , 6 + r]);
            }
          }
        }
      }

      translate([-.5, -.5, 0]) {
        cube([85+1, 54+1, h]);
      }

    }
  }

  translate([0, 0, case_thickness + leg_height]) rims_with_holes();
  base_with_legs();
}

case_and_rim(back_rim=false);
