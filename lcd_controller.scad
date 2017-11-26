include <libs/nutsnbolts/cyl_head_bolt.scad>;
include <libs/nutsnbolts/materials.scad>;

module lcd_controll_mount(
  lcd_pcb_relief = 0.5,
  lcd_controller_case_thickness = 2.5,
  extra_rim_height = 0,
  extra_rim_width = 0,
  extra_rim_offset_x = 0,
  extra_rim_offset_y = 0,
  lcd_controller_base_leg_height = 5
) {

  // connectors are facing toward positive Z axis
  // Power connector is on the opposite side of the origin
  lcd_controller_width = 90.57797;
  lcd_controller_height = 65.60828;
  lcd_pcb_height = 1.66;

  // screw hole width
  lcd_screw_name = "3M";
  lcd_controller_screw_hole_width = 3;
  lcd_bottom_left_screw_pos = [2.36234, 2.31154];
  lcd_bottom_right_screw_pos = [lcd_controller_width - 11.0236, 1.4986];
  lcd_top_left_screw_pos = [3.09974, lcd_controller_height - 3.50529];
  lcd_top_right_screw_pos = [lcd_controller_width - 1.8796, lcd_controller_height - 3.73389];

  // VGA Base Mount Size
  lcd_vga_base_mount_width = 30;
  lcd_vga_base_mount_height = 13;

  // lcd_port_holes
  composite_video_x_pos = 5.84306;
  composite_video_width = 10.14275;
  composite_video_height = 12.4;
  vga_video_x_pos = composite_video_x_pos + composite_video_width + 2.40491;
  vga_video_width = 30.40276;
  vga_video_height = 12.4;
  hdmi_video_x_pos = lcd_controller_width - 38.82081;
  hdmi_video_width = 16;
  hdmi_video_height = 7.7;
  dc_connector_x_pos = lcd_controller_width - 14.10729;
  dc_connector_width = 10.7;
  dc_connector_height = 12.4;

  module connector_holes(connector_relief = 1) {
    x = connector_relief * 2;
    o = -connector_relief;
    // form left to right
    // composite video
    translate([composite_video_x_pos + o, 0, o])
    cube(size=[composite_video_width + x, lcd_controller_case_thickness, composite_video_height + x]);
    // vga
    translate([vga_video_x_pos + o, 0, o])
    cube(size=[vga_video_width + x, lcd_controller_case_thickness, vga_video_height + x]);
    // hdmi
    translate([hdmi_video_x_pos + o, 0, o])
    cube(size=[hdmi_video_width + x, lcd_controller_case_thickness, hdmi_video_height + x]);
    // dc connector
    translate([dc_connector_x_pos + o, 0, o])
    cube(size=[dc_connector_width + x, lcd_controller_case_thickness, dc_connector_height + x]);

  }

  module base() {
    translate([-lcd_pcb_relief, -lcd_pcb_relief, 0]) cube(
      size=[
        lcd_controller_width + lcd_pcb_relief * 2,
        lcd_controller_height + lcd_pcb_relief * 2,
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

  module screw_riser(name = "M3", $fn = 10, h = lcd_controller_base_leg_height) {
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

  module lcd_port_holes() {
    difference() {
      translate([extra_rim_offset_x, extra_rim_offset_y, 0]) cube(size=[
        lcd_controller_width + extra_rim_width,
        lcd_controller_case_thickness,
        vga_video_height + lcd_controller_base_leg_height + (lcd_controller_case_thickness * 3) + extra_rim_height
      ]);
      translate([
        0,
        0,
        lcd_controller_case_thickness + lcd_pcb_height + lcd_controller_base_leg_height
      ]) connector_holes();
    }
  }

  union() {
    base_with_legs();
    translate([0, lcd_controller_height + lcd_pcb_relief, 0]) lcd_port_holes();
  }
}

difference() {
  lcd_controll_mount();
  translate([-5, -100 + 58, -1]) cube(size=[100,100,100]);
}
