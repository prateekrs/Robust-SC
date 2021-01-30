%Peng and Wei SDP formulation for Kmeans
%{
Small Example to check code
k=2
D=ones(10)
D(1:8,1:8)=0
D(9:10,9:10)=0
%}

function [X,y]=RobustKmeans_RelaxedSDP_SDPNALplus(D,lambda,k)
N=size(D,1);
X=var_sdp(N,N);
y=var_nn(N,1);
model=ccp_model('KmeansClustering');
model.add_variable(X);
model.add_variable(y);
Objective = inprod(D,X)+lambda*sum(y);
model.minimize(Objective);
model.add_affine_constraint(X>=0);
model.add_affine_constraint(trace(X)==k);
zero_mat=zeros(N);
for i=1:N
    temp=zero_mat;
    temp(i,:)=1;
    model.add_affine_constraint(inprod(temp,X)+y(i)==1); 
end
model.setparameter('maxiter',20000);
model.solve;
X=get_value(X);
y=get_value(y);
imagesc(X);
colorbar;
end