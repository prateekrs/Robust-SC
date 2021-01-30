function [points]=CovariatesGenerator(mu,sample_size,var,rho)
switch nargin
    case 0
        mu=zeros(2,1);
        sample_size=50;
        var=ones(size(mu));
        rho=eye(size(mu,1));     
    case 1
        sample_size=100;
        var=ones(size(mu));
        rho=eye(size(mu,1));  
    case 2
        var=ones(size(mu));
        rho=eye(size(mu,1));  
    case 3
        rho=eye(size(mu,1)); 
end
    sigma=(var*var').*(rho);
points = mvnrnd(mu,sigma,sample_size);
end