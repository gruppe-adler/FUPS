#define sideIndex(X) (FUPS_sideOrder find side X)

#define ASCENDING true
#define DESCENDING false

#define REDUCE(ARRAY,NEUTRAL,OPERATOR) call { private _a = ARRAY; private _r = NEUTRAL; _a apply { _r = _r OPERATOR _x; }; _r }
