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
    lcd_screen_edge_tolerance + lcd_enclosure_thickness,
    lcd_enclosure_thickness
  ]);
}

module side_enclosure_part() {
  union() {
    side_base_part();
    translate([-lcd_enclosure_thickness, 0, 0]) side_edge_part();
    translate([0, 0, lcd_screen_thickness + lcd_enclosure_thickness]) side_top_edge_part();
    translate([-lcd_enclosure_thickness, lcd_height_with_tolerance, 0]) side_back_rim_part();
    translate([-lcd_enclosure_thickness, 0, 0]) side_back_rim_part();
    translate([-lcd_enclosure_thickness, lcd_height_with_tolerance - lcd_screen_edge_tolerance - lcd_enclosure_thickness, lcd_screen_thickness + lcd_enclosure_thickness]) side_top_rim_part();
    translate([-lcd_enclosure_thickness, 0, lcd_enclosure_thickness + lcd_screen_thickness]) side_top_rim_part();
  }
}

module connector_bridge_side() {
  cube(size=[
    lcd_width_with_tolerance / 2,
    lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness,
    lcd_enclosure_thickness
  ]);
}

module connector_bridge_vertical_side() {
  cube(size=[
    lcd_width_with_tolerance / 2,
    lcd_enclosure_thickness,
    lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness
  ]);
}

module top_curved_bridge_part() {
  width = (lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness;
  height = lcd_screen_edge_tolerance + lcd_enclosure_thickness;
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
      [3, 4, 5],

      // bottom
      [0, 3, 1],
      [3, 4, 1],

      // square
      [1, 5, 2],
      [1, 4, 5],

      // top slanted square
      [0, 2, 5],
      [0, 3, 5]
    ]
  );
}

module full_bridge() {
  union () {
    connector_bridge_side();
    translate([0, 0, lcd_enclosure_thickness + lcd_screen_thickness]) connector_bridge_side();
    connector_bridge_vertical_side();
    translate([0, lcd_screen_edge_tolerance, 0]) connector_bridge_vertical_side();
    translate([(-lcd_width_with_tolerance / 2 / 2) - lcd_enclosure_thickness, 0, 0]) top_curved_bridge_part();
    mirror([1, 0, 0]) translate([-lcd_width_with_tolerance - lcd_enclosure_thickness - lcd_enclosure_thickness + ((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness), 0, 0]) color(c=[0, 0, 0]) top_curved_bridge_part();
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
color(c=[0, 0, 0, 0.7]) translate([
  lcd_screen_edge_tolerance,
  lcd_screen_edge_tolerance,
  lcd_enclosure_thickness
]) lcd();
