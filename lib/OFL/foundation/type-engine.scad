/*
 * OFL type helpers
 *
 * This file is part of the 'OpenSCAD Foundation Library' (OFL) project.
 *
 * Copyright © 2021, Giampiero Gabbiani <giampiero@gabbiani.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <core.scad>

use <bbox-engine.scad>

function fl_Object(
  //! mandatory bounding-box
  bbox,
  //! optional payload
  pload,
  //! optional name
  name,
  //! optional description
  description,
  //! optional engine
  engine,
  //! optional other key/value list
  others=[]
) = concat( [
                    fl_native(value=true),
                    fl_bb_corners(value=bbox),
  if (name)         fl_name(value=name),
  if (description)  fl_description(value=description),
  if (engine)       fl_engine(value=engine),
  if (pload)        fl_payload(value=pload),
], others);
