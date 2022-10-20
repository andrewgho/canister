d1 = 42.63;
d2 = 65.50;
height = 40;
scale_top = 0.9;
scale_bot = 1.1;
thickness = 5;

$fn = 180;
e = 0.1;
e2 = e * 2;

module coin() {
    resize([d1, d2]) circle(d = 1);
}

module body() {
    linear_extrude(height = height, scale = scale_top / scale_bot)
        scale([scale_bot, scale_bot, 1]) coin();
}

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

shell();
