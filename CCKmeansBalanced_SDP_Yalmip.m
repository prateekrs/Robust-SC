function [Xsol]=CCKmeansBalanced_SDP_Yalmip(D,Ck)

cd 'C:\Users\prate\Downloads'
urlwrite('https://github.com/yalmip/yalmip/archive/master.zip','yalmip.zip');
unzip('yalmip.zip','yalmip')
addpath(genpath([pwd filesep 'yalmip']));
savepath

cd 'C:\Users\prate\OneDrive\Desktop\SDP'
N=sum(Ck);
K=length(Ck);
n=sum(Ck)/K;


M=sdpvar(N,N,'symmetric');
x=sdpvar(N,1);
M0=sdpvar(N,N,'symmetric');
x0=sdpvar(N,1);

Y=(K-1)*(M+ones(N,1)*ones(N,1)'+x*ones(N,1)'+ones(N,1)*x')+(M0+ones(N,1)*ones(N,1)'+x0*ones(N,1)'+ones(N,1)*x0');
% Define an objective
D=D.^2;
Objective = sum(sum(D.*Y));

Constraints = [(K-1)*x+x0==(2-K)*ones(N,1),x0(1)==1];

Constraints=[Constraints, sum(x)==2*n-N,M*ones(N,1)==(2*n-N)*x,diag(M)==1,[1,x';x,M]>=0];
Z1=M+ones(N,1)*ones(N,1)'+x*ones(N,1)'+ones(N,1)*x';
Z2=M+ones(N,1)*ones(N,1)'-x*ones(N,1)'-ones(N,1)*x';
Z3=M-ones(N,1)*ones(N,1)'+x*ones(N,1)'-ones(N,1)*x';
Z4=M-ones(N,1)*ones(N,1)'-x*ones(N,1)'+ones(N,1)*x';
Constraints=[Constraints, Z1(:)>=0,Z2(:)>=0,Z3(:)<=0,Z4(:)<=0];

Constraints=[Constraints, sum(x0)==2*n-N,M0*ones(N,1)==(2*n-N)*x0,diag(M0)==1,[1,x0';x0,M0]>=0];
Z1=M0+ones(N,1)*ones(N,1)'+x0*ones(N,1)'+ones(N,1)*x0';
Z2=M0+ones(N,1)*ones(N,1)'-x0*ones(N,1)'-ones(N,1)*x0';
Z3=M0-ones(N,1)*ones(N,1)'+x0*ones(N,1)'-ones(N,1)*x0';
Z4=M0-ones(N,1)*ones(N,1)'-x0*ones(N,1)'+ones(N,1)*x0';
Constraints=[Constraints, Z1(:)>=0,Z2(:)>=0,Z3(:)<=0,Z4(:)<=0];


% Set some options for YALMIP and solver
options = sdpsettings('verbose',1,'solver','mosek');

% Solve the problem
sol = optimize(Constraints,Objective,options);


% Analyze error flags
if sol.problem == 0
 % Extract and display value
 Xsol=value(x0);
else
 display('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem)
end

end 