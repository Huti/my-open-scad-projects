potRadius = 162;

holeHeight = 33;
holeWidth = 59;
holeDepth = 4 + 1;

holeCornerRadius = 6;

finess = 120;

module roundedCube(x, y, z, r) {
    hull() {
        translate([-x/2 +r, -y/2 +r, r])
            sphere(r, $fn = finess);
        translate([x/2 -r, -y/2 +r, r])
            sphere(r, $fn = finess);
        translate([-x/2 +r, -y/2 +r, z - r])
            sphere(r, $fn = finess);
        translate([x/2 -r, -y/2 +r, z - r])
            sphere(r, $fn = finess);
        
        translate([-x/2 +r, y/2 -r, r])
            sphere(r, $fn = finess);
        translate([x/2 -r, y/2 -r, r])
            sphere(r, $fn = finess);
        translate([-x/2 +r, y/2 -r, z - r])
            sphere(r, $fn = finess);
        translate([x/2 -r, y/2 -r, z - r])
            sphere(r, $fn = finess);
        
    }
}

module pieSlice(a, r, h){
  // a:angle, r:radius, h:height
  rotate_extrude(angle=a) square([r,h]);
}
intersection() {
    difference() {
        cylinder(holeHeight + 2, potRadius + 2, potRadius + 2, $fn = finess);
        cylinder(holeHeight + 2, potRadius, potRadius, $fn = finess);
    }

    rotate([0, 0, 78]) {
        pieSlice(25, potRadius + 3, holeHeight + 2);
    }
}
translate([0, potRadius - holeDepth * 2, 1]) {
    roundedCube(holeWidth, holeDepth, holeHeight, holeCornerRadius);
}