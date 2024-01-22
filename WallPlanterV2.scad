height = 200;
radius = 200 / 2;
angle = 15;
wall = 2;
gap = 1;

mountHeight = 50;
mountWidth = 100;
mountDepth = 20;
mountOffset = 20;

wateringHoleRadius = 50 / 2;

waterBaseRadius = 50 / 2;
waterBaseHeight = 50;
waterBaseTransitionHeight = 50;
waterHolesRadius = 5;
numberOfHolesInRow = 12;
numberOfHoleRows = 3;
numberOfHorizontalHolesInRow = 6;
numberOfHorizontalHoleRows = 2;

numberOfScrews = 2;
screwRadius = 5 / 2;
screwHeadRadius = 6;
screwHeadHeight = 7;

finess = 36;

demo = true;

mountInnerWidth = mountWidth + wall * 2 + gap;
mountInnerDepth = mountDepth + wall + gap;
mountInnerHeight = mountHeight + wall + mountOffset + height / 2 + gap;

module base(radius) {
    translate([0, 0, height]) {
        rotate([180, 0, 0]) {
            intersection() {
                translate([-radius * 2, -radius, 0]) {
                    cube([radius * 3, radius * 2, height]);
                }
                rotate([0, angle, 0]) {
                    translate([0, 0, height * -1]) {
                        cylinder(height * 4, radius, radius, $fn = 6);
                    }
                }
            }
        }
    }
}

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

module mount(width, depth, height, offset) {
    rotate([0, 270, 90]) {
        linear_extrude(width) {
            polygon([[0,0], [offset, depth], [height + offset, depth], [height,0]]);
        }
    }
}

module screw(height) {
    cylinder(screwHeadHeight, screwHeadRadius, screwHeadRadius, $fn = finess);
    cylinder(height, screwRadius, screwRadius, $fn = finess);
}

module mountWithHoles() {
    translate([radius, mountWidth / 2, height / 2]) {
        difference() {
            color("blue") {
                mount(mountWidth, mountDepth, mountHeight, mountOffset);
            }
            for(i = [1:numberOfScrews]) {
                translate([-mountDepth, (mountWidth / (numberOfScrews + 1)) * -i, mountHeight / 2 + mountOffset / 2]) {
                    rotate([0, 90, 0]) {
                        screw(mountDepth);
                    }
                }
            }
        }
    }
}

module wateringHoleBase(radius, wateringHoleRadius) {
    translate([0, 0, height]) {
        rotate([180, 0, 0]) {
            intersection() {
                translate([-radius * 2, -radius, 0]) {
                    cube([radius * 3, radius * 2, height]);
                }
                rotate([0, angle, 0]) {
                    translate([0, 0, height * -1]) {
                        cylinder(height * 4, wateringHoleRadius, wateringHoleRadius, $fn = 6);
                    }
                }
            }
        }
    }
}

module wateringHole() {
    translate([wateringHoleRadius - radius - wall / 2, 0, 0]) {
        difference() {
            wateringHoleBase(radius, wateringHoleRadius);
            wateringHoleBase(radius, wateringHoleRadius - wall);
            cube([radius * 2, radius * 2, waterBaseHeight * 2], true);   
        }
    }
}

module saucer() {    
    difference() {
        union() {
            union() {
                difference() {
                    base(radius);
                    base(radius - wall);
                }
                intersection() {
                    base(radius);
                    cube([radius * 2, radius  * 2, wall * 2], true);
                }
            }
            
            translate([radius - mountInnerDepth / 2, 0, 0]) {
                rotate([0, 0, -90]) {
                    roundedCube(mountInnerWidth, mountInnerDepth, mountInnerHeight, 5);
                }
            }
            wateringHole();
        }
        translate([radius, mountWidth / 2 + gap /2, 0]) {
            mount(mountWidth + gap, mountDepth + gap, mountHeight + gap + height / 2 - wall, mountOffset);
        }
    }
}

module potBase(radius) {
    difference() {
        union() {
            difference() {
                base(radius);
                cube([radius * 3, radius * 3, (waterBaseHeight + waterBaseTransitionHeight) * 2], true);
            }
            intersection() {
                base(radius);
                union() {
                    cylinder(waterBaseHeight, waterBaseRadius, waterBaseRadius, $fn = finess);
                    translate([0, 0, waterBaseHeight]) {
                        cylinder(waterBaseTransitionHeight, waterBaseRadius, radius + 20, $fn = finess);
                    }
                }
            }
        }
        
        
    }
}

module pot() {
    toScale = (radius - wall) / radius; 
    holeCutOutHeight = waterBaseHeight + waterBaseTransitionHeight;
    union() {
        difference() {
            potBase(radius - wall - gap);
            translate([0, 0, wall]) {
                scale([toScale, toScale, 1]) {
                    potBase(radius - wall - gap);
                }
            }
            for(j = [1:numberOfHoleRows]) {
                offset = (radius - wall - waterBaseRadius - waterHolesRadius * 4) / numberOfHoleRows;
                for(i = [1:numberOfHolesInRow]) {
                    rotate([0, 0, (360 / numberOfHolesInRow * i)]) {
                        translate([0, waterBaseRadius + offset * j, 0]) {
                            cylinder(holeCutOutHeight, waterHolesRadius, waterHolesRadius);
                        }
                    }
                }
            }    
            for(j = [1:numberOfHorizontalHoleRows]) {
                offset = (waterBaseHeight - wall - waterHolesRadius * 2) / numberOfHorizontalHoleRows;
                for(i = [1:numberOfHorizontalHolesInRow]) {
                    rotate([90, 0, (360 / numberOfHorizontalHolesInRow * i)]) {
                        translate([0, offset * j, 0]) {
                            cylinder(holeCutOutHeight, waterHolesRadius, waterHolesRadius);
                        }
                    }
                }
            }  
            
        
            translate([radius - ((mountInnerDepth + gap +wall) / 2), 0, 0]) {
                rotate([0, 0, -90]) {
                    roundedCube(mountInnerWidth + gap + wall, mountInnerDepth + gap + wall, mountInnerHeight + gap + wall, 5);
                }
            }
            translate([wateringHoleRadius - radius, 0, 0]) {
                
                wateringHoleBase(radius, wateringHoleRadius + gap + wall);
            }
        }
        intersection() {
            potBase(radius - wall - gap);
            difference() {
                translate([radius - ((mountInnerDepth + gap +wall) / 2), 0, 0]) {
                    rotate([0, 0, -90]) {
                        roundedCube(mountInnerWidth + gap + wall, mountInnerDepth + gap + wall, mountInnerHeight + gap + wall, 5);
                    }
                }
                translate([radius - ((mountInnerDepth + gap) / 2), 0, 0]) {
                    rotate([0, 0, -90]) {
                        roundedCube(mountInnerWidth + gap, mountInnerDepth + gap, mountInnerHeight + gap, 5);
                    }
                }
            }
        }

        intersection() {
            potBase(radius - wall - gap);
            translate([wateringHoleRadius - radius, 0, 0]) {
                difference() {
                    wateringHoleBase(radius, wateringHoleRadius + gap + wall);
                    wateringHoleBase(radius, wateringHoleRadius + gap);
                }
            }
        }
    }    
}

if (demo) {
    difference() {
        saucer();
        cube([radius, radius, height]);
    }
    /*
    difference() {
        mountWithHoles();
        cube([radius, radius, height]);
    }
    difference() {
        translate([0, 0, wall]) {
            pot();
        }
        cube([radius, radius, height]);
    }
    */
} else {
    saucer();
    mountWithHoles();
    translate([0, 0, wall]) {
        pot();
    }    
}