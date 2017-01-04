function [ w,b ] = train_rmisvm( fdatabase,class_name,trn_ixs)

fea = [];
labels = [];
trn_num = length( trn_ixs );
count = 0;
for train_img_idx = trn_ixs' 
    fprintf('process train image: %d of %d\n', train_img_idx, trn_num );
    fpath = fdatabase.path{ train_img_idx } ;
    load( fpath , 'feas','bbs');
    dim =  size( feas,1);
    t_base = fpath(1 : length(fpath) - 8 - 7 );
    idd = strfind( t_base,'/');
    name = t_base( idd(end) + 1 : end);
    
    gt_fname = [t_base '_' lower( class_name ) '.groundtruth'];
    gtBB = load( gt_fname );
    if 0
        imshow( [t_base '_edges.bmp']); hold on;
        for jj = 1 : size( gtBB,1)
            rectangle('position',[gtBB(jj,1) gtBB(jj,2) gtBB(jj,3)- gtBB(jj,1) gtBB(jj,4) - gtBB(jj,2)] , 'LineWidth',2,'LineStyle','--', 'EdgeColor','c');
        end
    end
    [fea1,fea2,label] = fea2bag( feas, bbs,gtBB );
    count = count + 1;
    fea{count } = fea1;
    count = count + 1;
    fea{count } = fea2;
    labels = [label labels ];
end

option.gamma = 1;
option.threshold = 0.5;
option.lambda = 0.02;
option.m0 = 0.2;
option.beta = 6;
[w ,b ] = rmisvm(fea,labels,option);
% ii = 0;
% for l = 5:20,
%     for m = 2 : 20
%         for b = 4 : 8
%             ii = ii + 1;
%             option.lambda = l / 100;
%             option.m0 = m / 10;
%             option.beta = b;
%             [w(:,ii),b(:,ii )] = rmisvm(fea,labels,option);
%         end
%     end
% end

end

