include <libs/nutsnbolts/cyl_head_bolt.scad>;
include <libs/nutsnbolts/materials.scad>;
include <lcd_controller_dimensions.scad>;

module base() {
  cube(
    size=[
      lcd_controller_width,
      lcd_controller_height,
      lcd_controller_case_thickness
    ]
  );
}

module lcd_controller_screw_hole() {
  translate([0, 0, lcd_controller_case_thickness + 0.01]) hole_through(
    $fn=30,
    name="M3",
    l=lcd_controller_case_thickness + 1,
    cl=0.1,
    h=0,
    hcl=50
  );
}

module screw_riser(name = "M3", $fn = 10, h = 5) {
  translate([0, 0, h]) {
    difference() {

      hole_through(
        $fn = 50,
        name=name,
        l=0,
        cl=0.1,
        h=h,
        hcl=50
      );

      translate([0, 0, .005]) hole_through(
        $fn = 50,
        name=name,
        l=h + .01,
        cl=0.1,
        h=0,
        hcl=50
      );
    }
  }
}

module base_with_legs() {
  union() {
    difference() {
      base();
      translate(lcd_bottom_left_screw_pos) lcd_controller_screw_hole();
      translate(lcd_bottom_right_screw_pos) lcd_controller_screw_hole();
      translate(lcd_top_left_screw_pos) lcd_controller_screw_hole();
      translate(lcd_top_right_screw_pos) lcd_controller_screw_hole();
    }

    translate([0, 0, lcd_controller_case_thickness]) {
      translate(lcd_bottom_left_screw_pos) screw_riser();
      translate(lcd_bottom_right_screw_pos) screw_riser();
      translate(lcd_top_left_screw_pos) screw_riser();
      translate(lcd_top_right_screw_pos) screw_riser();
    }
  }
}

base_with_legs();

// $fn=60;
// translate([0,50, 0]) stainless() screw("M20x100", thread="modeled");
// translate([0,50,-120]) stainless() nut("M20", thread="modeled");

// translate([30,50,0]) screw("M12x60");
// translate([30,50,-80]) nut("M12");

// translate([50,50,0]) screw("M5x20");
// translate([50,50,-30]) nut("M5");

// difference() {
//   translate([-15, -15, 0]) cube([80, 30, 50]);
//   rotate([180,0,0]) nutcatch_parallel("M5", l=5);
//   translate([0, 0, 50]) hole_through(name="M5", l=50+10, cl=0.1, h=10, hcl=0.4);
//   translate([55, 0, 9]) nutcatch_sidecut("M8", l=100, clk=0.1, clh=0.1, clsl=0.1);
//   translate([55, 0, 50]) hole_through(name="M8", l=50+10, cl=0.1, h=10, hcl=0.4);
//   translate([27.5, 0, 50]) hole_threaded(name="M5", l=60);
// }
