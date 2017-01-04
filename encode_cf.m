
function encode_cf(img_dir, codebook_path, para,model, opts)
    
    database = retr_database_dir(img_dir, '*_feat.mat');
    load(codebook_path);
    dict = dict;
    
    for n = 1:length(database.path)
        fprintf('Encoding: %d of %d\n', n, length(database.path));
        func_encode_cf(database.path{n}, dict, para ,model, opts); 
    end

function func_encode_cf(im_name, dict, para,model, opts )
    

    load(im_name, 'feat_sc', 'xy', 'sz','pnts' );
    
    code_sc = LLC_coding_appr(dict.sc', feat_sc', para.knn)';
    %code_sc = vl_fisher( single( feat_sc ), dict.mean, dict.cov, dict.pri);
    %code = code_sc;

    save([im_name(1:end-9), '_code.mat' ], 'feat_sc','code_sc', 'xy', 'sz' ,'pnts');
                                


 
	
	
	
	
	
	