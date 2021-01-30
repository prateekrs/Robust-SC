function [idx_robustsc,X_robustsc]=robustsc_large_scale(X,K,m,laplacian)

if nargin==2
    m=0;
    laplacian='adj';
    q_threshold=.95;
elseif nargin==3
    laplacian='adj';
    q_threshold=.8;
end

% [N,dim]=size(X);
% D=squareform(pdist(X));
% rowsortedD=sort(D,2);
% q=sort(rowsortedD(:,min(floor(.06*N),100)));
% q_val=q(max(floor(q_threshold*N),1));
% scale=q_val/sqrt(chi2inv(q_threshold,dim));
% D2=D.^2/(2*scale^2);
% kernel_D=exp(-D2);
% lambda=exp(-(chi2inv(q_threshold,dim)/2))

[N,dim]=size(X)
if N>5000
    ind=sort(randsample(N,5000));
    N_=5000;
else
    ind=1:N;
    N_=N;
end
X_=X(ind,:);
D=squareform(pdist(X_));
rowsortedD=sort(D,2);
q=sort(rowsortedD(:,min(floor(.06*N_),100)));
q_threshold=.8;
q_val=q(max(floor(q_threshold*N_),1));
scale=q_val/sqrt(chi2inv(q_threshold,dim));
D2=D.^2/(2*scale^2);
kernel_D=exp(-D2); 
lambda=exp(-(chi2inv(q_threshold,dim)/2))




% kernel_knn_column=max(lambda,zeros(N,1));
% kernel_D=kernel_D-kernel_knn_column*ones(1,N);
%figure;imagesc(kernel_D>0);colorbar;

%Xspectralrobustker=(kernel_D>0);
%tic; X_robustsc=RobustClustering_SDP_SDPNALplus(kernel_D,0)
%D=squareform(pdist(X));
%D2=D.^2/(2*scale^2);
%kernel_D=exp(-D2); 
X1=X(1:floor(N/2),:);
X2=X((floor(N/2)+1):end,:);

D11=pdist2(X1,X1,'minkowski').^2/(2*scale^2);
ker11=sparse((exp(-D11)-lambda)>0); clear D11;

D12=pdist2(X1,X2,'minkowski').^2/(2*scale^2);
ker12=sparse((exp(-D12)-lambda)>0);clear D12;

D21=pdist2(X2,X1,'minkowski').^2/(2*scale^2);
ker21=sparse((exp(-D21)-lambda)>0);clear D21;

D22=pdist2(X2,X2,'minkowski').^2/(2*scale^2);
ker22=sparse((exp(-D22)-lambda)>0);clear D22;

% ker12=sparse((kernel_D(1:floor(N/2),(floor(N/2)+1):end)-lambda)>0);
% ker21=sparse((kernel_D((floor(N/2)+1):end,1:floor(N/2))-lambda)>0);
% ker22=sparse((kernel_D((floor(N/2)+1):end,(floor(N/2)+1):end)-lambda)>0);
X_robustsc=[ker11,ker12;ker21,ker22];
clear ker11; clear ker12; clear ker21; clear ker22;
disp('matrix constructed')
%X_robustsc=(kernel_D-lambda)>0;
%figure;imagesc(X_robustsc)
idx_robustsc=rsc(X_robustsc,K,laplacian);
degree=X_robustsc*ones(N,1);
clear X_robustsc;
sorted_degree=sort(degree);
if m>0
    threshold=sorted_degree(m); %=6 (for circles),10 (for pancakes),5 (for unbalanced datasets), 10 (for balanced datasets)
else
    threshold=-1;
end
idx_robustsc(degree<=threshold)=K+1;
end
