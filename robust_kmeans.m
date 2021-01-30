function [idx_robustkmeans,X_robustkmeans]=robust_kmeans(X,K,m)
if nargin==2
    m=0;
    lambda=225;
else
    lambda=225;
end

D=squareform(pdist(X));
D=D.^2;
if m>0
threshold=0.8;
else
threshold=10;
end

[X_robustkmeans,y]=RobustKmeans_RelaxedSDP_SDPNALplus(D,lambda,K);
figure;imagesc(X_robustkmeans);colorbar;

idx_robustkmeans(y>=threshold)=K+1;
X_robustkmeans_inliers=X_robustkmeans(y<threshold,y<threshold);
mu_=X_robustkmeans_inliers*X(y<threshold,:);

maxsum = inf;
nrestart = 1000;
for i=1:nrestart,
[class0,~,sumD] = kmeans(mu_,K);
if maxsum > sum(sumD),
maxsum = sum(sumD);
class=class0;
end
end
idx_robustkmeans(y<threshold)=class;
idx_robustkmeans=idx_robustkmeans';
end