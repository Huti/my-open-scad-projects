railBottomHeight = 3.32;
railBottomWidth = 15.67;

numberOfRails = 3;

lengthOfRail = 4.75;
lengthOfGap = 5.25;
heightOfGap = 3;

railTopHeight = 6;
railTopWidth = 21.2;


railDifferencePerSide = (railTopWidth - railBottomWidth) / 2;



union() {    
    for (i = [0: numberOfRails - 1]){ 
        translate([0, 0, i * (lengthOfRail + lengthOfGap)]) { 
            linear_extrude(lengthOfRail) {
                polygon([
                    [0, 0], 
                    [0, railBottomHeight],
                    [-railDifferencePerSide, railBottomHeight + railTopHeight / 2],
                    [0, railBottomHeight + railTopHeight],
                    [railBottomWidth, railBottomHeight + railTopHeight],
                    [railBottomWidth + railDifferencePerSide, railBottomHeight + railTopHeight / 2],
                    [railBottomWidth, railBottomHeight],
                    [railBottomWidth, 0],
                    [0, 0]
                    ]
                    );
            }
        }
        if (i < numberOfRails - 1) {
            translate([0, 0, i * (lengthOfRail + lengthOfGap) + lengthOfRail]) {    
                linear_extrude(lengthOfGap) {
                    polygon([
                        [0, 0], 
                        [0, railBottomHeight],
                        [-railDifferencePerSide, railBottomHeight + railTopHeight / 2],
                        [railBottomWidth + railDifferencePerSide, railBottomHeight + railTopHeight / 2],
                        [railBottomWidth, railBottomHeight],
                        [railBottomWidth, 0],
                        [0, 0]
                        ]
                        );
                }
            }
        }
    }
}