%Peng and Wei SDP formulation for Kmeans
%{
Small Example to check code
k=2
D=ones(10)
D(1:8,1:8)=0
D(9:10,9:10)=0
%}

function [X]=Kmeans_SDPNALplus(D,k)
N=size(D,1);
X=var_sdp(N,N);
model=ccp_model('KmeansClustering');
model.add_variable(X);
Objective = inprod(D,X);
model.minimize(Objective);
model.add_affine_constraint(X>=0);
model.add_affine_constraint(trace(X)==k);
zero_mat=zeros(N);
for i=1:N
    temp=zero_mat;
    temp(i,:)=1;
    model.add_affine_constraint(inprod(temp,X)==1); 
end
model.solve;
X=get_value(X);
imagesc(X);
colorbar;
end