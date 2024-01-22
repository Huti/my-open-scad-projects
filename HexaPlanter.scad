height = 200;
radius = 200 / 2;
angle = 45;
wall = 4;
gap = 1;

wateringHoleRadius = 50 / 2;

waterBaseRadius = 50 / 2;
waterBaseHeight = 50;
waterBaseTransitionHeight = 50;
waterHolesRadius = 5;
numberOfHolesInRow = 12;
numberOfHoleRows = 3;
numberOfHorizontalHolesInRow = 6;
numberOfHorizontalHoleRows = 2;

finess = 36;

demo = true;

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
        
        translate([-x/2, y/2 -r, 0])
            cube(r);
        translate([x/2 -r, y/2 -r, 0])
            cube(r);
        translate([-x/2, y/2 -r, z - r])
            cube(r);
        translate([x/2 -r, y/2 -r, z - r])
            cube(r);
        
    }
}

module potBase(radius, waterBaseRadius, height) {
    union() {
        translate([0, 0, waterBaseHeight + waterBaseTransitionHeight]) {
            cylinder(height - waterBaseHeight - waterBaseTransitionHeight, radius, radius, $fn = 6);
        }
        intersection() {
            cylinder(height, radius, radius, $fn = 6);
            union() {
                cylinder(waterBaseHeight, waterBaseRadius, waterBaseRadius, $fn = finess);
                translate([0, 0, waterBaseHeight]) {
                    cylinder(waterBaseTransitionHeight, waterBaseRadius, radius , $fn = finess);
                }
            }
        }
    }
}

module pot(radius, height) {
    difference() {
        potBase(radius, waterBaseRadius, height);
        translate([0, 0, wall]) {
            potBase(radius - wall, waterBaseRadius - wall, height);
        }
        for(j = [1:numberOfHoleRows]) {
            offset = (radius - wall - waterBaseRadius - waterHolesRadius * 4) / numberOfHoleRows;
            for(i = [1:numberOfHolesInRow]) {
                rotate([0, 0, (360 / numberOfHolesInRow * i)]) {
                    translate([0, waterBaseRadius + offset * j, 0]) {
                        cylinder(height, waterHolesRadius, waterHolesRadius);
                    }
                }
            }
        }    
        for(j = [1:numberOfHorizontalHoleRows]) {
            offset = (waterBaseHeight - wall - waterHolesRadius * 2) / numberOfHorizontalHoleRows;
            for(i = [1:numberOfHorizontalHolesInRow]) {
                rotate([90, 0, (360 / numberOfHorizontalHolesInRow * i)]) {
                    translate([0, offset * j, 0]) {
                        cylinder(height, waterHolesRadius, waterHolesRadius);
                    }
                }
            }
        }    
    } 
}

module saucer() {
    difference() {
        cylinder(height, radius, radius, $fn = 6);
        translate([0, 0, wall]) {
            cylinder(height, radius - wall, radius - wall, $fn = 6);
        }
    }
}

if (demo) {
    difference() {
        translate([0, 0, wall + gap]) {
            pot(radius - wall - gap, height - wall - gap);
        }
        cube([radius, radius, height]);
    }

    difference() {
        color("blue") {
            saucer();
        }
            cube([radius, radius, height]);
    }
} else {
    translate([0, 0, wall + gap]) {
        pot(radius - wall / 2 - gap, height - wall - gap);
    }
    saucer();
}