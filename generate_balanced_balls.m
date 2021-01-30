function [X_,Y_,outliers]=generate_balanced_balls() 
figure;hold on;
scale1=1;
mu1=[0,0]';
sample_size(1)=150;
var1=[1,1]'*scale1;
X1=CovariatesGenerator(mu1,sample_size(1),var1)
plot(X1(:,1),X1(:,2),'.')

scale2=1
mu2=[6,3]';
sample_size(2)=150;
var2=[1,1]'*scale2;
X2=CovariatesGenerator(mu2,sample_size(2),var2)
plot(X2(:,1),X2(:,2),'.')


scale3=1;
mu3=[6,-3]';
sample_size(3)=150;
var3=[1,1]*scale3;
X3=CovariatesGenerator(mu3,sample_size(3),var3)
plot(X3(:,1),X3(:,2),'.')


m=50;ub=[20,10];lb=[-10,-10];
% outliers=rand(m,2).*(ub-lb)+lb;
% plot(outliers(:,1),outliers(:,2),'kx')


outliers=[];
for i=1:m
    outlier=rand(1,2).*(ub-lb)+lb;
    while (outlier(:,1)<=10 & outlier(:,1)>=-4 & outlier(:,2)>=-8 &  outlier(:,2)<=6)  
    outlier=rand(1,2).*(ub-lb)+lb;
    end
    outliers=[outliers;outlier];
end
plot(outliers(:,1),outliers(:,2),'kx')


X_=[X1;X2;X3];
Y_=[ones(sample_size(1),1);2*ones(sample_size(2),1);3*ones(sample_size(3),1)];
X=[X1;X2;X3;outliers];
end
