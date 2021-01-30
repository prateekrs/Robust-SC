function [acc_robustsc,acc_kmeans,acc_sc,acc_rsc,time_robustsc,time_kmeans,time_sc,time_regsc]=test_large_scale(K,clust_size,m,clust_var,outlier_var,dist_scale)
% K=7;
% clust_size=150;
% m=clust_size;

if K==-1, K=8; end
if clust_size==-1, clust_size=250; end 
if m==-1, m=clust_size; end 
if clust_var==-1, clust_var=1; end 
if outlier_var==-1, outlier_var=100*clust_var; end
if dist_scale==-1, dist_scale=1; end

CLUST_DIST_DEFAULT=5;

K,clust_size,m,clust_var,outlier_var,dist_scale
n=clust_size*K;
N=n+m;

% add inlier points centered at the corners of a simplex and variance
% which equals the clust_variance
id=eye(K);
X=[];
trueidx=[];
for k=1:K
mu=id(:,k)*dist_scale*CLUST_DIST_DEFAULT;
Sigma=eye(K)*clust_var;
X_=mvnrnd(mu,Sigma,clust_size);
Y_=ones(clust_size,1)*k;
X=[X;X_];
trueidx=[trueidx;Y_++++++];
end

% add outliers centered at origin and variance 100 times the cluster
% variance
mu=zeros(K,1);
Sigma=eye(K)*outlier_var;
X_=mvnrnd(mu,Sigma,m);
Y_=ones(clust_size,1)*(K+1);
X=[X;X_];
trueidx=[trueidx;Y_];

% hold on
% plot3(X(:,1),X(:,2),X(:,3),'r.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%kmeans++
tic; 
[idx_kmeans,~]=kmeans(X,K,'Replicates',100);
time_kmeans=toc;
acc_kmeans=1-alignidx(idx_kmeans(1:(N-m),:),trueidx(1:(N-m),:),'err',K)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Robust-SC
tic; 
[idx_robustsc,~]=robust_sc(X,K,m);
time_robustsc=toc;
acc_robustsc=1-alignidx(idx_robustsc(1:(N-m),:),trueidx(1:(N-m),:),'err',K)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic; 
[N,dim]=size(X)
D=squareform(pdist(X));
rowsortedD=sort(D,2);
q=sort(rowsortedD(:,min(floor(.06*N),35)));
q_threshold=.8;
q_val=q(max(floor(q_threshold*N),1));
scale=q_val/sqrt(chi2inv(q_threshold,dim));
D2=D.^2/(2*scale^2);
kernel_D=exp(-D2); 
preprocess_time=toc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SC
tic; 
%figure; imagesc(kernel_D)
idx_sc=rsc(kernel_D,K,'lap');
time_sc=toc;
time_sc=time_sc+preprocess_time;
% if K<=8,  accuracy_sc=1-alignidx(idx_sc,trueidx,'err',K); end
% mutualinfo_sc=nmi(idx_sc,trueidx);
acc_sc=1-alignidx(idx_sc(1:(N-m),:),trueidx(1:(N-m),:),'err',K)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Regularized SC
tic; 
idx_regsc=rsc(kernel_D,K,'pos');
time_regsc=toc; 
time_regsc=time_regsc+preprocess_time;
% if K<=8,  accuracy_rsc=1-alignidx(idx_regsc,trueidx,'err',K); end
% mutualinfo_rsc=nmi(idx_regsc,trueidx);
acc_rsc=1-alignidx(idx_regsc(1:(N-m),:),trueidx(1:(N-m),:),'err',K)
end