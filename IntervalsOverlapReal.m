function o = IntervalsOverlapReal(i1, i2)

% overlap between two intervals i1, i2
% (sorted in ascending order)
% Real numbers (no integers)
%

o1 = i1(2)-i2(1);
o2 = i2(2)-i1(1);
o3 = i1(2)-i1(1);
o4 = i2(2)-i2(1);
o = min([o1 o2 o3 o4]);
o = max(o,0);
