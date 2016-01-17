#include "..\..\header\header.hpp"

params ["_obj"];

count (_obj nearObjects ["Building",25]) > 1
