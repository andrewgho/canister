d1        = 42.63 + 0.1;  // Measured short diameter (with fudge factor)
d2        = 65.5;         // Measured long diameter
height    = 40;           // Total height
scale_top = 0.95;         // Scale top height by this factor
scale_bot = 1.1;          // Scale bottom height by this factor
thickness = 5;            // Wall thickness

// #8 screw as per: https://www.mcfeelys.com/screw_size_comparisons
screw_hole_diameter = (0.13 * 25.4) * 1.15;
tab_length = screw_hole_diameter + (1.5 * thickness);
tab_width = screw_hole_diameter + (2 * thickness);

// Rendering parameters
$fn = 180;
e = 0.1;
e2 = e * 2;

// The basic shape of mandrel face (for now, simulated)
module coin() {
    resize([d1, d2]) circle(d = 1);
}

// Solid mandrel body shape
module body() {
    linear_extrude(height = height, scale = scale_top / scale_bot)
        scale([scale_bot, scale_bot, 1]) coin();
}

// Mandrel body hollowed out
module shell() {
    s1 = (d1 - (2 * thickness)) / d1;
    s2 = (d2 - (2 * thickness)) / d2;
    difference() {
        body();
        translate([0, 0, height - e]) linear_extrude(height = e2)
            scale([s1 * scale_top, s2 * scale_top, 1]) coin();
        scale([s1, s2, 1]) body();
        translate([0, 0, -e]) linear_extrude(height = e2)
            scale([s1 * scale_bot, s2 * scale_bot, 1]) coin();
    }
}

// Strengthening ribs
module ribs() {
    hull() {
        linear_extrude(height = e)
            square(size = [(d1 * scale_bot) - thickness, thickness], center = true);
        translate([0, 0, height - e]) linear_extrude(height = e)
            square(size = [(d1 * scale_top) - thickness, thickness], center = true);
    }
    hull() {
        linear_extrude(height = e)
            square(size = [thickness, (d2 * scale_bot) - thickness], center = true);
        translate([0, 0, height - e]) linear_extrude(height = e)
            square(size = [thickness, (d2 * scale_top) - thickness], center = true);
    }
}

// A single screw mount tab
module tab() {
    difference() {
        union() {
            translate([-thickness / 2, -tab_width / 2, 0])
                cube([(tab_length + thickness) / 2, tab_width, thickness]);
            translate([tab_length / 2, 0, 0])
                cylinder(d = tab_width, h = thickness);
        }
        translate([tab_length / 2, 0, -e])
            cylinder(d = screw_hole_diameter, h = thickness + e2);
    }
}

// Screw mounting tabs oriented around body/shell
module tabs() {
    module tab1() {
        translate([d1 * scale_bot / 2, 0, 0]) tab();
    }
    module tab2() {
        translate([0, d2 * scale_bot / 2, 0])
            rotate(a = 90, v = [0, 0, 1]) tab();
    }
    tab1();
    mirror([1, 0, 0]) tab1();
    tab2();
    mirror([0, 1, 0]) tab2();
}

shell();
ribs();
tabs();
