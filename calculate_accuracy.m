function [err,X]=calculate_accuracy(idx,trueidx)
cd 'C:\gurobi810\win64\matlab'
gurobi_setup();
%savepath;
cd 'C:\Users\prate\OneDrive\YALMIP-master\YALMIP-master'
addpath(genpath(pwd),path);

Z=unique(trueidx);
N=length(trueidx);
K=length(Z);
A=zeros(N,K);

for k_ind=1:K
    A(trueidx==Z(k_ind),k_ind)=1;
end

X = binvar(N,K,'full');
Y = binvar(K,K,'full');
Constraints = [];

for k=1:K
    Constraints=[Constraints,sum(Y(k,:))==1,sum(Y(:,k))==1];
end

Constraints=[Constraints, sum(X,2)==1];


for k_ind=1:K
    rows=find(idx==Z(k_ind));
    if ~isempty(rows)
    for j=1:K
    Constraints=[Constraints, X(rows,j)==Y(Z(k_ind),j)];
    end
    end
end
Objective=-sum(sum(A.*X));

% Set some optons for YALMIP and solver
options = sdpsettings('verbose',0,'solver','gurobi');

% Solve the problem
sol = optimize(Constraints,Objective,options);
X=value(X);

for k=1:K
    aligned_labels(X(:,k)>0.99)=k;
end

err=1-sum(aligned_labels'==trueidx)/length(trueidx);
rmpath(genpath(pwd));
cd 'C:\Users\prate\OneDrive\Desktop\SDP'
end