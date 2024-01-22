mugRadius = 71.5 / 2;
mugTopRadius = 70 / 2;
spacerHeight = 0;//4.7;
mugThicknes = 3;
mugHeight = 260.6 - spacerHeight;

mugTopHeight = 37.1;

mugBottomHeight = 10;
mugBottomThicknes = 5;
mugBottomCutOutRadius = 5;
mugBottomCutOutLength = (mugRadius + mugThicknes) * 2;

bottomChamfer = 2;
topChamfer = 2;

viewWindowWidth = 4;
viewWindowHeight = 150;

railOffset = -1.0;
lengthOfScaledown = 10;

numberOfRails = floor((mugHeight - 2 *lengthOfScaledown) / 10);
lengthOfRail = lengthOfScaledown * 2 + (numberOfRails * 10) - 5.25;
differenceOfRailAndMug = mugHeight - lengthOfRail;

halfCutThicknes = 0.2;
halfCutHeight = 10;
finness = 120;
picoRailOffsetDelta = 0.15;

module picoRail(numberOfRails = 3, lengthOfScaledown = 10, scaleDown = 0.5, offsetDelta = 0) {
    railBottomHeight = 3.32;
    railBottomWidth = 15.67;

    lengthOfRail = 4.75;
    lengthOfGap = 5.25;
    heightOfGap = 3;

    railTopHeight = 6;
    railTopWidth = 21.2;


    railDifferencePerSide = (railTopWidth - railBottomWidth) / 2;
    railPolygonPoints = [
                        [0, 0], 
                        [0, railBottomHeight],
                        [-railDifferencePerSide, railBottomHeight + railTopHeight / 2],
                        [0, railBottomHeight + railTopHeight],
                        [railBottomWidth, railBottomHeight + railTopHeight],
                        [railBottomWidth + railDifferencePerSide, railBottomHeight + railTopHeight / 2],
                        [railBottomWidth, railBottomHeight],
                        [railBottomWidth, 0],
                        [0, 0]
                        ];
    gapPolygonPoints = [
                            [0, 0], 
                            [0, railBottomHeight],
                            [-railDifferencePerSide, railBottomHeight + railTopHeight / 2],
                            [railBottomWidth + railDifferencePerSide, railBottomHeight + railTopHeight / 2],
                            [railBottomWidth, railBottomHeight],
                            [railBottomWidth, 0],
                            [0, 0]
                            ];

