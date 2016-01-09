#include "..\..\header\header.hpp"

params ["_pos","_dist","_dir"];

[(_pos select 0) + _dist*sin _dir, (_pos select 1) + _dist*cos _dir,0]