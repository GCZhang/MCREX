addpath('../core')
addpath('../utils')

% 'jpwh_991'; 'fs_680_1'; 'ifiss_convdiff'; 'shifted_laplacian_1d';
% 'thermal_eq_diff'; 'laplacian_2d'
matrix='thermal_eq_diff';

if ~strcmp(matrix, 'simple')
    addpath(strcat('../utils/model_problems/', matrix));
end

if strcmp(matrix, 'simple')
    dimen=500;
    A=4*diag(ones(dimen,1)) - diag(ones(dimen-1,1),1) - diag(ones(dimen-1,1),-1);
    rhs=[1:dimen]';
    u=A\rhs;

else
     [A, dimen, ~, ~] = mmread('A.mtx');
     rhs=mmread('b.mtx');
     u=mmread('x.mtx');
end

Prec=diag(diag(A));

H=eye(size(A))-Prec\A;
rhs=Prec\rhs;

eps=10^(-3);
dist1=1;
dist2=0;
walkcut=10^(-6);

[Pb, cdfb, P, cdf]=prob_adjoint2(H, rhs, dist1, dist2);
%%
n_walks=[10^1 10^2 10^3 10^4 10^5 10^6];

max_step=1000;

[sol, var, tally, time]=MC_adjoint_error(H, rhs, P, cdf, Pb, cdfb, n_walks, max_step);
    
rel_error=[];
for i=1:length(n_walks)
    rel_error=[rel_error sqrt(sum((u-sol(:,i)).^2))/sqrt(sum((u.^2)))];
end

loglog(n_walks, rel_error, '-or');
hold on
loglog(n_walks, 1./sqrt(n_walks), 'k')

save(strcat('../results/MC_adjoint_plain/MC_adjoint_plain_p1=', num2str(dist1), '_p2=', num2str(dist2)));
%   save(strcat('MC_adjoint_plain_', dist)); 
