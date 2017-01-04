function recall = boxesEval( o )
% compute and gather all results (caches individual results to disk)
cnts=[1 2 5 10 20 50 100 200 500 1000 2000 5000 10000 15000];
M=length( cnts); T = 1; K=1;
gt=o.gt;
bbs = o.bbs;
n = length( bbs ); 
gt=gt(1:n);
recall=zeros(M,T,K); [ms,ts,ks]=ndgrid(1:M,1:T,1:K);
for i=13:M*T*K, m=ms(i); t=ts(i); k=ks(i);
  % if evaluation result exists simply load i  
  bbs1 = cell( n , 1 );
  for j = 1 : n 
      temp = bbs{j};
      pick = nms( temp, 0.7 );
      temp = temp(pick,:);
      bbs1{j} = temp(1:min(end, cnts(m)),:); 
  end
  [gt1,bbs1]=bbGt('evalRes',gt,bbs1,0.7 );
  [xs,ys,r,ref,ap]=bbGt('compRoc',gt1,bbs1,0); 
  r=max(xs); 
  recall(i)=r;
end
end

