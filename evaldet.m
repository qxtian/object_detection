function [rec, prec, ap] = evaldet( class, draw )
%   �˴���ʾ��ϸ˵��
    clname = {'Applelogos', 'Bottles', 'Giraffes', 'Mugs', 'Swans'};
    class_name = clname{ class };
    
    load(['result/' lower(class_name)  '/evaluation.mat' ] );
    confidence = BB(:,5);
    [sc,si] = sort( confidence ,'descend');
    %save('conf2', 'sc', 'si');
    idx = ids(si);
    BB = BB(si,:);
    nd = length(confidence);
    tp=zeros(nd,1);
    fp=zeros(nd,1);
    
    gt = temp.gt;
    det = temp.det;
    for d = 1 : nd 
        flag = BB(d,6);
        if flag == -1 
            fp( d ) = 1;
            continue;
        end
        bb = BB(d ,:);
        ImgIdx = idx( d ); 
        ovmax=-inf;
    
        for j = 1 : size( gt{ ImgIdx } ,1)
            
            bbgt = gt{ ImgIdx }( j, :);
            bi = [max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3) + bb( 1 ),bbgt(3)) ; min( bb(4) + bb( 2 ),bbgt(4))];
            iw = bi(3)-bi(1)+1;
            ih = bi(4)-bi(2)+1;
            if iw > 0 && ih > 0                
                % compute overlap as area of intersection / area of union
                ua = bb(3) * bb(4) + ( bbgt(3) - bbgt(1) ) * ( bbgt(4) - bbgt(2) ) - ih * iw ;
                ov = iw*ih / ua;
                if ov > ovmax
                    ovmax = ov;
                    jmax=j;
                end
            end
        end
    
        if ovmax >= 0.5
            if ~det{ ImgIdx }(jmax )
                tp(d)=1;            % true positive 
                det{ImgIdx}(jmax) = 1;
            else
                fp(d) = 1;
            end
        else
            fp(d)=1;                    % false positive
        end
    end

% compute precision/recall
fp=cumsum(fp);
tp=cumsum(tp);
rec = tp/ npos ;
prec=tp./(fp+tp);
fppi = fp / tst_num;

% compute average precision

ap=0;
for t=0:0.1:1
    p=max(prec(rec>=t));
    if isempty(p)
        p=0;
    end
    ap=ap+p/11;
end

if draw
    % plot precision/recall
    figure(1);
    plot(rec,prec,'-');
    grid;
    xlabel 'recall'
    ylabel 'precision'
    axis([0 1 0 1]);
    set(gca,'XTick',[0:0.1:1])
    title(sprintf('class: %s, AP = %.3f',class_name,ap));
    saveas(gcf,['result/' lower( class_name ) '/pr.jpg']);
    
    figure(2);
    plot(fppi,rec,'-');
    grid;
    xlabel 'FPPI'
    ylabel 'Detection Rate'
    %axis([0  0 1]);
    title(sprintf('class: %s',class_name) );
    saveas(gcf,['result/' lower( class_name ) '/FPPI_DR.jpg']);
    close all;
end

end