    translate([0, 0, lengthOfScaledown]) {
        union() {
            rotate([0, 180, 0]) {
                linear_extrude(lengthOfScaledown, scale = scaleDown) {
                    translate([railDifferencePerSide -railTopWidth / 2, 0, 0]) {
                        offset(delta = offsetDelta) {
                            polygon(railPolygonPoints);
                        }
                    };
                };
            }
            for (i = [0: numberOfRails - 1]){ 
                translate([railDifferencePerSide -railTopWidth / 2, 0, i * (lengthOfRail + lengthOfGap)]) { 
                    linear_extrude(lengthOfRail) {
                        offset(delta = offsetDelta) {
                            polygon(railPolygonPoints);
                        }
                    }
                }
                if (i < numberOfRails - 1) {
                    translate([railDifferencePerSide -railTopWidth / 2, 0, i * (lengthOfRail + lengthOfGap) + lengthOfRail]) {    
                        linear_extrude(lengthOfGap) {
                            offset(delta = offsetDelta) {
                                polygon(gapPolygonPoints);
                            }
                        }
                    }
                }
            }
            translate([0, 0, numberOfRails * (lengthOfRail + lengthOfGap) - lengthOfGap]) {
                linear_extrude(lengthOfScaledown, scale = scaleDown) {
                        translate([railDifferencePerSide -railTopWidth / 2, 0, 0]) {
                            offset(delta = offsetDelta) {
                                polygon(railPolygonPoints);
                            }
                        };
                    };
            }
        }    
    };
};
module top () {
    translate([0, 0,  + spacerHeight]) {
        difference() {    
            translate([0, 0, mugBottomHeight + mugHeight]) {
                difference() {    
                    cylinder(mugTopHeight + mugThicknes, mugTopRadius + mugThicknes, mugTopRadius + mugThicknes, $fn = finness);
                    cylinder(mugTopHeight, mugTopRadius, mugTopRadius, $fn = finness);
                }
            };
            rotate_extrude(angle = 360, convexity = finness) {
                translate([mugTopRadius  + mugThicknes, mugBottomHeight + mugHeight, 0]) {
                    polygon([[-topChamfer / 2, 0],[0, topChamfer / 2], [0, -topChamfer / 2], [-topChamfer / 2, 0]]);
                };
            };
            rotate_extrude(angle = 360, convexity = finness) {
                translate([mugTopRadius  + mugThicknes, mugBottomHeight + mugHeight + mugTopHeight + mugThicknes, 0]) {
                    polygon([[-topChamfer / 2, 0],[0, topChamfer / 2], [0, -topChamfer / 2], [-topChamfer / 2, 0]]);
                };
            };
            
            for (i = [0 : 90 ]) {
                rotate([0, 0, i * 4]) {
                    translate([0, 0, mugBottomHeight + mugHeight +  topChamfer]) {
                        linear_extrude(height = mugTopHeight + mugThicknes - topChamfer * 2, center = false, convexity = 100, twist = 20) {
                            translate([0, mugTopRadius + mugThicknes + 0.1, 0]) {
                                rotate([0, 0, 90]) {
                                    polygon([[-topChamfer / 2, 0],[0, topChamfer / 2], [0, -topChamfer / 2], [-topChamfer / 2, 0]]);
                                };
                            };
                        };
                    };

                    translate([0, 0, mugBottomHeight + mugHeight +  topChamfer]) {
                        linear_extrude(height = mugTopHeight + mugThicknes - topChamfer * 2, center = false, convexity = 100, twist = - 20) {
                            translate([0, mugTopRadius + mugThicknes + 0.1, 0]) {
                                rotate([0, 0, 90]) {
                                    polygon([[-topChamfer / 2, 0],[0, topChamfer / 2], [0, -topChamfer / 2], [-topChamfer / 2, 0]]);
                                };
                            };
                        };
                    };
                }
            }
        }
    }
};

