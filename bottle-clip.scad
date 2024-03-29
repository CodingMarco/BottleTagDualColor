/**
 * A name tag that can easily be clipped to the neck of your bottle.
 * Copyright (C) 2013 Roland Hieber <rohieb+bottleclip@rohieb.name>
 *
 * See examples.scad for examples on how to use this module.
 *
 * The contents of this file are licenced under CC-BY-SA 3.0 Unported.
 * See https://creativecommons.org/licenses/by-sa/3.0/deed for the
 * licensing terms.
 */

include <write/Write.scad>

/**
 * Creates one instance of a bottle clip name tag. The default values are
 * suitable for 0.5l Club Mate bottles (and similar bottles). By default, logo
 * and text are placed on the name tag so they both share half the height. If
 * there is no logo, the text uses the total height instead.
 * Parameters:
 * ru: the radius on the upper side of the clip
 * rl: the radius on the lower side of the clip
 * ht: the height of the clip
 * width: the thickness of the wall. Values near 2.5 usually result in a good
 *    clippiness for PLA prints.
 * name: the name that is printed on your name tag. For the default ru/rt/ht
 *    values, this string should not exceed 18 characters to fit on the name tag.
 * gap: width of the opening gap, in degrees. For rigid materials this value
 *  usually needs to be near 180 (but if you set it to >= 180, you won't have
 *  anything left for holding the clip on the bottle). For flexible materials
 *  like Ninjaflex, choose something near 0. For springy materials like PLA or
 *  ABS, 90 has proven to be a good value.
 * logo: the path to a DXF file representing a logo that should be put above
 *    the name. Logo files should be no larger than 50 units in height and should
 *    be centered on the point (25,25). Also all units in the DXF file should be
 *    in mm. This parameter can be empty; in this case, the text uses the total
 *    height of the name tag.
 * font: the path to a font for Write.scad.
 */



name = "name";
logo_offset = 0;
logo_size = 1.0;
offset_text = 0.0;
text_stretch = 1.0;

do_main = true;
logo = "logos/selfnet.dxf";
 
$fn=100;

module text_and_logo(ru, rl, ht, font, logo, name)
{
    if(logo == "")
    {
        writecylinder(name, [0,0,3], rl+0.5, ht/13*7, h=ht/13*8,
            t=max(rl,ru), font=font);
    }
    else
    {
        writecylinder(name, [0,0,0], rl-2*text_stretch, ht/13*7+offset_text, h=ht/13*4,
            t=max(rl,ru), font=font);
        translate([0,0,ht*3/4-0.1])
            rotate([90,0,0])
            scale([ht/130*logo_size,ht/130*logo_size,1])
            translate([-25,-35+logo_offset,0.5])
            linear_extrude(height=max(ru,rl)*2)
            import(logo);
    }
}

module bottle_clip(ru, rl, ht, width, name, gap, logo, font, do_main_cylinder)
{
    e=100;  // should be big enough, used for the outer boundary of the text/logo

    difference()
    {
        if (do_main_cylinder)
        {
            rotate([0,0,-45]) difference()
            {
                cylinder(r1=rl+width, r2=ru+width, h=ht);
                text_and_logo(ru, rl, ht, font, logo, name);
            }
        }
        else
        {
            rotate([0,0,-45])
            {
                text_and_logo(ru, rl, ht, font, logo, name);
            }
        }
        // inner cylinder which is substracted
        translate([0,0,-1])
            cylinder(r1=rl, r2=ru, h=ht+2);
        // outer cylinder which is substracted, so the text and the logo end
        // somewhere on the outside ;-)
        difference ()
        {
            cylinder(r1=rl+e, r2=ru+e, h=ht);
            translate([0,0,-1])
                // Note: bottom edges of characters are hard to print when character
                // depth is > 0.7
                cylinder(r1=rl+width+0.7, r2=ru+width+0.7, h=ht+2);
        }

        // finally, substract an equilateral triangle as a gap so we can clip it to
        // the bottle
        gap_x=50*sin(45-gap/2);
        gap_y=50*cos(45-gap/2);
        translate([0,0,-1])
            linear_extrude(height=50)
            polygon(points=[[0,0], [gap_x, gap_y], [50,50], [gap_y, gap_x]]);
    }
}

module bottle_clip_main(ru=13, rl=17.5, ht=26, width=1.8, name="", gap=90,
    logo="logos/selfnet.dxf", font="write/orbitron.dxf")
{
    rotate([0, 0, 45]) bottle_clip(ru, rl, ht, width, name, gap,
        logo, font, do_main_cylinder=true);
}

module bottle_clip_text_and_logo(ru=13, rl=17.5, ht=26, width=1.8, name="", gap=90,
    logo="logos/selfnet.dxf", font="write/orbitron.dxf")
{
    rotate([0, 0, 45]) bottle_clip(ru, rl, ht, width, name, gap,
        logo, font, do_main_cylinder=false);
}


if (do_main)
    bottle_clip_main(name=name, logo=logo);
else
    bottle_clip_text_and_logo(name=name, logo=logo);





