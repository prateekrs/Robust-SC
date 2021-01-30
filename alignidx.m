% Align with true class label
function [err,alidx] = alignidx(idx,trueidx,method,K)
    n = length(trueidx);
    k = max(length(unique(trueidx)),length(unique(idx)));
    if k<=8
    err = inf;
    alidx = idx;
    %try
    allperm = perms(1:k);
    for i = 1:length(allperm),
        reorder = allperm(i,:);
        try
            trans2 = reorder(idx)';
        catch
            disp 'Fail to align two labels';
        end
        if strcmp(method,'err'),
            err_tmp = sum(trueidx~=trans2(1:n))/n;
        elseif strcmp(method,'nmi'),
            err_tmp = 1-nmi(trueidx,trans2(1:n));
        end
        if err_tmp < err,
            err = err_tmp;
            alidx = trans2;
        end
    end
    else
        if length(unique(trueidx))==K
            err=calculate_accuracy(idx,trueidx);
            alidx=[];
        else
            err=1;
        end
    end 
    %catch
    %    fprintf('hi')
    %    err = 1;
    %end
end
