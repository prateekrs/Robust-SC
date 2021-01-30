function [acc_robustsc,acc_kmeans,acc_sc,acc_rsc,time_robustsc,time_kmeans,time_sc,time_rsc]=main_experimental_large_scale(experiment,N_ITER)

%use default parameter values 
clust_size=400;
m=-1;
clust_var=-1;
outlier_var=-1;
K=15;
dist_scale=-1;

%default number of iterations - 10
if N_ITER==-1
    N_ITER=10; 
end

%initialize parameters of experiment
if strcmp(experiment,'vary_cluster') 
    K_list=[5,10,15,20,25]; 
    N_PTS=length(K_list); 
elseif strcmp(experiment,'vary_outlier') 
    %outlier_list=[0,50,100,150,200,250,300]; 
    outlier_list=0:125:500; 
    N_PTS=length(outlier_list); 
elseif strcmp(experiment,'vary_dist') 
    dist_list=[.25,.5,.75,1.0]; 
    N_PTS=length(dist_list); 
end



acc_robustsc=zeros(N_ITER,N_PTS);
acc_kmeans=zeros(N_ITER,N_PTS);
acc_sc=zeros(N_ITER,N_PTS);
acc_rsc=zeros(N_ITER,N_PTS);

time_robustsc=zeros(N_ITER,N_PTS);
time_kmeans=zeros(N_ITER,N_PTS);
time_sc=zeros(N_ITER,N_PTS);
time_rsc=zeros(N_ITER,N_PTS);


for k=1:N_PTS
    
    for iter=1:N_ITER
        
        if strcmp(experiment,'vary_cluster') 
            K=K_list(k); 
        elseif strcmp(experiment,'vary_outlier') 
            m=outlier_list(k); 
        elseif strcmp(experiment,'vary_dist') 
            dist_scale=dist_list(k); 
        end       
               
        [robustsc,kmeans,sc,rsc,t_robustsc,t_kmeans,t_sc,t_rsc]=test_large_scale(K,clust_size,m,clust_var,outlier_var,dist_scale);
        
        acc_robustsc(iter,k)=robustsc;
        acc_kmeans(iter,k)=kmeans;
        acc_sc(iter,k)=sc;
        acc_rsc(iter,k)=rsc;
        
        time_robustsc(iter,k)=t_robustsc;
        time_kmeans(iter,k)=t_kmeans;
        time_sc(iter,k)=t_sc;
        time_rsc(iter,k)=t_rsc;
        
        save('accuracy.mat','acc_robustsc','acc_kmeans','acc_sc','acc_rsc')
        save('times.mat','time_robustsc','time_kmeans','time_sc','time_rsc')
    end
end

end