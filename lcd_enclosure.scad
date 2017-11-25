include <libs/nutsnbolts/cyl_head_bolt.scad>
include <lcd_enclosure_dimensions.scad>

module lcd() {
  difference() {
    cube(size=[lcd_screen_width, lcd_screen_height, lcd_screen_thickness]);
    translate([lcd_screen_width / 2, lcd_screen_height / 2]) linear_extrude(height=10) {
      text("LCD SCREEN");
    }
  }
}

module side_base_part() {
  cube(size=[
    lcd_width_with_tolerance / 3,
    lcd_height_with_tolerance,
    lcd_enclosure_thickness
  ]);
}

module side_edge_part() {
  cube(size=[
    lcd_enclosure_thickness,
    lcd_height_with_tolerance,
    lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness
  ]);
}

module side_top_edge_part() {
  cube(size=[
    lcd_screen_edge_tolerance,
    lcd_height_with_tolerance,
    lcd_enclosure_thickness
  ]);
}

module side_back_rim_part() {
  cube(size=[
    (lcd_width_with_tolerance / 3) + lcd_enclosure_thickness,
    lcd_enclosure_thickness,
    lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness
  ]);
}

module side_top_rim_part() {
  cube(size=[
    (lcd_width_with_tolerance / 3) + lcd_enclosure_thickness,
    lcd_screen_edge_tolerance,
    lcd_enclosure_thickness
  ]);
}

module side_enclosure_part() {
  difference() {
    union() {
      side_base_part();
      translate([-lcd_enclosure_thickness, 0, 0]) side_edge_part();
      translate([0, 0, lcd_screen_thickness + lcd_enclosure_thickness]) side_top_edge_part();
      translate([-lcd_enclosure_thickness, lcd_height_with_tolerance, 0]) side_back_rim_part();
      translate([-lcd_enclosure_thickness, 0, 0]) side_back_rim_part();
      translate([-lcd_enclosure_thickness, lcd_height_with_tolerance - lcd_screen_edge_tolerance, lcd_screen_thickness + lcd_enclosure_thickness]) side_top_rim_part();
      translate([-lcd_enclosure_thickness, 0, lcd_enclosure_thickness + lcd_screen_thickness]) side_top_rim_part();
    }

    translate([0, -(lcd_height_with_tolerance / 2), 0]) {
      translate([(lcd_width_with_tolerance / 2 / 2) + (lcd_enclosure_thickness * 2), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance * 2, h=0,  cld=0.2);
      translate([(lcd_width_with_tolerance / 2 / 2) + (lcd_enclosure_thickness * 2) - (((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness) / 2), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance * 2, h=0,  cld=0.2);
    }
  }
}

module connector_bridge_side() {
  cube(size=[
    lcd_width_with_tolerance / 2,
    (lcd_enclosure_thickness * 2) + lcd_screen_thickness,
    lcd_enclosure_thickness
  ]);
}

module connector_bridge_vertical_side() {
  cube(size=[
    lcd_width_with_tolerance / 2,
    lcd_enclosure_thickness,
    (lcd_enclosure_thickness * 2) + lcd_screen_thickness
  ]);
}

module top_curved_bridge_part() {
  width = (lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness;
  height = lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness;
  length = lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness;

  polyhedron(
    points = [
      [0, 0, 0],
      [width, 0, 0],
      [width, height, 0],
      [0, 0, length],
      [width, 0, length],
      [width, height, length]
    ],
    faces=[
      // slanted sides
      [0, 1, 2],
      [3, 5, 4],

      // bottom
      [0, 3, 4, 1],

      // square
      [1, 4, 5, 2],

      // perfect square side
      [0, 2, 5, 3]
    ]
  );
}

module full_bridge() {
  difference() {
    union () {
      connector_bridge_side();
      translate([0, 0, lcd_enclosure_thickness + lcd_screen_thickness]) connector_bridge_side();
      connector_bridge_vertical_side();
      translate([0, lcd_screen_thickness + lcd_enclosure_thickness, 0]) connector_bridge_vertical_side();
      translate([(-lcd_width_with_tolerance / 2 / 2) - lcd_enclosure_thickness, 0, 0]) top_curved_bridge_part();
      mirror([1, 0, 0]) translate([-lcd_width_with_tolerance - lcd_enclosure_thickness - lcd_enclosure_thickness + ((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness), 0, 0]) top_curved_bridge_part();
      cube(size=[
        (lcd_enclosure_thickness * 2) + lcd_screen_thickness,
        (lcd_enclosure_thickness * 2) + lcd_screen_thickness,
        (lcd_enclosure_thickness * 2) + lcd_screen_thickness
      ]);
      translate([(lcd_width_with_tolerance / 2) - lcd_screen_edge_tolerance, 0, 0]) cube(size=[
        (lcd_enclosure_thickness * 2) + lcd_screen_thickness,
        (lcd_enclosure_thickness * 2) + lcd_screen_thickness,
        (lcd_enclosure_thickness * 2) + lcd_screen_thickness
      ]);
    }
    // nut hatch
    translate([lcd_enclosure_thickness * 2 - (((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness) / 2), lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 270, 0]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
    translate([lcd_enclosure_thickness * 2 - (((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness) / 2), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=(lcd_height_with_tolerance), h=0,  cld=0.2);
    // nut hatch
    translate([lcd_enclosure_thickness * 2, lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 270, 0]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
    translate([lcd_enclosure_thickness * 2, -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance, h=0,  cld=0.2);
    // nut hatch
    translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2), lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 270, 0]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
    translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance, h=0, cld=0.2);
    // nut hatch
    translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2) + (((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness) / 2), lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 270, 0]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
    translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2) + (((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness) / 2), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance, h=0, cld=0.2);
  }
}

// Left Side Enclosure
color(c=[0, 1, 1, 0.7]) side_enclosure_part();

// Right Side Enclosure
color(c=[1, 0, 1, 0.7]) translate([lcd_width_with_tolerance, 0, 0]) mirror([1,0,0]) side_enclosure_part();

// Full Bridge Top
color(c=[0, 0, 0.5, 0.7]) translate([
  (lcd_width_with_tolerance / 2) - (lcd_width_with_tolerance / 2 / 2),
  lcd_height_with_tolerance + lcd_enclosure_thickness,
  0
]) full_bridge();

// Full Bridge Bottom
color(c=[0, 0.5, 0, 0.7]) mirror([0, 1, 0]) translate([
  (lcd_width_with_tolerance / 2) - (lcd_width_with_tolerance / 2 / 2),
  0,
  0
]) full_bridge();

// LCD for debugging
// color(c=[0, 0, 0, 0.7]) translate([
//   lcd_screen_edge_tolerance,
//   lcd_screen_edge_tolerance,
//   lcd_enclosure_thickness
// ]) lcd();
