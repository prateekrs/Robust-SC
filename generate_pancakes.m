function [X_,Y_,outliers]=generate_pancakes()
figure; hold on;
scale1=1;
mu1=[0,5]';
sample_size(1)=200;
var1=[20,1]'*scale1;
X1=CovariatesGenerator(mu1,sample_size(1),var1);
plot(X1(:,1),X1(:,2),'bx')

scale2=1;
mu2=[0,-5]';
sample_size(2)=200;
var2=[20,1]'*scale2;
X2=CovariatesGenerator(mu2,sample_size(2),var2)
plot(X2(:,1),X2(:,2),'gx')

m=25;ub=[75,20];lb=[-75,-20];
outliers=[];
for i=1:m
    outlier=rand(1,2).*(ub-lb)+lb;
    while (outlier(:,1)<=50 & outlier(:,1)>=-50 & outlier(:,2)>=-10 &  outlier(:,2)<=10)  
    outlier=rand(1,2).*(ub-lb)+lb;
    end
    outliers=[outliers;outlier];
end

plot(outliers(:,1),outliers(:,2),'kx')

X=[X1;X2;outliers];
[N,dim]=size(X);
K=2;
trueidx=[];
for k=1:2
    trueidx=[trueidx;k*ones(sample_size(1),1)];
end
inliers_size=length(trueidx);
X_=[X1;X2];
Y_=trueidx;
end
