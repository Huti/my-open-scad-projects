potRadius = 162;

holeHeight = 33;
holeWidth = 59;
holeDepth = 4 + 1;

holeCornerRadius = 6;

wallThickness = 2;
extendWidth = 50;
extendHeight = 130;
angel = 60;

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

difference() {
    union() {
        difference() {
            intersection() {
                difference() {
                    cylinder(holeHeight + 2 + extendHeight, potRadius + extendWidth, potRadius + extendWidth, $fn = finess);
                    cylinder(holeHeight + 2 + extendHeight, potRadius, potRadius, $fn = finess);
                }

                rotate([0, 0, 90 - angel / 2]) {
                    pieSlice(angel, potRadius + extendWidth + 3, holeHeight + 2 + extendHeight);
                }
            }
            translate([0, 0, wallThickness]) {
                intersection() {
                    difference() {
                        cylinder(holeHeight + 2 + extendHeight, potRadius + extendWidth - wallThickness, potRadius + extendWidth - wallThickness, $fn = finess);
                        cylinder(holeHeight + 2 + extendHeight, potRadius + wallThickness, potRadius + wallThickness, $fn = finess);
                    }

                    rotate([0, 0, 90 - angel / 2 + 1]) {
                        pieSlice(angel - 2, potRadius + extendWidth + 3, holeHeight + 2 + extendHeight);
                    }
                }
            }
        }
        translate([0, potRadius - holeDepth * 2 + 4, 1]) {
            roundedCube(holeWidth, holeDepth, holeHeight, holeCornerRadius);
        }
    }
    translate([- wallThickness / 2, potRadius - holeDepth * 2, 1 + wallThickness ]) {
        roundedCube(holeWidth - wallThickness * 2, holeDepth, holeHeight - wallThickness * 2, holeCornerRadius);
    }
    translate([- wallThickness / 2, potRadius - holeDepth, 1 + wallThickness ]) {
        roundedCube(holeWidth - wallThickness * 2, holeDepth, holeHeight - wallThickness * 2, holeCornerRadius);
    }
    
            translate([0, 0, wallThickness]) {
                intersection() {
                    difference() {
                        cylinder(holeHeight + 2 + extendHeight, potRadius + extendWidth - wallThickness, potRadius + extendWidth - wallThickness, $fn = finess);
                        cylinder(holeHeight + 2 + extendHeight, potRadius + wallThickness, potRadius + wallThickness, $fn = finess);
                    }

                    rotate([0, 0, 90 - angel / 2 + 1]) {
                        pieSlice(angel - 2, potRadius + extendWidth + 3, holeHeight + 2 + extendHeight);
                    }
                }
            }
}