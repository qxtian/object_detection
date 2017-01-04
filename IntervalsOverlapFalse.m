function o = IntervalsOverlapFalse( i1, i2 )
%INTERVALSOVERLAPFALSE 此处显示有关此函数的摘要
%   此处显示详细说明
o1 = i1(2)-i2(1);
o2 = i2(2)-i1(1);
o3 = i1(2)-i1(1);
o4 = i2(2)-i2(1);
o = max([o1 o2 o3 o4]);
o = max(o,0);

end

