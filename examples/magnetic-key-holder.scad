/*
 * Magnetic key-holder example.
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

include <../foundation/unsafe_defs.scad>
include <../foundation/incs.scad>
include <../vitamins/incs.scad>

$fn         = 50;           // [3:100]
// When true, disables PREVIEW corrections like FL_NIL
$FL_RENDER  = false;
// When true, unsafe definitions are not allowed
$FL_SAFE    = false;
// When true, fl_trace() mesages are turned on
$FL_TRACE   = false;

FILAMENT  = "DodgerBlue"; // [DodgerBlue,Blue,OrangeRed,SteelBlue]

/* [Supported verbs] */

// adds shapes to scene.
ADD       = "ON";   // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of predefined auxiliary shapes (like predefined screws)
ASSEMBLY  = "ON";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds a bounding box containing the object
BBOX      = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]

/* [Magnetic Key Holder] */

// type of magnet to use
MAGNET        = "M4_cs_magnet32x6"; // [M3_cs_magnet10x2,M3_cs_magnet10x5,M4_cs_magnet32x6]
// number of magnets
NUM_MAGS      = 4;
// extra gap between adiacent magnets
GAP           = 10;
// thickness of the rectangular base
BASE_T        = 1;
// thickness of the holder cylinder
HOLDER_T      = 1;
// fl_JNgauge=0.15
TOLERANCE     = 0.15; // [0:0.01:1]
// fillet radius
FILLET_R      = 4;    // [1:0.5:6]
// vertical fillet steps
FILLET_STEPS  = 20;

/* [Hidden] */

magnet  = MAGNET=="M3_cs_magnet10x2"  ? FL_MAG_M3_CS_10x2 
        : MAGNET=="M3_cs_magnet10x5"  ? FL_MAG_M3_CS_10x5 
        : FL_MAG_M4_CS_32x6;

function cyl_d(
  magnet,
  edge_thick,
  tolerance
) = 
assert(is_list(magnet),magnet)
assert(is_num(edge_thick),edge_thick)
assert(is_num(tolerance),tolerance)
fl_mag_d(magnet) + 2*edge_thick + tolerance;

function cyl_h(magnet) = fl_thickness(magnet) - 1;

function bb_element(
  magnet,
  fill_r,               // fillet radius
  fill_n,               // number of steps along Z axis
  edge_thick,
  base_thick,
  tolerance,
  horiz_gap
) = 
assert(is_list(magnet),magnet)
assert(is_num(fill_r),fill_r)
assert(is_num(fill_n),fill_n)
assert(is_num(edge_thick),edge_thick)
assert(is_num(base_thick),base_thick)
assert(is_num(tolerance),tolerance)
assert(is_num(horiz_gap),horiz_gap)
let(
    child_bbox  = fl_bb_circle(d=cyl_d(magnet,edge_thick,tolerance)),
    bb          = fl_bb_90DegFillet(fill_r,fill_n,child_bbox)
  ) [[bb[0].x-horiz_gap/2,bb[0].y,-base_thick],[bb[1].x+horiz_gap/2,bb[1].y,cyl_h(magnet)]];


module element(
  verbs       = FL_ADD, // supported verbs: FL_ADD, FL_ASSEMBLY, FL_BBOX, FL_DRILL, FL_FOOTPRINT, FL_LAYOUT
  magnet,
  fill_r,               // fillet radius
  fill_n,               // number of steps along Z axis
  edge_thick,           // thickness of the cylinder
  base_thick,           // thickness for base
  tolerance,            // tolerance used
  horiz_gap,
  direction,            // desired direction [director,rotation], native direction when undef ([+X+Y+Z])
  octant,               // when undef native positioning is used
) {
  assert(is_list(verbs)||is_string(verbs),verbs);
  fl_trace("horizontal gap",horiz_gap);

  axes  = fl_list_has(verbs,FL_AXES);
  verbs = fl_list_filter(verbs,FL_EXCLUDE_ANY,FL_AXES);

  mag_d       = fl_mag_d(magnet);
  mag_h       = fl_thickness(magnet);
  cyl_d       = cyl_d(magnet,edge_thick,tolerance);
  cyl_h       = cyl_h(magnet);
  child_bbox  = fl_bb_circle(d=cyl_d);
  bbox        = bb_element(magnet,fill_r,fill_n,edge_thick,base_thick,tolerance,horiz_gap);
  size        = bbox[1]-bbox[0];
  D           = direction ? fl_direction(direction=direction,default=[+Z,+X]) : I;
  M           = octant    ? fl_octant(octant=octant,bbox=bbox)                : I;

  module do_add() {
    fl_color($FL_FILAMENT) {
      // magnet holder
      difference() {
        union() {
          fl_cylinder(d=cyl_d,h=cyl_h,octant=+Z);
          fl_90DegFillet(r=fill_r,n=fill_n,child_bbox=child_bbox) 
            fl_circle(d=cyl_d);
        }
        translate(-Z(NIL)) 
          fl_magnet([FL_FOOTPRINT,FL_DRILL],magnet,thick=base_thick+NIL,fp_gross=tolerance);
      }
      // base
      difference() {
        fl_cube(size=[size.x,size.y,base_thick],octant=-Z);
        do_drill();
      }
    }
  }

  module do_assembly() {
    fl_magnet([FL_ADD,FL_ASSEMBLY],magnet,thick=base_thick);
    // do_layout() 
    //   fl_screw(FL_ADD,fl_mag_screw(magnet),thick=base_thick,nut="default");
  }

  module do_drill() {
    fl_magnet(FL_DRILL,magnet,thick=base_thick+NIL,fp_gross=tolerance);
  }

  module do_layout() {
    // children();
  }

  multmatrix(D) {
    multmatrix(M) fl_parse(verbs) {
      if ($verb==FL_ADD) {
        fl_modifier($FL_ADD) do_add();
      } else if ($verb==FL_BBOX) {
        fl_modifier($FL_BBOX) fl_bb_add(bbox);
      } else if ($verb==FL_LAYOUT) {
        fl_modifier($FL_LAYOUT) do_layout()
          children();
      } else if ($verb==FL_ASSEMBLY) {
        fl_modifier($FL_ASSEMBLY) do_assembly();
      } else if ($verb==FL_DRILL) {
        fl_modifier($FL_DRILL) do_drill();
      } else {
        assert(false,str("***UNIMPLEMENTED VERB***: ",$verb));
      }
    }
    if (axes)
      fl_modifier($FL_AXES) fl_axes(size=size);
  }
}

verbs=[
  if (ADD!="OFF")       FL_ADD,
  if (ASSEMBLY!="OFF")  FL_ASSEMBLY,
  if (BBOX!="OFF")      FL_BBOX,
];

element=[
  fl_name(value="Magnetic key-holder element"),
  fl_bb_corners(value=bb_element(magnet,FILLET_R,FILLET_STEPS,HOLDER_T,BASE_T,TOLERANCE,GAP))
];
fl_trace("element",element);

strip=[for(i=[1:NUM_MAGS]) element];
fl_trace("strip",strip);

strip_bb =lay_bb_corners(+X,0,strip);
fl_trace("strip bounding box",strip_bb);

fl_layout(axis=+X,gap=0,types=strip,octant=+Z)
  element(verbs,magnet,FILLET_R,FILLET_STEPS,HOLDER_T,BASE_T,TOLERANCE,GAP,$FL_ASSEMBLY=ASSEMBLY,$FL_ADD=ADD,$FL_BBOX=BBOX);