module spacer () {
    difference() {    
        translate([0, 0, mugBottomHeight + mugHeight]) {
            difference() {    
                cylinder(spacerHeight, mugRadius + mugThicknes, mugRadius + mugThicknes);
                cylinder(spacerHeight, mugRadius, mugRadius);
            }
        };
        rotate_extrude(angle = 360, convexity = finness) {
            translate([mugRadius  + mugThicknes, mugBottomHeight + mugHeight, 0]) {
                polygon([[-topChamfer / 2, 0],[0, topChamfer / 2], [0, -topChamfer / 2], [-topChamfer / 2, 0]]);
            };
        };
        rotate_extrude(angle = 360, convexity = finness) {
            translate([mugRadius  + mugThicknes, mugBottomHeight + mugHeight + spacerHeight, 0]) {
                polygon([[-topChamfer / 2, 0],[0, topChamfer / 2], [0, -topChamfer / 2], [-topChamfer / 2, 0]]);
            };
        };
        
    }
};
module bottom () {
    union() {
        difference() {
            difference() {
                translate([0, 0, mugBottomHeight]) {
                    difference() {    
                        cylinder(mugHeight, mugRadius + mugThicknes, mugRadius + mugThicknes, $fn = finness);
                        cylinder(mugHeight, mugRadius, mugRadius, $fn = finness);
                    }
                };
                translate([0, 0, mugBottomHeight + differenceOfRailAndMug / 2]) {
                    rotate([0, 0, 45]) {
                        translate([0, mugRadius + mugThicknes + railOffset, 0]) {
                            picoRail(numberOfRails, lengthOfScaledown, offsetDelta = picoRailOffsetDelta);
                        };
                    };
                };
                translate([0, 0, mugBottomHeight +  differenceOfRailAndMug / 2]) {
                    rotate([0, 0, 135]) {
                        translate([0, mugRadius  + mugThicknes + railOffset, 0]) {
                            picoRail(numberOfRails, lengthOfScaledown, offsetDelta = picoRailOffsetDelta);
                        };
                    };
                };
                translate([0, 0, mugBottomHeight + differenceOfRailAndMug / 2]) {
                    rotate([0, 0, 225]) {
                        translate([0, mugRadius  + mugThicknes + railOffset, 0]) {
                            picoRail(numberOfRails, lengthOfScaledown, offsetDelta = picoRailOffsetDelta);
                        };
                    };
                };
                translate([0, 0, mugBottomHeight + differenceOfRailAndMug / 2]) {
                    rotate([0, 0, 315]) {
                        translate([0, mugRadius  + mugThicknes + railOffset, 0]) {
                            picoRail(numberOfRails, lengthOfScaledown, offsetDelta = picoRailOffsetDelta);
                        };
                    };
                };
            }
            
            rotate_extrude(angle = 360, convexity = finness) {
                translate([mugRadius + mugThicknes, mugBottomHeight, 0]) {
                    polygon([[-bottomChamfer / 2, 0],[0, bottomChamfer / 2], [0, -bottomChamfer / 2], [-bottomChamfer / 2, 0]]);
                };
            };
            rotate_extrude(angle = 360, convexity = finness) {
                translate([mugRadius  + mugThicknes, mugBottomHeight + mugHeight, 0]) {
                    polygon([[-topChamfer / 2, 0],[0, topChamfer / 2], [0, -topChamfer / 2], [-topChamfer / 2, 0]]);
                };
            };
            
            translate([-viewWindowWidth / 2, -mugRadius - mugThicknes, mugBottomHeight + mugHeight / 2 - viewWindowHeight / 2]) {
                cube([viewWindowWidth,  (mugRadius  + mugThicknes)* 2, viewWindowHeight]);
            };
            translate([0, mugRadius + mugThicknes, mugBottomHeight + mugHeight / 2 - viewWindowHeight / 2 ]) {
                rotate([90, 0, 0]) {
                    cylinder((mugRadius  + mugThicknes)* 2, viewWindowWidth / 2, viewWindowWidth / 2, $fn = finness);
                };
            };
            translate([0, mugRadius + mugThicknes, mugBottomHeight + mugHeight / 2 + viewWindowHeight / 2]) {
                rotate([90, 0, 0]) {
                    cylinder((mugRadius + mugThicknes) * 2, viewWindowWidth / 2, viewWindowWidth / 2, $fn = finness);
                };
            };
        };
        difference() {    
            cylinder(mugBottomHeight, mugRadius + mugThicknes, mugRadius + mugThicknes, $fn = finness);
            cylinder(mugBottomHeight - mugThicknes, mugRadius , mugRadius, $fn = finness);
            
            translate([0, mugBottomCutOutLength / 2, 0]) {
                rotate([90, 0, 0]) {
                    cylinder(mugBottomCutOutLength, mugBottomCutOutRadius, mugBottomCutOutRadius, $fn = finness);
                };
            };
            rotate([0, 0, 45]) {
                translate([0, mugBottomCutOutLength / 2, 0]) {
                    rotate([90, 0, 0]) {
                        cylinder(mugBottomCutOutLength, mugBottomCutOutRadius, mugBottomCutOutRadius, $fn = finness);
                    };
                };
            };
            rotate([0, 0, 90]) {
                translate([0, mugBottomCutOutLength / 2, 0]) {
                    rotate([90, 0, 0]) {
                        cylinder(mugBottomCutOutLength, mugBottomCutOutRadius, mugBottomCutOutRadius, $fn = finness);
                    };
                };
            };
            rotate([0, 0, 135]) {
                translate([0, mugBottomCutOutLength / 2, 0]) {
                    rotate([90, 0, 0]) {
                        cylinder(mugBottomCutOutLength, mugBottomCutOutRadius, mugBottomCutOutRadius, $fn = finness);
                    };
                };
            };
            rotate_extrude(angle = 360, convexity = finness) {
                translate([mugRadius + mugThicknes + 0.5, mugBottomHeight, 0]) {
                    polygon([[-bottomChamfer / 2, 0],[0, bottomChamfer / 2], [0, -bottomChamfer / 2], [-bottomChamfer / 2, 0]]);
                };
            };
        };
    };
};



