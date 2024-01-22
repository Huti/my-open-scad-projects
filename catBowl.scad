bowlTopRadius = 95;
bowlBottomRadius = 85;
bowlHeight = 35;
bowlTilt = 15;

elevationHeight = 50;
height = bowlHeight + elevationHeight;
topRadius = bowlTopRadius + 2;
cutRadius = topRadius + 50;

offset = 8;

module mainPart() {
    difference(){
        translate([offset, 0, 0]) { 
            cylinder(height, topRadius, topRadius); 
        };
        translate([0, 0, elevationHeight / 2]) {
            rotate([0, bowlTilt, 0]) {
                cylinder(bowlHeight, bowlBottomRadius, bowlTopRadius);
                translate([0, 0, bowlHeight]) {
                   cylinder(height, cutRadius, cutRadius); 
                }
            };
        };
    }
};

aditionalHeight = 50;

module secondaryPart() {
    cylinder(aditionalHeight,topRadius, topRadius);
};
translate([-offset,0, aditionalHeight]) {
    mainPart();
};
secondaryPart();