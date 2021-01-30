function [idx_robustsdp,X_robustsdp]=robust_sdp(X,K,m,laplacian)

if nargin==2
    m=0;
    laplacian='adj';
elseif nargin==2
    laplacian='adj';
end


[N,dim]=size(X);
D=squareform(pdist(X));
rowsortedD=sort(D,2);
q=sort(rowsortedD(:,min(floor(.06*N),35)));
q_threshold=.8;
q_val=q(max(floor(q_threshold*N),1));
scale=q_val/sqrt(chi2inv(q_threshold,dim));
D2=D.^2/(2*scale^2);
kernel_D=exp(-D2); 
lambda=exp(-(chi2inv(q_threshold,dim)/2));

kernel_knn_column=max(lambda,zeros(N,1));
kernel_D=kernel_D-kernel_knn_column*ones(1,N);
%figure;imagesc(kernel_D>0);colorbar;

X_robustsdp=RobustClustering_SDP_SDPNALplus(kernel_D,0);
figure;imagesc(X_robustsdp)
idx_robustsdp=rsc(X_robustsdp,K,laplacian); 
degree=X_robustsdp*ones(N,1);
sorted_degree=sort(degree);
if m>0
    threshold=sorted_degree(m); 
else
    threshold=-1;
end
idx_robustsdp(degree<=threshold)=K+1;
end