module bottomPart1() {
    translate([mugRadius * 3, 0, 0]) {
        difference() {
            bottom();
            translate([0, 0, mugHeight / 2 + mugBottomHeight]) { 
                difference() {
                    cylinder(halfCutThicknes, mugRadius + mugThicknes + 10, mugRadius + mugThicknes + 10, $fn = finness);
                    cylinder(halfCutThicknes, mugRadius + mugThicknes / 2, mugRadius + mugThicknes / 2, $fn = finness);
                };
            };
            translate([0, 0, mugHeight / 2 + mugBottomHeight]) { 
                difference() {
                    cylinder(halfCutHeight, mugRadius + mugThicknes / 2 + halfCutThicknes / 2, mugRadius + mugThicknes / 2 + halfCutThicknes / 2, $fn = finness);
                    cylinder(halfCutHeight, mugRadius + mugThicknes / 2, mugRadius + mugThicknes / 2, $fn = finness);
                };
            };
            translate([0, 0, mugHeight / 2 + mugBottomHeight + halfCutHeight]) { 
                    cylinder(halfCutThicknes, mugRadius + mugThicknes / 2, mugRadius + mugThicknes / 2, $fn = finness);
            };
            translate([0, 0, mugHeight / 2 + mugBottomHeight + halfCutHeight]) { 
                cylinder(mugHeight / 2 + mugBottomHeight, mugRadius + mugThicknes + 10, mugRadius + mugThicknes + 10, $fn = finness);
            }
        translate([0, 0, mugHeight / 2 + mugBottomHeight]) { 
                difference() {
                    cylinder(halfCutThicknes + halfCutHeight, mugRadius + mugThicknes + 10, mugRadius + mugThicknes + 10, $fn = finness);
                    cylinder(halfCutThicknes + halfCutHeight, mugRadius + mugThicknes / 2, mugRadius + mugThicknes / 2, $fn = finness);
                };
            };
        };
    };
};

module bottomPart2() {
    translate([0, mugRadius * 3, 0]) {
        difference() {
            bottom();
            translate([0, 0, mugHeight / 2 + mugBottomHeight]) { 
                difference() {
                    cylinder(halfCutThicknes, mugRadius + mugThicknes + 10, mugRadius + mugThicknes + 10, $fn = finness);
                    cylinder(halfCutThicknes, mugRadius + mugThicknes / 2, mugRadius + mugThicknes / 2, $fn = finness);
                };
            };
            translate([0, 0, mugHeight / 2 + mugBottomHeight]) { 
                difference() {
                    cylinder(halfCutHeight, mugRadius + mugThicknes / 2 + halfCutThicknes / 2, mugRadius + mugThicknes / 2 + halfCutThicknes / 2, $fn = finness);
                    cylinder(halfCutHeight, mugRadius + mugThicknes / 2, mugRadius + mugThicknes / 2, $fn = finness);
                };
            };
            translate([0, 0, mugHeight / 2 + mugBottomHeight + halfCutHeight]) { 
                    cylinder(halfCutThicknes, mugRadius + mugThicknes / 2, mugRadius + mugThicknes / 2, $fn = finness);
            };
            cylinder(mugHeight / 2 + mugBottomHeight + halfCutThicknes, mugRadius + mugThicknes + 10, mugRadius + mugThicknes + 10, $fn = finness);
                    cylinder(mugHeight / 2 + mugBottomHeight + halfCutThicknes + halfCutHeight, mugRadius + mugThicknes / 2 + halfCutThicknes / 2, mugRadius + mugThicknes / 2 + halfCutThicknes / 2, $fn = finness);
        };
    };
};




top();
spacer();
bottom();
translate([- mugRadius * 3, 0, 0]) {
    //spacer();
};
translate([0, - mugRadius * 3, 0]) {
    //top();
};
//bottomPart1();
//bottomPart2();
translate([0, mugRadius * 3, 0]) {
    picoRail(numberOfRails, lengthOfScaledown, offsetDelta = 0);
};
