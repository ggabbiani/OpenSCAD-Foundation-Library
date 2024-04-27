/*
 *  * HiLetgo SX1308 DC-DC Step up power module is built as a custom pcb.
 * See https://www.amazon.it/gp/product/B07ZYW68C4/ for the stepup specs
 *
 * NOTE: this file is generated automatically from 'template-3d.scad', any
 * change will be lost.
 *
 * Copyright © 2021, Giampiero Gabbiani <giampiero@gabbiani.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */


include <../../lib/OFL/vitamins/pcbs.scad>


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
// adds a box representing the payload of the shape
$FL_PAYLOAD   = "OFF";  // [OFF,ON,ONLY,DEBUG,TRANSPARENT]


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


/* [Custom PCB] */

// FL_DRILL and FL_CUTOUT thickness
T             = 2.5;


/* [Hidden] */

direction = DIR_NATIVE    ? undef : [DIR_Z,DIR_R];
octant    = fl_parm_Octant(X_PLACE,Y_PLACE,Z_PLACE);
debug     = fl_parm_Debug(SHOW_LABELS,SHOW_SYMBOLS);

fl_status();

// end of automatically generated code

verbs=[
  if ($FL_ADD!="OFF")       FL_ADD,
  if ($FL_ASSEMBLY!="OFF")  FL_ASSEMBLY,
  if ($FL_AXES!="OFF")      FL_AXES,
  if ($FL_BBOX!="OFF")      FL_BBOX,
  if ($FL_CUTOUT!="OFF")    FL_CUTOUT,
  if ($FL_DRILL!="OFF")     FL_DRILL,
  if ($FL_FOOTPRINT!="OFF") FL_FOOTPRINT,
  if ($FL_LAYOUT!="OFF")    FL_LAYOUT,
  if ($FL_PAYLOAD!="OFF")   FL_PAYLOAD,
];

pcb = let(
    pcb_t = 1.6,
    sz    = [23,16,pcb_t],
    // holes positions
    holes = [for(x=[-sz.x/2+2.5,+sz.x/2-2.5],y=[-sz.y/2+2.5,+sz.y/2-2.5]) [x,y,0]],
    1PIN  = fl_PinHeader("1-pin",nop=2p54header,engine="male"),
    comps = [
      //["label", ["engine",   [position        ],  [[director],rotation],  type,           [engine specific parameters]]]
      ["TRIMPOT", fl_Component(FL_TRIM_NS,[-5,-sz.y/2+0.5,0],[+Y,0],[+Z],FL_TRIM_POT10,[[FL_COMP_OCTANT,+X-Y+Z]])],
      // create four component specifications, one for each hole position, labelled as "PIN-0", "PIN-1", "PIN-2", "PIN-3"
      for(i=[0:len(holes)-1]) let(label=str("PIN-",i))
        [label,   fl_Component(FL_PHDR_NS,holes[i],[+Z,0],[+Z],1PIN)],
    ]
  ) fl_PCB(
    name  = "HiLetgo SX1308 DC-DC Step up power module",
    // bare (i.e. no payload) pcb's bounding box
    bare  = [[-sz.x/2,-sz.y/2,-sz.z],[+sz.x/2,+sz.y/2,0]],
    // pcb thickness
    thick = pcb_t,
    color  = "DarkCyan",
    holes = let(r=0.75,d=r*2) [for(i=[0:len(holes)-1]) fl_Hole(holes[i],d,+Z,0,screw=M2_cap_screw)],
    components=comps
  );

fl_pcb(verbs,pcb,direction=direction,octant=octant,thick=T);
