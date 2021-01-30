function [idx_robustsc,X_robustsc]=robust_sc(X,K,m,laplacian)

if nargin==2
    m=0;
    laplacian='adj';
    q_threshold=.95;
elseif nargin==3
    laplacian='adj';
    q_threshold=.8;
end

[N,dim]=size(X);
D=squareform(pdist(X));
rowsortedD=sort(D,2);
q=sort(rowsortedD(:,min(floor(.06*N),100)));
q_val=q(max(floor(q_threshold*N),1));
scale=q_val/sqrt(chi2inv(q_threshold,dim));
D2=D.^2/(2*scale^2);
kernel_D=exp(-D2);
lambda=exp(-(chi2inv(q_threshold,dim)/2))

X_robustsc=(kernel_D-lambda)>0;
idx_robustsc=rsc(X_robustsc,K,laplacian);
degree=X_robustsc*ones(N,1);
sorted_degree=sort(degree);
if m>0
    threshold=sorted_degree(m); 
else
    threshold=-1;
end
idx_robustsc(degree<=threshold)=K+1;
end