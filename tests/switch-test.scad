/*
 * fl_switch() language extension tests
 *
 * NOTE: this file is generated automatically from 'template-nogui.scad', any
 * change will be lost.
 *
 * This file is part of the 'OpenSCAD Foundation Library' (OFL) project.
 *
 * Copyright © 2021, Giampiero Gabbiani <giampiero@gabbiani.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

// **** TEST_INCLUDES *********************************************************

include <../lib/OFL/foundation/core.scad>

// **** TEST_PROLOGUE *********************************************************

fl_status();

// end of automatically generated code

let(
  value  = 2.5,
  result = fl_switch(value,[
      [2,  3.2],
      [2.5,4.0],
      [3,  4.0],
      [5,  6.4],
      [6,  8.0],
      [8,  9.6]
    ]
  ),
  expected = 4.0
) echo(result=result) assert(result==expected,result);

let(
  value  = 2.5,
  result = fl_switch(value,[
      [function(e) (e<0),  "negative"],
      [0,                  "null"    ],
      [function(e) (e>0),  "positive"]
    ]
  ),
  expected = "positive"
) echo(result=result) assert(result==expected,result);

let(
  value  = 2.5,
  result = fl_switch(value,[
      [function(e) (e<0),  "negative"],
      [0,                  "null"    ],
    ]
  ),
  expected = undef
) echo(result=result) assert(result==expected,result);

let(
  value  = 2.5,
  result = fl_switch(value,[
      [function(e) (e<0),  "negative"],
      [0,                  "null"    ],
    ],
    "default"
  ),
  expected = "default"
) echo(result=result) assert(result==expected,result);
