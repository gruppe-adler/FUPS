#include "..\..\header\header.hpp"

params [["_pos",[0,0,0],[[]],[2,3]],["_dist",0,[0]],["_dir",0,[0]]];

[(_pos select 0) + _dist*sin _dir, (_pos select 1) + _dist*cos _dir,0]