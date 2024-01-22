radius = 110;
height = 120;
cutoff = 20;
hangerHeight = 10;
wallThickness = 4;
gap = 2;
holeSize = 4;
funelHeight = 10;
mountWidth = 80;
mountDepth = 10;
mountHeight = 50;
mountOffset = 5;
mountGrap = 5;
holeHeadD1 = 5;
holeHeadD2 = 4;
holeHeadHeight = 1;
waterReservoirHeight = 30;
waterHoleRadius = 50;
waterSmaleHolesRadius = 2;

finess = 120;

module base(radius, height, cutoff) {
    translate([0, 0, radius - cutoff]) {
        difference() {
            hull() {
                sphere(radius, $fn = finess);
                translate([0, 0, height]) {
                    sphere(radius, $fn = finess);
                }
            }
            translate([0, 0, -radius * 2 + cutoff]) {
                cube(radius * 2, true);
            }    
            translate([0, 0, height + radius]) {
                cube(radius * 2, true);
            }
            translate([0, -radius, cutoff]) {
                cube([radius * 2, radius * 2, height + radius * 2], true); 
            }
        }
    }
}

module baseWall(radius, height, cutoff) {
    intersection() {
        translate([0, 0, radius - cutoff]) {
            difference() {
                hull() {
                    sphere(radius, $fn = finess);
                    translate([0, 0, height]) {
                        sphere(radius, $fn = finess);
                    }
                }
                translate([0, 0, -radius * 2 + cutoff]) {
                    cube(radius * 2, true);
                }    
                
            }
        }
        translate([0, 0, height - cutoff / 2+ radius / 2]) {
            cube([radius * 2, wallThickness, height + cutoff + radius * 2], true); 
        }
    }
}

module baseBack(radius, height, cutoff, wallThickness) {
    intersection() {
        translate([0, 0, radius - cutoff]) {
            difference() {
                hull() {
                    sphere(radius, $fn = finess);
                    translate([0, 0, height]) {
                        sphere(radius, $fn = finess);
                    }
                }
                translate([0, 0, -radius * 2 + cutoff]) {
                    cube(radius * 2, true);
                }    
                translate([0, 0, height + radius]) {
                cube(radius * 2, true);
                }
            }
        }
        translate([0, 0, height - cutoff / 2+ radius / 2]) {
            cube([radius * 2, wallThickness, height + cutoff + radius * 2], true); 
        }
    }
}

module backWithHoles() {
    difference() {
        baseBack(radius, height + hangerHeight, cutoff, wallThickness);
        translate([radius / 2, wallThickness / 2, height + radius - hangerHeight / 2]) {
            rotate([90, 0, 0]) {
                cylinder(wallThickness, holeSize / 2, holeSize / 2,  $fn = finess);
            }
        }
        translate([- radius / 2, wallThickness / 2, height + radius - hangerHeight / 2]) {
            rotate([90, 0, 0]) {
                cylinder(wallThickness, holeSize / 2, holeSize / 2,  $fn = finess);
            }
        }
    }
}

