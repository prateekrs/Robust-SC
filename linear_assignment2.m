function [PiSol]=linear_assignment2(Ck,dist2)
N=sum(Ck);
K=length(Ck);

Pi=binvar(N,K);
Objective=sum(sum(Pi.*dist2));

Constraints = [];
for k=1:K
    Constraints = [Constraints,sum(Pi(:,k))==Ck(k)]
end

for i=1:N
    Constraints = [Constraints,sum(Pi(i,:))==1]
end

options = sdpsettings('verbose',1,'solver','mosek');

% Solve the problem
sol = optimize(Constraints,Objective,options);
if sol.problem == 0
 % Extract and display value
 PiSol = value(Pi);
end 
end