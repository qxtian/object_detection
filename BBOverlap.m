function [ overlap ] = BBOverlap(dt,gt)

% which percentage of BB1 overlaps with BB2 ?
%
% format:
% BB = [min_x  max_x
%       min_y  max_y]
%
de = dt(:,[1 2]) + dt(:,[3 4]); da = dt(:,3).*dt(:,4);
ge = gt(:,[1 2]) + gt(:,[3 4]); ga = gt(:,3).*gt(:,4);

w = min( de(1,1),ge(1,1)) - max(dt(1,1),gt(1,1)); if( w<=0 ), w = 0 ; end
h = min( de(1,2),ge(1,2)) - max(dt(1,2),gt(1,2)); if( h<=0 ), h = 0 ; end
t = w*h; 
u = da + ga - t; 
overlap = t/u;

