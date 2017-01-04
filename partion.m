fea_dir = 'data/ETHZ';
database = retr_database_dir(fea_dir, '*_code.mat');
sum_image = length( database.path);
index = linspace(1, sum_image,sum_image );
Partion(5,1) = struct('trn_ixs',[],'tst_pos',[],'tst_neg',[] );
for class = 1 : 5 
    idx = find( database.label == class );
    num = length( idx );
    trn_num = ceil( num / 2 );
    trn_ixs = idx(1 : num );
    tst_pos = idx( trn_num+ 1 : end );
    %trn_ixs = tst_pos;
    tst_neg = setdiff( index , idx )';
    Partion( class ).trn_ixs = trn_ixs;
    Partion( class ).tst_pos = tst_pos;
    Partion( class ).tst_neg = tst_neg;
end
save('data/partion.mat','Partion','-v7.3');