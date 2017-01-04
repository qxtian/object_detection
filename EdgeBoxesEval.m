clear;clc;
% model=load('models/forest/modelBsds'); model=model.model;
% model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;
% model.opts.multiscale=0; 
% model.opts.sharpen=2; model.opts.nThreads=4;
% opts = edgeBoxes;
% opts.alpha = .65;     % step size of sliding window search
% opts.beta  = .75;     % nms threshold for object proposals
% opts.minScore = .01;  % min score of boxes to detect
% opts.maxBoxes = 1e4;  % max number of boxes to detect

database = retr_database_dir('data/ETHZ/', '*_feat.mat');
dtbbs = cell( length( database.path ), 1 );
gtBB = cell( length( database.path ), 1 );
for ii = 1 : length( database.path )
    path = database.path{ ii };
    idd = strfind( path, '\');
    class_name = lower( path( idd(2)+1 : idd(3) - 1 ) ) ;
    t_base = path(1 : length(path) - 8 - 7 );
    gt_fname = [t_base '_' class_name '.groundtruth'];
    temp = load( gt_fname  );
    temp(:,[3,4]) = temp(:,[3,4] ) - temp(:,[1,2] );
    temp(:,5 ) = zeros( size(temp,1 ),1);
    gtBB{ii} = temp;
    temp = load(path,'bbs');
    %pick = nms( temp.bbs, 0.7 ) ;
    dtbbs{ii} = temp.bbs;
end
o.gt = gtBB;
o.bbs = dtbbs;
recall = boxesEval( o );