module mount(mountWidth, mountDepth, mountHeight, mountOffset) {
    translate([mountWidth / 2, -wallThickness, 0]) {
        rotate([0, 270, 0]) {
            linear_extrude(mountWidth) {
                polygon([[0,0], [mountOffset, mountDepth], [mountHeight + mountOffset, mountDepth], [mountHeight,0]]);
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

module baseWithMountingPosition() {
    difference() {
        union() {
            difference() {
                base(radius, height, cutoff);
                translate([0, 0, wallThickness * 2]) {
                    base(radius - wallThickness, height, cutoff);
                }
            }

            baseBack(radius, height, cutoff, wallThickness);
            translate([0, (mountDepth + wallThickness * 2 + gap) / 2, 0]) {
                rotate([0, 0, 180]) {
                    roundedCube(mountWidth + wallThickness * 2, mountDepth + wallThickness * 2, height + radius- cutoff, 2);
                }
            }
        }
        translate([0, 0, wallThickness]) {
            mount(mountWidth, mountDepth, height + radius - cutoff - mountHeight - mountOffset - mountGrap, mountOffset);
        }
    }
}
module mountWithHoles() {
    difference() {
        mount(mountWidth, mountDepth, mountHeight, mountOffset);
        translate([-mountWidth / 4, mountDepth - wallThickness, holeSize / 2 + mountHeight/ 2]) {
            rotate([90, 00, 0]) {
                cylinder(mountDepth, holeSize / 2, holeSize / 2,  $fn = finess);
            }
        }
        translate([-mountWidth / 4, mountDepth - holeHeadHeight, holeSize / 2 + mountHeight/ 2]) {
            rotate([90, 00, 0]) {
                cylinder(holeHeadHeight, holeHeadD1 / 2, holeHeadD2 / 2,  $fn = finess);
            }
        }
        translate([mountWidth / 4, mountDepth - wallThickness, holeSize / 2 + mountHeight/ 2]) {
            rotate([90, 00, 0]) {
                cylinder(mountDepth, holeSize / 2, holeSize / 2,  $fn = finess);
            }
        }
        translate([mountWidth / 4, mountDepth - holeHeadHeight, holeSize / 2 + mountHeight/ 2]) {
            rotate([90, 00, 0]) {
                cylinder(holeHeadHeight, holeHeadD1 / 2, holeHeadD2 / 2,  $fn = finess);
            }
        }
    }
}


module potBase(radius, height, cutoff, waterReservoirHeight, waterHoleRadius) {
    difference() {
        union() {
            translate([0, 0, radius - cutoff]) {
                difference() {
                    hull() {
                        sphere(radius, $fn = finess);
                        translate([0, 0, height]) {
                            sphere(radius, $fn = finess);
                        }
                    }
                    translate([0, 0, -radius]) {
                        cube(radius * 2, true);
                    }    
                    translate([0, 0, height + radius]) {
                        cube(radius * 2, true);
                    }                    
                    translate([0, -radius, cutoff]) {
                        cube([radius * 2, radius * 2, height + radius * 2], true); 
                    }
                }
            }
            
            difference() {
                union() {
                    translate([0, 0, waterReservoirHeight]) {
                        cylinder(radius - waterReservoirHeight - cutoff, waterHoleRadius, radius, $fn = finess);
                    }
                    cylinder(waterReservoirHeight, waterHoleRadius, waterHoleRadius, $fn = finess);
                }
                translate([0, -radius, cutoff]) {
                    cube([radius * 2, radius * 2, height + radius * 2], true); 
                }
            }
        }
        translate([0, wallThickness * 2 + gap, -wallThickness/ 2]) {
            rotate([0, 0, 180]) {
                roundedCube(mountWidth + wallThickness * 2 + gap, mountDepth + wallThickness * 3 + gap, height + radius - cutoff + wallThickness, 2);
            }
        }
    }
}


baseWithMountingPosition();
/*
translate([0, -10, 0])
    mountWithHoles();
/*
translate([0, 10 + radius, 0])
    difference() {
        union() {
            difference() {
                potBase(radius - wallThickness - gap, height, cutoff, waterReservoirHeight, waterHoleRadius);
                translate([0, 0, wallThickness]) {
                    scale([((radius - wallThickness * 2 - gap) / (radius - wallThickness - gap) ), ((radius - wallThickness * 2 - gap) / (radius - wallThickness - gap)), 1]) {
                        potBase(radius - wallThickness - gap, height, cutoff, waterReservoirHeight, waterHoleRadius);
                    }
                }
        
                for(i = [0:30:360]) {
                    rotate([0,0,i + 1]) {
                        translate([0, waterHoleRadius * 0.6, 0]) {
                            cylinder(wallThickness * 2, waterSmaleHolesRadius, waterSmaleHolesRadius);
                        }
                    }
                    rotate([0,0,i + 15]) {
                        translate([0, waterHoleRadius * 0.8, 0]) {
                            cylinder(wallThickness * 2, waterSmaleHolesRadius, waterSmaleHolesRadius);
                        }
                    }    
                    rotate([0,0,i + 5]) {
                        translate([0, (radius - wallThickness - gap) * 0.7, 0]) {
                            cylinder(height * 2, waterSmaleHolesRadius, waterSmaleHolesRadius);
                        }
                    }
                    rotate([0,0,i + 15]) {
                        translate([0, (radius - wallThickness - gap) * 0.8, 0]) {
                            cylinder(height * 2, waterSmaleHolesRadius, waterSmaleHolesRadius);
                        }
                    } 
                    rotate([0,0,i + 5]) {
                        translate([0, (radius - wallThickness - gap) * 0.9, 0]) {
                            cylinder(height * 2, waterSmaleHolesRadius, waterSmaleHolesRadius);
                        }
                    }
                    rotate([0,0,i + 5]) {
                        translate([-radius, 0, waterReservoirHeight * 0.25]) {
                            rotate([0,90,0]) {
                                cylinder(radius * 2, waterSmaleHolesRadius, waterSmaleHolesRadius);
                            }
                        }
                    }
                    rotate([0,0,i + 15]) {
                        translate([-radius, 0, waterReservoirHeight * 0.5]) {
                            rotate([0,90,0]) {
                                cylinder(radius * 2, waterSmaleHolesRadius, waterSmaleHolesRadius);
                            }
                        }
                    }
                    rotate([0,0,i + 5]) {
                        translate([-radius, 0, waterReservoirHeight * 0.75]) {
                            rotate([0,90,0]) {
                                cylinder(radius * 2, waterSmaleHolesRadius, waterSmaleHolesRadius);
                            }
                        }
                    }
                }
            }
            difference() {
                potBase(radius - wallThickness - gap, height, cutoff, waterReservoirHeight, waterHoleRadius);
                translate([0, wallThickness, 0]) {
                    potBase(radius - wallThickness - gap, height, cutoff, waterReservoirHeight, waterHoleRadius);
                }
            }
        }
    }
*/