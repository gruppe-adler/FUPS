params ["_marker"];
private ["_markerpos","_markerdir","_markersize","_markerrelpos"];
_markerpos		= getMarkerPos _marker;
_markerdir		= markerDir _marker;
_markersize		= getmarkerSize _marker;
_markerrelpos	= [(_markerpos select 0) + (sin _markerdir), (_markerpos select 1) + (cos _markerdir),0];

private "_markervector";
_markervector	= _markerpos vectorFromTo _markerrelpos;
_markervector	= _markervector vectorMultiply 2*(_markersize select 1);

private "_markervector_1";
_markervector_1	= [(_markervector select 1),-(_markervector select 0),0];
_markervector_1	= vectorNormalized _markervector_1;
_markervector_1	= _markervector_1 vectorMultiply 2*(_markersize select 0);

// set all to the lower right corner of the marker
private "_markerpos";
_markerpos = _markerpos vectorAdd ((_markervector vectorMultiply -0.5) vectorAdd (_markervector_1 vectorMultiply -0.5));

private "_mindist";
_mindist = (vectorMagnitude (_markervector vectorAdd _markervector_1)) / 4;

[_markerpos,_mindist,_markervector,_markervector_1,_markerdir]
