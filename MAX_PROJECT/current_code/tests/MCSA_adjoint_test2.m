addpath('../core')
addpath('../utils')

% 'jpwh_991'; 'fs_680_1'; 'ifiss_convdiff'; 'shifted_laplacian_1d';
% 'thermal_eq_diff'; 'laplacian_2d'
matrix='thermal_eq_diff';

addpath(strcat('../utils/model_problems/', matrix))

if strcmp(matrix, 'simple')
    dimen=50;
    A=4*diag(ones(dimen,1)) - diag(ones(dimen-1,1),1) - diag(ones(dimen-1,1),-1);
    rhs=ones(dimen,1);
    u=A\rhs;
    
else
     [A, dimen, ~, ~] = mmread('A.mtx');
     rhs=mmread('b.mtx');
     u=mmread('x.mtx');
end

Prec=diag(diag(A));

H=eye(size(A))-Prec\A;
rhs=Prec\rhs;

%% Numerical setting

numer.eps=10^(-3);
numer.rich_it=300;

%% Statistical setting
stat.nwalks=2;
stat.max_step=20;
stat.adapt_walks=1;
stat.adapt_cutoff=1;
stat.walkcut=10^(-6);
stat.nchecks=2;
stat.varcut=0.5;
stat.vardiff=10^(-1);
dist=1;

%% Definition of initial and transitional probabilities
[Pb, cdfb, P, cdf]=prob_adjoint(H, rhs, dist);

%% Preconditioning setting

fp.u=u; %reference solution
fp.H=H; %iteration matrix
fp.rhs=rhs;
fp.precond='diag';
%% Monte Carlo Adjoint Method resolution

start=cputime;
[sol, rel_residual, VAR, RES, DX, NWALKS, tally, iterations, reject]=MCSA_adjoint(fp, dist, P, cdf, numer, stat);
finish=cputime;


for i=1:iterations
    figure()
    norm_var=[];
    for j=1:size(VAR{i},2)
        norm_var=[norm_var norm(VAR{i}(:,j))];
    end
    loglog(norm_var, '-o')
end

for i=1:iterations
    figure()
    loglog(RES{i}, '-o')
    %axis([1 length(norm_res) 10^(-1) 10^0]);
end



save(strcat('../results/MCSA_adjoint2/MCSA_adjoint_test2_', matrix, '_p=', num2str(dist)))