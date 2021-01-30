function [X]=RobustClustering_SDP_SDPNALplus_test(S,K,lambda)
N=size(S,1);
X=var_sdp(N,N);
model=ccp_model('RobustClustering');
model.add_variable(X);
Objective = inprod((-S+lambda.*ones(N)),X);
%Objective = inprod(-D,X);
model.minimize(Objective);
model.add_affine_constraint(X<=K/N);
model.add_affine_constraint(X>=0);
model.add_affine_constraint(trace(X)==K);
zero_mat=zeros(N);
for i=1:N
    temp=zero_mat;
    temp(i,:)=1;
    model.add_affine_constraint(inprod(temp,X)<=1); 
end

%model.add_affine_constraint(inprod(ones(N),X)==N^2/K);
%model.setparameter('printlevel', 0)
model.solve;
X=get_value(X);


% N=size(S,1);
% X=sdpvar(N,N);
% Objective = sum(sum((-S+lambda.*ones(N)).*X));
% Constraints = [X(:)>=0,X(:)<=1];
% % Set some options for YALMIP and solver
% options = sdpsettings('verbose',1,'solver','sdpnal','sdpnal.maxiter',20000,'sdpnal.tol',1e-6);
% 
% % Solve the problem
% sol = optimize(Constraints,Objective,options);
% X=value(X);
end