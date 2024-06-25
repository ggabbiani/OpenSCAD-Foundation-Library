/*
 * fl_polymorph{} usage example, implementing a NopSCADlib IEC wrapper engine.
 *
 * NOTE: this file is generated automatically from 'template-3d.scad', any
 * change will be lost.
 *
 * This file is part of the 'OpenSCAD Foundation Library' (OFL) project.
 *
 * Copyright © 2021, Giampiero Gabbiani <giampiero@gabbiani.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */


include <../../lib/NopSCADlib/core.scad>
include <../../lib/NopSCADlib/vitamins/iecs.scad>

include <../../lib/OFL/vitamins/screw.scad>

use <../../lib/OFL/foundation/polymorphic-engine.scad>


$fn            = 50;           // [3:100]
// When true, debug statements are turned on
$fl_debug      = false;
// When true, disables PREVIEW corrections like FL_NIL
$FL_RENDER     = false;
// Default color for printable items (i.e. artifacts)
$fl_filament   = "DodgerBlue"; // [DodgerBlue,Blue,OrangeRed,SteelBlue]
// -2⇒none, -1⇒all, [0..)⇒max depth allowed
$FL_TRACES     = -2;     // [-2:10]
SHOW_LABELS     = false;
SHOW_SYMBOLS    = false;
SHOW_DIMENSIONS = false;


/* [Supported verbs] */

// adds shapes to scene.
$FL_ADD       = "ON";   // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds local reference axes
$FL_AXES      = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds a bounding box containing the object
$FL_BBOX      = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of predefined cutout shapes (+X,-X,+Y,-Y,+Z,-Z)
$FL_CUTOUT    = "OFF";   // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of predefined drill shapes (like holes with predefined screw diameter)
$FL_DRILL     = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of user passed accessories (like alternative screws)
$FL_LAYOUT    = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// mount shape through predefined screws
$FL_MOUNT      = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]


/* [3D Placement] */

X_PLACE = "undef";  // [undef,-1,0,+1]
Y_PLACE = "undef";  // [undef,-1,0,+1]
Z_PLACE = "undef";  // [undef,-1,0,+1]


/* [Direction] */

DIR_NATIVE  = true;
// ARBITRARY direction vector
DIR_Z       = [0,0,1];  // [-1:0.1:+1]
// rotation around
DIR_R       = 0;        // [-360:360]



/* [Polymorph] */

T             = 2.5;  // [0:0.1:5]


/* [Hidden] */

direction = DIR_NATIVE    ? undef : [DIR_Z,DIR_R];
octant    = fl_parm_Octant(X_PLACE,Y_PLACE,Z_PLACE);
debug     = fl_parm_Debug(SHOW_LABELS,SHOW_SYMBOLS,dimensions=SHOW_DIMENSIONS);

fl_status();

// end of automatically generated code

verbs = fl_verbList([FL_ADD,FL_AXES,FL_BBOX,FL_CUTOUT,FL_DRILL,FL_LAYOUT,FL_MOUNT]);

module engine(thick) let(
  nop   = fl_nopSCADlib($this),
  screw = iec_screw(nop)
) if ($this_verb==FL_ADD)
    iec(nop);

  else if ($this_verb==FL_AXES)
    fl_doAxes($this_size,$this_direction);

  else if ($this_verb==FL_BBOX)
    fl_bb_add(corners=$this_bbox,$FL_ADD=$FL_BBOX);

  else if ($this_verb==FL_CUTOUT) {
    assert(is_num(thick))
    if (thick>=0)
      iec_holes(nop, h=thick+iec_flange_t(nop));

  } else if ($this_verb==FL_DRILL) {
    assert(is_num(thick))
    if (thick)
      iec_screw_positions(nop)
        fl_screw(FL_DRILL,screw,thick=thick);

  } else if ($this_verb==FL_LAYOUT) {
    translate(+Z(iec_flange_t(nop)))
      iec_screw_positions(nop) let(
        $iec_screw = screw
      ) children();

  } else if ($this_verb==FL_MOUNT)
    assert(is_num(thick)&&thick>=0)
    iec_assembly(nop, thick);
  else
    assert(false,str("***OFL ERROR***: unimplemented verb ",$this_verb));

iec = let(
  nop     = IEC_inlet,
  w       = iec_width(nop),
  h       = iec_flange_h(nop),
  spades  = iec_spades(nop)
) [
  fl_native(value=true),
  fl_bb_corners(value=[[-w/2,-h/2,-iec_depth(nop)-spades[0][1]],[+w/2,+h/2,+iec_flange_t(nop)+iec_bezel_t(nop)]]),
  fl_nopSCADlib(value=nop),
  fl_screw(value=iec_screw(nop)),
  fl_engine(value="iec"),
];

fl_polymorph(verbs,iec,octant,direction)
  engine(thick=T)
    fl_cylinder(h=10,r=screw_radius($iec_screw),octant=-Z);
