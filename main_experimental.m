function [time,acc_inlier,acc_outlier,acc_overall]=main_experimental(sample_size,method,base_path,filename)

time=zeros(sample_size,1);
acc_inlier=zeros(sample_size,1);
acc_outlier=zeros(sample_size,1);
acc_overall=zeros(sample_size,1);
Xsol=cell(sample_size,1);

for i=1:sample_size

% load data stored in .mat format with variables X_,Y_,outlier 
cd(base_path)
datafile=[filename,'_',int2str(i),'.mat'];
load(datafile) 

K=length(unique(Y_));
labels=unique(Y_);
m=length(outliers);


[N,dim]=size(X_);
X=zeros(N,dim);
Y=zeros(N,1);
current=0;
for k=1:K
label=labels(k);
classlen=sum(Y_==label);   
X((current+1):(current+classlen),:)=X_(Y_==label,:);
Y((current+1):(current+classlen))=k;
current=current+classlen;
end

X=[X;outliers];
Y=[Y;(K+1)*ones(m,1)];
[N,dim]=size(X);
trueidx=Y;

cd ..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%% kmeans++
if strcmp(method,'kmeans++')
method='kmeans++';
tic; idx_method=kmeans(X,K,'Replicates',1); time_method=toc;
X_method=-1;
end

%%% Robust SC
if strcmp(method,'robustsc')
method='robustsc';
tic; [idx_method,X_method]=robust_sc(X,K,m); time_method=toc;
mutualinfo_method=nmi(idx_method,trueidx);
end


%%% Robust SDP
if strcmp(method,'robustsdp')
method='robustsdp';
tic; [idx_method,X_method]=robust_sdp(X,K,m); time_method=toc;
mutualinfo_method=nmi(idx_method,trueidx);
end

%%% Robust Kmeans
if strcmp(method,'robustkmeans')
method='robustkmeans';
tic; [idx_method,X_method]=robust_kmeans(X,K,m); time_method=toc;
mutualinfo_method=nmi(idx_method,trueidx);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%evaluate accuracy
if (m>0) && (~strcmp(method,'kmeans++')==1)
[err_method,idx_method]=alignidx(idx_method,trueidx,'err',K+1); 
else
[err_method,idx_method]=alignidx(idx_method,trueidx,'err',K); 
end    

method_acc_overall=1-err_method; %inlier+outlier accuracy
method_acc_inlier=sum(idx_method(1:(N-m))==trueidx(1:(N-m)))/(N-m);
if m>0 && (~strcmp(method,'kmeans++')==1)
    method_acc_outlier=sum(idx_method((N-m+1):end)==trueidx((N-m+1):end))/m;
else
    method_acc_outlier=-1;
end

time(i)=time_method;
acc_inlier(i)=method_acc_inlier;
acc_outlier(i)=method_acc_outlier;
acc_overall(i)=method_acc_overall;
Xsol{i}=X_method;

end
end
