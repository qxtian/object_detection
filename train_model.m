function [ output_args ] = train_model( fdatabase,class_name,trn_ixs  )

fea = [];
label = [];
trn_num = length( trn_ixs );
for train_img_idx = trn_ixs' 
    if train_img_idx == 60
        train_img_idx;
    end
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
    [fea1 , label1 ] = fea2label( feas, bbs, gtBB);
    fea = [ full( fea1' ) ;fea];
    label = [label1' ;label ];   
end

bestcv = 0;
for log2c = 5:25,
    options = ['-v 5 -c ' ,num2str( 2^log2c ), '-w1 10 -w-1 1' ];
    cv = svmtrain( label , fea,  options );
    if ( cv >= bestcv),
        bestcv = cv; bestc = 2^log2c; 
        fprintf('%g %g (best c=%g, rate=%g)\n', log2c, cv, bestc, bestcv);

    end
end
 options = [ '-b 1 -c ', num2str( bestc)  , '-w1 10 -w-1 1' ];
 model = svmtrain( label , fea,  options );
 if ~exist( ['result/' lower( class_name ) ],'dir')
     mkdir(['result/' lower( class_name ) ]);
 end
 savemodel(['result/' lower( class_name ) '/' lower(class_name) '.model'], model);

end

