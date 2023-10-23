/* [Number of slots] */

// Number in width
nb_x = 2; // [1:10]
// Number in height
nb_y = 2; // [1:10]

/* [Box parameters] */

// Thickness of walls
thickness = 1.5;

// This is the size between the cap and the box. I originally set it to 0.5, but I had to sand the walls to make it fit with the cap.
cap_box_margin = 1;

// Size of hole to put your fingers and open the box.
finger_slot = 20;

/* [Single box sizes] */

// Interior width by figurine.
width = 27;

// Interior height by figurine. This is the TOTAL height, including base. Take a little margin.
height = 42;

// Interior depth of figurine (I set it to 27, like width, as I used it for round bases)
depth = 27;

// Height of base. Remember to take some margin, or it will scratch a little, and may remove some flocking.
base_height = 4.5;

// Size of "base holder" (it will be "thickness" of thick)
interior_margin = 4;

/* [Hidden] */

// This is a single slot (removed from plain cube)
module slot()
{
    translate([0, thickness + base_height, 0])
        cube([width, height - thickness - base_height, depth + 2]);
    translate([interior_margin, base_height, interior_margin])
        cube([width - 2 * interior_margin, interior_margin, depth - interior_margin + 2]);
    cube([width, base_height, depth + 2]);
}

// This is the box which will hold the figurines.
module box()
{
    difference()
    {
        cube([(nb_x + 1) * thickness + nb_x * width, (nb_y + 1) * thickness + height * nb_y, 30]);

        for(x_decal = [0:1:nb_x - 1])
        {
            for(y_decal = [0:1:nb_y - 1])
            {
                translate([(x_decal + 1) * thickness + x_decal * width, (y_decal + 1) * thickness + y_decal * height, thickness])
                    slot();
            }
        }
    }
}

// This is the cap to close your box. I use rubberband to close.
module cap()
{
    difference()
    {
        total_width = (nb_x + 3) * thickness + nb_x * width + 1;
        total_height = (nb_y + 3) * thickness + height * nb_y + 1;
        total_depth = 30 + 2 * thickness;

        cube([total_width, total_height, total_depth]);
        translate([thickness, thickness, thickness])
            cube([(nb_x + 1) * thickness + nb_x * width + cap_box_margin, (nb_y + 1) * thickness + height * nb_y + cap_box_margin, 30 + cap_box_margin + 2 * thickness]);

        translate([-1, total_height / 2, total_depth])
            rotate([0, 90, 0])
                cylinder(d=finger_slot, h=total_width + 2, $fn=100);
    }
}

// If you need only the box, or only the cap, just remove the unneeded lines

// Renders a box.
box();

// Cap is rendered on 0.0.0 coordinates, as it is symetrical, I use mirror not to worry about width.
mirror([1, 0, 0])
    translate([2, 0, 0])
        cap();
