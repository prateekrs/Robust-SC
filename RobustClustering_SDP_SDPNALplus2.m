function [X]=RobustClustering_SDP_SDPNALplus2(S,K)
N=size(S,1);
X=var_sdp(N,N);
model=ccp_model('RobustClustering2');
model.add_variable(X);
Objective = inprod(-S,X);
model.minimize(Objective);
model.add_affine_constraint(0<=X<=1);
model.add_affine_constraint(inprod(ones(N),X)==N^2/K);
model.setparameter('printlevel', 0)
model.solve;
X=get_value(X);

% N=size(S,1);
% X=sdpvar(N,N);
% Objective = sum(sum(-S.*X));
% Constraints = [X(:)>=0,X(:)<=1,sum(sum(ones(N).*X))==N^2/K,X>=0];
% % Set some options for YALMIP and solver
% options = sdpsettings('verbose',1,'solver','sdpnal');
% 
% % Solve the problem
% sol = optimize(Constraints,Objective,options);
% X=value(X);
end