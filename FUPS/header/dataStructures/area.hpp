/*

	AREA holds data about a area to patrol in, etc.
	Format:
		0 <STRING> - identifier
		1 <ARRAY format POSITION> - origin of the area
		2 <SCALAR> - mindist for each waypoint to be apart of the current position
		3 <ARRAY format VECTOR> - y axis of the area
		4 <ARRAY format VECTOR> - x axis of the area
		5 <SCALAR> - direction difference to zero degrees

	PARAMS will name variables:
		_origin, _mindist, _xAxis, _yAxis, _dir

*/

// Basic values
#define AREA_VAL			[]
#define AREA_IDENT_VAL		"area"
#define AREA_ORIGIN_VAL		[0,0,0]
#define AREA_MINDIST_VAL	0
#define AREA_YAXIS_VAL		[0,0,0]
#define AREA_XAXIS_VAL		[0,0,0]
#define AREA_DIR_VAL		0

// AREA DATA
#define AREA_NEW()			(0 call { \
 	private _struct = AREA_VAL; \
 	_struct set [AREA_IDENT_INDEX,AREA_IDENT_VAL]; \
 	_struct set [AREA_ORIGIN_INDEX,AREA_ORIGIN_VAL]; \
 	_struct set [AREA_MINDIST_INDEX,AREA_MINDIST_VAL]; \
 	_struct set [AREA_YAXIS_INDEX,AREA_YAXIS_VAL]; \
 	_struct set [AREA_XAXIS_INDEX,AREA_XAXIS_VAL]; \
 	_struct set [AREA_DIR_INDEX,AREA_DIR_VAL]; \
 	_struct \
})

#define AREA_VALID(X) 		((X isEqualTypeParams AREA_NEW()) && {X select AREA_IDENT_INDEX == AREA_IDENT_VAL})

#define AREA_IDENT_INDEX	0
#define AREA_ORIGIN_INDEX	1
#define AREA_MINDIST_INDEX	2
#define AREA_YAXIS_INDEX	3
#define AREA_XAXIS_INDEX	4
#define AREA_DIR_INDEX		5

#define AREA_ORIGIN(X)		(X select AREA_ORIGIN_INDEX)
#define AREA_MINDIST(X)		(X select AREA_MINDIST_INDEX)
#define AREA_YAXIS(X)		(X select AREA_YAXIS_INDEX)
#define AREA_XAXIS(X)		(X select AREA_XAXIS_INDEX)
#define AREA_DIR(X)			(X select AREA_DIR_INDEX)

#define AREA_PARAMS(X)		X params ["","_origin","_mindist","_yAxis","_xAxis","_dir"]

#define AREA_SET_ORIGIN(X,ORG)		private _check = AREA_ORIGIN_VAL; TYPEMATCH_ARR(ORG,_check); (X set [AREA_ORIGIN_INDEX,ORG])
#define AREA_SET_MINDIST(X,DIST)	TYPEMATCH(DIST,AREA_MINDIST_VAL); (X set [AREA_MINDIST_INDEX,DIST])
#define AREA_SET_YAXIS(X,AXIS)		private _check = AREA_YAXIS_VAL; TYPEMATCH_ARR(AXIS,_check); (X set [AREA_YAXIS_INDEX,AXIS])
#define AREA_SET_XAXIS(X,AXIS)		private _check = AREA_XAXIS_VAL; TYPEMATCH_ARR(AXIS,_check); (X set [AREA_XAXIS_INDEX,AXIS])
#define AREA_SET_DIR(X,DIR)			TYPEMATCH(DIR,AREA_DIR_VAL); (X set [AREA_DIR_INDEX,DIR])
