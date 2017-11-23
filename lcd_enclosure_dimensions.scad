// configuration variables
lcd_screen_diagonal_size = 260;
lcd_screen_edge_tolerance = 9;
lcd_screen_thickness = 6;
lcd_enclosure_thickness = 2.5;
lcd_screen_ratio_x = 16;
lcd_screen_ratio_y = 10;

// calculated sizes
lcd_screen_ratio_diagonal = sqrt(pow(lcd_screen_ratio_x, 2) + pow(lcd_screen_ratio_y, 2));
lcd_screen_width = lcd_screen_ratio_x / lcd_screen_ratio_diagonal * lcd_screen_diagonal_size;
lcd_screen_height = lcd_screen_ratio_y / lcd_screen_ratio_diagonal * lcd_screen_diagonal_size;

echo("Screen Width: ", lcd_screen_width);
echo("Screen Height: ", lcd_screen_height);

lcd_width_with_tolerance = lcd_screen_width + (lcd_screen_edge_tolerance * 2);
lcd_height_with_tolerance = lcd_screen_height + (lcd_screen_edge_tolerance * 2);
