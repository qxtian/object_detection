function o = IntervalsOverlapFalse( i1, i2 )
%INTERVALSOVERLAPFALSE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
o1 = i1(2)-i2(1);
o2 = i2(2)-i1(1);
o3 = i1(2)-i1(1);
o4 = i2(2)-i2(1);
o = max([o1 o2 o3 o4]);
o = max(o,0);

end

