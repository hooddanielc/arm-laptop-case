include <libs/nutsnbolts/cyl_head_bolt.scad>
use <ns_board.scad>
use <lcd_controller.scad>

module lcd_enclosure(
  lcd_screen_diagonal_size = 260,
  lcd_screen_edge_tolerance = 9,
  lcd_screen_thickness = 6,
  lcd_enclosure_thickness = 2.5,
  lcd_screen_ratio_x = 16,
  lcd_screen_ratio_y = 10
) {
  // calculated sizes
  lcd_screen_ratio_diagonal = sqrt(pow(lcd_screen_ratio_x, 2) + pow(lcd_screen_ratio_y, 2));
  lcd_screen_width = lcd_screen_ratio_x / lcd_screen_ratio_diagonal * lcd_screen_diagonal_size;
  lcd_screen_height = lcd_screen_ratio_y / lcd_screen_ratio_diagonal * lcd_screen_diagonal_size;

  echo("Screen Width: ", lcd_screen_width);
  echo("Screen Height: ", lcd_screen_height);

  lcd_width_with_tolerance = lcd_screen_width + (lcd_screen_edge_tolerance * 2);
  lcd_height_with_tolerance = lcd_screen_height + (lcd_screen_edge_tolerance * 2);

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

  module side_edge_part(vertical_spacing=lcd_screen_thickness) {
    cube(size=[
      lcd_enclosure_thickness,
      lcd_height_with_tolerance,
      lcd_enclosure_thickness + vertical_spacing + lcd_enclosure_thickness
    ]);
  }

  module side_top_edge_part() {
    cube(size=[
      lcd_screen_edge_tolerance,
      lcd_height_with_tolerance,
      lcd_enclosure_thickness
    ]);
  }

  module side_back_rim_part(vertical_spacing=lcd_screen_thickness) {
    cube(size=[
      (lcd_width_with_tolerance / 3) + lcd_enclosure_thickness,
      lcd_enclosure_thickness,
      lcd_enclosure_thickness + vertical_spacing + lcd_enclosure_thickness
    ]);
  }

  module side_top_rim_part() {
    cube(size=[
      (lcd_width_with_tolerance / 3) + lcd_enclosure_thickness,
      lcd_screen_edge_tolerance,
      lcd_enclosure_thickness
    ]);
  }

  module side_bridge_face() {
    cube(size=[
      lcd_enclosure_thickness + lcd_screen_edge_tolerance,
      (lcd_height_with_tolerance / 2) + lcd_enclosure_thickness,
      lcd_enclosure_thickness
    ]);
  }

  module side_bridge_face_vertical(vertical_spacing=lcd_screen_thickness) {
    cube(size=[
      lcd_enclosure_thickness,
      (lcd_height_with_tolerance / 2) + lcd_enclosure_thickness,
      (lcd_enclosure_thickness * 2) + vertical_spacing
    ]);
  }

  module side_bridge_curve(vertical_spacing=lcd_screen_thickness) {
    width = lcd_enclosure_thickness + lcd_screen_edge_tolerance;
    height = lcd_height_with_tolerance / 4;
    length = lcd_enclosure_thickness + vertical_spacing + lcd_enclosure_thickness;

    polyhedron(
      points = [
        [0, 0, 0],
        [-width, height, 0],
        [0, height, 0],
        [0, 0, length],
        [-width, height, length],
        [0, height, length],
      ],
      faces=[
        // triangle sides
        [2, 1, 0],
        [3, 4, 5],

        // bottom
        [0, 3, 5, 2],

        // perfect square side
        [2, 5, 4, 1],

        // slope
        [0, 1, 4, 3]
      ]
    );
  }

  module side_enclosure_part(vertical_spacing=lcd_screen_thickness, hollow_base=false, hollow=false, rims=true, use_less_support=false) {
    difference() {
      union() {
        side_base_part();
        translate([-lcd_enclosure_thickness, 0, 0]) side_edge_part(vertical_spacing=vertical_spacing);
        translate([-lcd_enclosure_thickness, lcd_height_with_tolerance, 0]) side_back_rim_part(vertical_spacing=vertical_spacing);
        translate([-lcd_enclosure_thickness, 0, 0]) side_back_rim_part(vertical_spacing=vertical_spacing);
        
        if (rims) {
          translate([0, 0, vertical_spacing + lcd_enclosure_thickness]) side_top_edge_part(vertical_spacing=vertical_spacing);
          translate([-lcd_enclosure_thickness, lcd_height_with_tolerance - lcd_screen_edge_tolerance, vertical_spacing + lcd_enclosure_thickness]) side_top_rim_part(vertical_spacing=vertical_spacing);
          translate([-lcd_enclosure_thickness, 0, lcd_enclosure_thickness + vertical_spacing]) side_top_rim_part(vertical_spacing=vertical_spacing);

          // supports bottom
          translate([0, lcd_enclosure_thickness + lcd_screen_thickness + 0.2, 0]) cube(size=[(lcd_width_with_tolerance / 3), 0.2, lcd_enclosure_thickness * 2 + lcd_screen_thickness]);
          for (i = [1:1:8]) {
            translate([lcd_screen_edge_tolerance * i, 0, 0]) cube(size = [0.2, lcd_screen_edge_tolerance, lcd_enclosure_thickness * 2 + lcd_screen_thickness]);
          }
          translate([(lcd_width_with_tolerance / 3) - 0.2, 0, 0]) cube(size = [0.2, lcd_screen_edge_tolerance, lcd_enclosure_thickness * 2 + lcd_screen_thickness]);

          // supports top
          translate([0, lcd_screen_height + lcd_screen_edge_tolerance + .3, 0]) {
            translate([0, lcd_enclosure_thickness + lcd_screen_thickness + 0.2 - lcd_screen_edge_tolerance, 0]) cube(size=[(lcd_width_with_tolerance / 3), 0.2, lcd_enclosure_thickness * 2 + lcd_screen_thickness]);
            for (i = [1:1:8]) {
              translate([lcd_screen_edge_tolerance * i, 0, 0]) cube(size = [0.2, lcd_screen_edge_tolerance, lcd_enclosure_thickness * 2 + lcd_screen_thickness]);
            }
            translate([(lcd_width_with_tolerance / 3) - 0.2, 0, 0]) cube(size = [0.2, lcd_screen_edge_tolerance, lcd_enclosure_thickness * 2 + lcd_screen_thickness]);
          }

          // support sides
          for (i = [0:1:15]) {
            translate([0, lcd_screen_edge_tolerance * (2 + i), lcd_enclosure_thickness]) cube(size = [lcd_screen_edge_tolerance, 0.2, lcd_screen_thickness]);
          }
          translate([lcd_screen_edge_tolerance - 0.2, 0, lcd_enclosure_thickness]) cube(size = [0.2, lcd_height_with_tolerance, lcd_screen_thickness]);
        }
        
        translate([-(lcd_enclosure_thickness * 2) - (lcd_screen_edge_tolerance), lcd_height_with_tolerance / 4, lcd_enclosure_thickness + vertical_spacing]) side_bridge_face(vertical_spacing=vertical_spacing);
        translate([-(lcd_enclosure_thickness * 2) - (lcd_screen_edge_tolerance), lcd_height_with_tolerance / 4, 0]) side_bridge_face(vertical_spacing=vertical_spacing);
        translate([-(lcd_enclosure_thickness * 2) - (lcd_screen_edge_tolerance), lcd_height_with_tolerance / 4, 0]) side_bridge_face_vertical(vertical_spacing=vertical_spacing);

        // side slopes
        translate([-lcd_enclosure_thickness, 0, 0]) side_bridge_curve(vertical_spacing=vertical_spacing);
        mirror([0, 1, 0]) translate([-lcd_enclosure_thickness, -lcd_height_with_tolerance - lcd_enclosure_thickness, 0]) side_bridge_curve(vertical_spacing=vertical_spacing);
      
        //todo
        //translate([]) rotate([0, 180, 0]) nuthatch_and_hole();
      }

      translate([0, -(lcd_height_with_tolerance / 2), 0]) {
        translate([(lcd_width_with_tolerance / 2 / 2) + (lcd_enclosure_thickness * 2), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + vertical_spacing + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance * 2, h=0,  cld=0.2);
        translate([(lcd_width_with_tolerance / 2 / 2) + (lcd_enclosure_thickness * 2) - (((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness) / 2), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + vertical_spacing + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance * 2, h=0,  cld=0.2);
      }

      if (hollow_base) {
        translate([
          0,
          lcd_enclosure_thickness,
          -lcd_enclosure_thickness
        ]) cube(size=[lcd_width_with_tolerance, lcd_height_with_tolerance - lcd_enclosure_thickness, lcd_enclosure_thickness * 4 + vertical_spacing]);
      }

      if (hollow) {
        translate([
          lcd_screen_edge_tolerance,
          lcd_screen_edge_tolerance,
          0
        ]) cube(size=[lcd_screen_width, lcd_screen_height, lcd_enclosure_thickness + vertical_spacing]);
      }

      if (use_less_support) {
        translate([
          -lcd_screen_edge_tolerance - lcd_enclosure_thickness,
          lcd_screen_height / 4,
          -lcd_enclosure_thickness
        ]) cube(size=[
          lcd_screen_edge_tolerance + lcd_enclosure_thickness,
          lcd_screen_height / 2,
          lcd_enclosure_thickness * 4 + vertical_spacing
        ]);
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

  module nuthatch_and_hole() {
    nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
    translate([0, 0, lcd_width_with_tolerance]) hole_through(name="M3", l=lcd_width_with_tolerance * 2, h=0,  cld=0.2);
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
        translate([lcd_width_with_tolerance / 10, 0, 0]) cube(size=[
          (lcd_enclosure_thickness * 2) + lcd_screen_thickness,
          (lcd_enclosure_thickness * 2) + lcd_screen_thickness,
          (lcd_enclosure_thickness * 2) + lcd_screen_thickness
        ]);
        translate([(lcd_width_with_tolerance / 2) - ((lcd_enclosure_thickness * 2) + lcd_screen_thickness), 0, 0]) cube(size=[
          (lcd_enclosure_thickness * 2) + lcd_screen_thickness,
          (lcd_enclosure_thickness * 2) + lcd_screen_thickness,
          (lcd_enclosure_thickness * 2) + lcd_screen_thickness
        ]);
        translate([(lcd_width_with_tolerance / 2) - ((lcd_enclosure_thickness * 2) + lcd_screen_thickness) - (lcd_width_with_tolerance / 10), 0, 0]) cube(size=[
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
      // nuthatch
      translate([lcd_enclosure_thickness * 2 + (lcd_width_with_tolerance / 10), lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 270, 0]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
      translate([lcd_enclosure_thickness * 2 + (lcd_width_with_tolerance / 10), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance, h=0,  cld=0.2);

      // nuthatch
      translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2), lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 270, 0]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
      translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance, h=0, cld=0.2);
      // nut hatch
      translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2) - ((lcd_width_with_tolerance / 10)), lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 270, 0]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
      translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2) - ((lcd_width_with_tolerance / 10)), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance, h=0, cld=0.2);
      // nut hatch
      translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2) + (((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness) / 2), lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 270, 0]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
      translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2) + (((lcd_width_with_tolerance / 2 / 2) + lcd_enclosure_thickness) / 2), -lcd_enclosure_thickness, ((lcd_enclosure_thickness + lcd_screen_thickness + lcd_enclosure_thickness) / 2) + .1]) rotate([90, 0, 0]) hole_through(name="M3", l=lcd_height_with_tolerance, h=0, cld=0.2);
      // nut hatch
      translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2) - ((lcd_width_with_tolerance / 10)), ((lcd_enclosure_thickness) + lcd_screen_edge_tolerance) / 2, lcd_enclosure_thickness * 2]) rotate([0, 0, 90]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
      translate([(lcd_width_with_tolerance / 2) - (lcd_enclosure_thickness * 2) - ((lcd_width_with_tolerance / 10)), ((lcd_enclosure_thickness) + lcd_screen_edge_tolerance) / 2, lcd_enclosure_thickness * 3 + lcd_screen_thickness]) hole_through(name="M3", l=lcd_height_with_tolerance, h=0,  cld=0.2);
      // nuthatch 
      translate([lcd_enclosure_thickness * 2 + (lcd_width_with_tolerance / 10), ((lcd_enclosure_thickness) + lcd_screen_edge_tolerance) / 2, lcd_enclosure_thickness * 2]) rotate([0, 0, 90]) nutcatch_sidecut("M3", $fn=40, l=100, clk=0.5, clh=0.5, clsl=0.5);
      translate([lcd_enclosure_thickness * 2 + (lcd_width_with_tolerance / 10), ((lcd_enclosure_thickness) + lcd_screen_edge_tolerance) / 2, lcd_enclosure_thickness * 3 + lcd_screen_thickness]) hole_through(name="M3", l=lcd_height_with_tolerance, h=0,  cld=0.2);

    }
  }

  module triple_stack_ns_mount() {
    union() {
      difference() {
        union() {
          translate([0, 0, -30]) side_enclosure_part(vertical_spacing=lcd_screen_thickness, rims=false);
          translate([0, 0, -30 + (lcd_enclosure_thickness * 2) + lcd_screen_thickness ]) side_enclosure_part(vertical_spacing=lcd_screen_thickness, rims=false, hollow_base=true);
          translate([0, 0, -30 + (((lcd_enclosure_thickness * 2) + lcd_screen_thickness) * 2) ]) side_enclosure_part(vertical_spacing=lcd_screen_thickness, rims=false, hollow_base=true);
        }
        translate([
          -lcd_enclosure_thickness - lcd_screen_edge_tolerance,
          (lcd_height_with_tolerance / 2) + (85 + lcd_enclosure_thickness) - ((85 + lcd_enclosure_thickness) / 2),
          -30
        ]) rotate([0, 0, 270]) translate([0, -lcd_enclosure_thickness, 0]) cube(size=[85, 54 + lcd_enclosure_thickness + lcd_enclosure_thickness, 40]);
      }
      translate([
        0.7 + -lcd_enclosure_thickness - lcd_screen_edge_tolerance,
        (lcd_height_with_tolerance / 2) + (85 + lcd_enclosure_thickness) - ((85 + lcd_enclosure_thickness) / 2),
        -30
      ]) rotate([0, 0, 270]) {
        case_and_rim(leg_height = 10, case_thickness = lcd_enclosure_thickness, back_rim=false, rim_height=30.5);
      }
    }
  }

  module triple_stack_lcd_controller_mount() {
    lcd_controller_width = 90.57797;
    lcd_controller_height = 65.60828;
    lcd_controller_relief = 0.5;
    w = lcd_controller_width + (lcd_controller_relief * 2);
    h = lcd_controller_height + (lcd_controller_relief * 2);

    union() {
      difference() {
        union() {
          translate([0, 0, -30]) side_enclosure_part(vertical_spacing=lcd_screen_thickness, rims=false);
          translate([0, 0, -30 + (lcd_enclosure_thickness * 2) + lcd_screen_thickness ]) side_enclosure_part(vertical_spacing=lcd_screen_thickness, rims=false, hollow_base=true);
          translate([0, 0, -30 + (((lcd_enclosure_thickness * 2) + lcd_screen_thickness) * 2) ]) side_enclosure_part(vertical_spacing=lcd_screen_thickness, rims=false, hollow_base=true);
        }
        translate([
          -lcd_enclosure_thickness - lcd_screen_edge_tolerance,
          (lcd_height_with_tolerance / 2) + (w + lcd_enclosure_thickness) - ((w + lcd_enclosure_thickness) / 2),
          -30
        ]) rotate([0, 0, 270]) translate([0, -lcd_enclosure_thickness, 0]) cube(size=[w, h + lcd_enclosure_thickness, 40]);
      }
      translate([
        lcd_controller_height + lcd_controller_relief - lcd_screen_edge_tolerance - lcd_enclosure_thickness + 1.8,
        ((lcd_enclosure_thickness + lcd_height_with_tolerance) / 2) - (lcd_controller_width / 2),
        -30
      ]) rotate([0, 0, 90]) lcd_controll_mount(extra_rim_height = 3, extra_rim_width = 2, extra_rim_offset_x = -1);
      
    }
  }

  // Left Side Enclosure
  color(c=[0, 1, 1, 0.7]) side_enclosure_part(vertical_spacing=lcd_screen_thickness, hollow = true);

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

  // 96board compatable mount
  translate([0, 0, -30]) triple_stack_ns_mount();

  // PCB800099 lcd controller mount
  translate([0, 0, -80]) triple_stack_lcd_controller_mount();

}

lcd_enclosure();
