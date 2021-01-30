function [Xsol]=CardinalityConstrainedClustering_SDP_Yalmip(D,Ck,outlier_detect)

cd 'C:\Users\prate\Downloads'
urlwrite('https://github.com/yalmip/yalmip/archive/master.zip','yalmip.zip');
unzip('yalmip.zip','yalmip')
addpath(genpath([pwd filesep 'yalmip']));
savepath

cd 'C:\Users\prate\OneDrive\Desktop\SDP'
N=sum(Ck);
K=length(Ck);

M=cell(K,1);
Y=cell(K,1);
x=cell(K,1);

for k=1:K
    M{k}=sdpvar(N,N,'symmetric');
    x{k}=sdpvar(N,1);
    Y{k}=sdpvar(N,N,'full');
end

y=zeros(N,1);
for k=1:K
    y=y+x{k}
end

Constraints = [y==(2-K)*ones(N,1),x{1}(1)==1];

for k=1:K
    Constraints=[Constraints, sum(x{k})==2*Ck(k)-N,M{k}*ones(N,1)==(2*Ck(k)-N)*x{k},diag(M{k})==1,[M{k},x{k};x{k}',1]>=0];
    %Constraints=[Constraints, sum(x{k})==2*Ck(k)-N,M{k}*ones(N,1)==(2*Ck(k)-N)*x{k},diag(M{k})==1];
    Z1=M{k}+ones(N,1)*ones(N,1)'+x{k}*ones(N,1)'+ones(N,1)*x{k}';
    Z2=M{k}+ones(N,1)*ones(N,1)'-x{k}*ones(N,1)'-ones(N,1)*x{k}';
    Z3=M{k}-ones(N,1)*ones(N,1)'+x{k}*ones(N,1)'-ones(N,1)*x{k}';
    Z4=M{k}-ones(N,1)*ones(N,1)'-x{k}*ones(N,1)'+ones(N,1)*x{k}';
    Constraints=[Constraints, Z1(:)>=0,Z2(:)>=0,Z3(:)<=0,Z4(:)<=0];
end

Y=zeros(N);
if outlier_detect==1
K=K-1;
end
for k=1:K
Y=Y+(1/Ck(k))*(M{k}+ones(N,1)*ones(N,1)'+x{k}*ones(N,1)'+ones(N,1)*x{k}');
end

% Define an objective
D=D.^2;
Objective = sum(sum(D.*Y));

% Set some options for YALMIP and solver
options = sdpsettings('verbose',1,'solver','mosek');

% Solve the problem
sol = optimize(Constraints,Objective,options);

if outlier_detect==1
    K=K+1;
    Xsol=value(x{K});
else
    Xsol=cell(K,1);
    for k=1:K
        Xsol{k}=value(x{k});
    end
end

% Analyze error flags
if sol.problem == 0
 % Extract and display value
 solution = value(x)
else
 display('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem)
end

end 