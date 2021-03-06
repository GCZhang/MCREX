function [sol, rel_res, VAR, REL_RES, DX, NWALKS, tally, iterations, time]=system_solver(scheme, method, fp, dist, P, cdf, numer, stat)

    if strcmp(scheme, 'SEQ') && strcmp(method, 'forward')
        start=cputime;
        [sol, rel_res, VAR, REL_RES, DX, NWALKS, tally, iterations, ~]=SEQ_forward(fp, P, cdf, numer, stat);
        finish=cputime;

    elseif strcmp(scheme, 'MCSA') && strcmp(method, 'forward')
        start=cputime;
        [sol, rel_res, VAR, REL_RES, DX, NWALKS, tally, iterations, ~]=MCSA_forward(fp, P, cdf, numer, stat);
        finish=cputime;
        
    elseif strcmp(scheme, 'SEQ') && strcmp(method, 'adjoint')
        start=cputime;
        [sol, rel_res, VAR, REL_RES, DX, NWALKS, tally, iterations]=SEQ_adjoint(fp, ...
            dist, P, cdf, numer, stat);
        finish=cputime;
    

    elseif strcmp(scheme, 'MCSA') && strcmp(method, 'adjoint')
        start=cputime;
        [sol, rel_res, VAR, REL_RES, DX, NWALKS, tally, iterations]=MCSA_adjoint(fp, ...
            dist, P, cdf, numer, stat);
        finish=cputime;
           
    else
        error(strcat('Invalid Monte Carlo scheme inserted', '\n', '\n'));
        fprintf('\n\n');
    end
        
    if strcmp(fp.precond, 'gs') || strcmp(fp.precond, 'trisplit') || strcmp(fp.precond, 'alternating') || strcmp(fp.precond, 'triblock')
        sol=(fp.Per)'\sol;
    end
    
    time.start=start;
    time.finish=finish;
end