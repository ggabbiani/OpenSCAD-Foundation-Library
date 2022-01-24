/*
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
include <../../foundation/grid.scad>

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

/* [Grid] */

GRID_TYPE   = "quad";   // [quad,hex]
GRID_CLIP   = false;
// draw the grid clipping bounding box
GRID_BBOX   = false;
BORDER      = [1,1];    // [0:0.05:20]
TRIM_ORIGIN = [0,0];      // [-10:0.1:+10]
QUAD_STEP = [6,6];  // [0:0.01:+10]
// radius of the polygon circumcircle used for creating 6 holes for each grid point
HEX_STEP    = 6;    // [0:0.1:10]

/* [Holes] */

// hole vertex number
HOLE_VERTICES = 50; // [3:1:50]
// hole diameter
HOLE_D        = 4.4;
// drill shape rotation about +Z
ROTATION    = 0;    // [0:360]

/* [Hidden] */

sheet_metal = [[0,0],[50,50]];
// the grid bounding box is equal to the sheet metal one reduced by border size
grid_bbox   = sheet_metal+[BORDER,-BORDER];

if (GRID_BBOX)
  translate(Z(NIL)) #fl_bb_add(grid_bbox,2d=true);

fl_color("silver")
  linear_extrude(0.5)
    difference() {
      // sheet metal
      fl_bb_add(sheet_metal,2d=true);
      // grid holes
      fl_grid_layout(
        origin  = TRIM_ORIGIN,
        step    = GRID_TYPE=="quad" ? QUAD_STEP : undef,
        r_step  = GRID_TYPE=="hex" ? HEX_STEP : undef,
        bbox    = grid_bbox,
        clip    = GRID_CLIP
      ) // hole shape
        rotate(ROTATION,+Z) fl_circle(d=HOLE_D,$fn=HOLE_VERTICES);
    }
