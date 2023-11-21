/*
 * PCB frame test.
 *
 * Copyright © 2021, Giampiero Gabbiani (giampiero@gabbiani.org)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
include <../../lib/OFL/vitamins/pcbs.scad>

$fn           = 50;   // [3:100]
// When true, disables epsilon corrections
$FL_RENDER    = false;
// -2⇒none, -1⇒all, [0..)⇒max depth allowed
$FL_TRACES    = -2;   // [-2:10]
$fl_debug     = false;
SHOW_LABELS   = false;
SHOW_SYMBOLS  = false;
$fl_filament  = "DodgerBlue"; // [DodgerBlue,Blue,OrangeRed,SteelBlue]

/* [Supported verbs] */

// adds shapes to scene.
$FL_ADD       = "ON";   // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of predefined auxiliary shapes (like predefined screws)
$FL_ASSEMBLY  = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds local reference axes
$FL_AXES      = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds a bounding box containing the object
$FL_BBOX      = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of predefined cutout shapes (+X,-X,+Y,-Y,+Z,-Z)
$FL_CUTOUT    = "OFF";   // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of predefined drill shapes (like holes with predefined screw diameter)
$FL_DRILL     = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds a footprint to scene, usually a simplified FL_ADD
$FL_FOOTPRINT = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// layout of user passed accessories (like alternative screws)
$FL_LAYOUT    = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// mount shape through predefined screws
$FL_MOUNT      = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// adds a box representing the payload of the shape
$FL_PAYLOAD   = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]
// add symbols and labels usually for debugging
$FL_SYMBOLS   = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]

/* [Placement] */

PLACE_NATIVE  = true;
OCTANT        = [0,0,0];  // [-1:+1]

/* [Direction] */

DIR_NATIVE  = true;
// ARBITRARY direction vector
DIR_Z       = [0,0,1];  // [-1:0.1:+1]
// rotation around
DIR_R       = 0;        // [0:360]

/* [PCB Frame] */

PCB = "HiLetgo SX1308 DC-DC Step up power module"; // ["HiLetgo SX1308 DC-DC Step up power module", "ORICO 4 Ports USB 3.0 Hub 5 Gbps with external power supply port", "Perfboard 70 x 50mm", "Perfboard 60 x 40mm", "Perfboard 70 x 30mm", "Perfboard 80 x 20mm", "RPI4-MODBP-8GB", "Raspberry PI uHAT", "KHADAS-SBC-VIM1"]
LAYOUT  = "auto"; // [auto,horizontal,vertical]
// nominal screw ⌀
D   = 3;  // [2,2.5,3,4,5,6,8]
COUNTERSINK = false;
LEFT  = true;
RIGHT = true;
// distance between holes and external frame dimensions
WALL = 1.5; // [0.5:0.1:3]
// top and bottom surface thickness
FACE_T = 1.2;   // [.5:.1:3]
// overlap along major pcb dimension
WIDE_OVER = 4; // [0.1:0.1:10]
// overlap along minor pcb dimension
THIN_OVER = 1;  // [0:0.1:10]
// size along major pcb dimension, laterally surrounding the pcb
INCLUSION = 10; // [0.1:20]
TOLERANCE=0;  // [0:0.1:1]

/* [Hidden] */

fl_status();
direction = DIR_NATIVE    ? undef : [DIR_Z,DIR_R];
octant    = PLACE_NATIVE  ? undef : OCTANT;
debug     = fl_parm_Debug(SHOW_LABELS,SHOW_SYMBOLS);

verbs = fl_verbList([
  FL_ADD,
  FL_ASSEMBLY,
  FL_AXES,
  FL_BBOX,
  FL_CUTOUT,
  FL_DRILL,
  FL_FOOTPRINT,
  FL_LAYOUT,
  FL_MOUNT,
  FL_PAYLOAD,
  FL_SYMBOLS
]);



pcb   = fl_pcb_select(PCB);
frame = fl_pcb_Frame(pcb,d=D,faces=FACE_T,wall=WALL,overlap=[WIDE_OVER,THIN_OVER],inclusion=INCLUSION,countersink=COUNTERSINK,layout=LAYOUT);

fl_pcb_frame(verbs,frame,parts=[LEFT,RIGHT],tolerance=TOLERANCE,debug=debug,octant=octant);