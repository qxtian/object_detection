function extr_cf(img_dir, fmt, sc_para)
    
    database = retr_database_dir(img_dir, fmt);

	tic
    % matlabpool(4);
    for n = 1 : length(database.path)
        fprintf('Extracting contour fragment: %d of %d\n', n, length(database.path));
        func_extr_cf(database.path{n}, sc_para ); 
    end
    % matlabpool close;
	toc

function func_extr_cf(im_name, cf_para )
    
	I = imread( im_name );
    if size(I, 3) > 1
        for i=1:size(I,3)
            a=(I(:,:,i));
            if max(max(a))~=min(min(a))
                I=a;
                break               
            end
        end
    end
        %edge_image = edge(I, 'canny');
        %edge_image = bwmorph(edge_image, 'thin', Inf);
        %figure(1); imshow(edge_image);
        
        %I = imread( [ im_name( 1 : end - 4 ) '_edges.tif']);
    edge_image = im2bw( I, 0.02 );
    %figure(2);
    if 0
        imshow(edge_image);hold on;
    end
    %-------------- calulate direction map----------------
    [els, ~] = edgelink(edge_image, 10);
    els = relinkedge_iter(els, 10, 5, 0.6);	
    
     pnts = {};
     for i = 1:length(els)
        C = els{i};
        C(:,1) = els{i}(:,2);
        C(:,2) = els{i}(:,1);
        C = C(1:end-1, :);
        if size(C,1) < 15
            continue;
        end
        [XIs, YIs] = uniform_interp( C(:,1), C(:,2), round( size(C, 1) * 0.99 )-1);
        C = [C(1,:); [XIs YIs]];
        pnts_ = {};
        if size(C,1) > cf_para.n_pntsamp 
            pnts_ = extr_raw_pnts( C, cf_para.max_curvature, cf_para.n_contsamp, cf_para.n_pntsamp );
        else
            if size(C,1) > 3
                pnts_ = cell(1,1);
                pnts_{1} = C;
            end
        end
        pnts = [pnts; pnts_'];
     end   
    len = length(pnts);
    if 0
        
        for ii = 1 : len 
            imshow(I) ; hold on;
            plot(  pnts{ii}(:,1), pnts{ii}(:,2),'r' );
            imwrite( I,['data/another_' num2str(ii) '.bmp'] ,'bmp');
        end
    end

    feat_sc = zeros( 0, len ); 
    xy = zeros( len, 2 );
    
    for i = 1:len
        sc = shape_context( pnts{i} );
        sc = sc(:);
        sc = sc / sum(sc);
        
        feat_sc(  1:size(sc,1), i ) = sc;
        
        cf = pnts{i};
        xy( i, 1:2 ) = cf( round(end/2), : );
    end
    
    sz = size(I);
    save([im_name(1:end-4), '_feat.mat' ], 'pnts', 'feat_sc', 'xy', 'sz','-v7.3');
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
