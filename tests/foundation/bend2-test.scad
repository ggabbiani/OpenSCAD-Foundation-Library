/*
 * Vitamins test template.
 *
 * Copyright © 2021 Giampiero Gabbiani (giampiero@gabbiani.org)
 *
 * This file is part of the 'OpenSCAD Foundation Library' (OFL).
 *
 * OFL is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OFL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OFL.  If not, see <http: //www.gnu.org/licenses/>.
 */
include <../../foundation/unsafe_defs.scad>
include <../../foundation/incs.scad>
include <../../vitamins/incs.scad>

$fn         = 50;           // [3:100]
// Debug statements are turned on
$FL_DEBUG   = false;
// When true, disables PREVIEW corrections like FL_NIL
$FL_RENDER  = false;
// When true, unsafe definitions are not allowed
$FL_SAFE    = false;
// When true, fl_trace() mesages are turned on
$FL_TRACE   = false;

$FL_FILAMENT  = "DodgerBlue"; // [DodgerBlue,Blue,OrangeRed,SteelBlue]

/* [Supported verbs] */

// adds shapes to scene.
ADD       = "ON";   // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of predefined auxiliary shapes (like predefined screws)
ASSEMBLY  = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds local reference axes
AXES      = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds a bounding box containing the object
BBOX      = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of predefined cutout shapes (+X,-X,+Y,-Y,+Z,-Z)
CUTOUT    = "OFF";   // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of predefined drill shapes (like holes with predefined screw diameter)
DRILL     = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds a footprint to scene, usually a simplified FL_ADD
FPRINT    = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of user passed accessories (like alternative screws)
LAYOUT    = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds a box representing the payload of the shape
PLOAD     = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]

/* [Placement] */

PLACE_NATIVE  = true;
OCTANT        = [0,0,0];  // [-1:+1]

/* [Direction] */

DIR_NATIVE  = true;
// ARBITRARY direction vector
DIR_Z       = [0,0,1];  // [-1:0.1:+1]
// rotation around
DIR_R       = 0;        // [0:360]

/* [grid] */

// folding thickness
T           = 0.5;
// inter drill shape distance
DELTA       = 1.60;
// drill shape diameter
D           = 4.4;
// hole edge number for grid 1
EDGES_1 = 50; // [3:1:50]
// drill rotation about +Z on grid 1
ROT_1   = 0;  // [0:360]
// hole edge number for grid 2
EDGES_2 = 50; // [3:1:50]
// drill rotation about +Z on grid 2
ROT_2    = 0; // [0:360]
// when true folding is NOT bent
FLAT        = false;
BREAK   = 0.5;  // [0:0.1:10]
/* [Hidden] */

direction = DIR_NATIVE    ? undef : [DIR_Z,DIR_R];
octant    = PLACE_NATIVE  ? undef : OCTANT;
verbs=[
  if (ADD!="OFF")       FL_ADD,
  if (ASSEMBLY!="OFF")  FL_ASSEMBLY,
  if (AXES!="OFF")      FL_AXES,
  if (BBOX!="OFF")      FL_BBOX,
  if (CUTOUT!="OFF")    FL_CUTOUT,
  if (DRILL!="OFF")     FL_DRILL,
  if (FPRINT!="OFF")    FL_FOOTPRINT,
  if (LAYOUT!="OFF")    FL_LAYOUT,
  if (PLOAD!="OFF")     FL_PAYLOAD,
];

// $FL_ADD=ADD;$FL_ASSEMBLY=ASSEMBLY;$FL_AXES=AXES;$FL_BBOX=BBOX;$FL_CUTOUT=CUTOUT;$FL_DRILL=DRILL;$FL_FOOTPRINT=FPRINT;$FL_LAYOUT=LAYOUT;$FL_PAYLOAD=PLOAD;

size=[51,78,28];
surfaces=[
  [-X,[size.z,size.y,T]],
  [+Z,[size.x,size.y,T]],
  [+Y,[size.x,size.z,T]],
  [-Y,[size.x,size.z/3,T]], 
  [+X,[size.z,size.y,T]],
  [-Z,[size.x,size.y,T]],
];

shift = D + DELTA;
folding = fl_folding(faces=surfaces);

fl_bend(verbs,type=folding,flat=FLAT,octant=octant,direction=direction)
  // bending algorithm requires a 3d shape
  linear_extrude(fl_bb_size($sheet).z) 
    difference() {
      fl_bb_add(corners=fl_bb_corners($sheet),2d=true);
      let(thick=BREAK+T) {
        let(size=$size[3]) translate($H-Y(thick)) fl_square(size=[size.y,thick,size.z],quadrant=+X+Y);
        let(size=$size[4]) translate($F-X(thick)) fl_square(size=[thick,size.y,size.z],quadrant=+X+Y);
        let(size=$size[5]) translate($P-X(thick)) fl_square(size=[thick,size.y,size.z],quadrant=+X+Y);
        let(size=$size[1]) translate($E-X(thick)) fl_square(size=[thick,size.y,size.z],quadrant=+X+Y);
        let(size=$size[3]) translate($I-X(thick)) fl_square(size=[thick,size.y,size.z],quadrant=+X+Y);
      }
    }
