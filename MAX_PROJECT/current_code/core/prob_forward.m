function [P, cdf]=prob_forward(A, p)

display('Building of transition matrix');

    if (p == 0)
        P=zeros(size(A));
        cdf=zeros(size(A));
        for i=1:size(P,1)
            if isempty(A(i,:))
                break;
            else 
                Prow_ind=find(A(i,:));
                num_elem=length(find(A(i,:)));
                for j=1:num_elem
                    P(i,Prow_ind(j))=(A(i,Prow_ind(j))~=0)/num_elem;
                    cdf(i,Prow_ind(j))=j/num_elem;
                end
            end
        end

    else

        P=zeros(size(A));
        cdf=zeros(size(A));
        for i=1:size(P,1)
            if isempty(A(i,:))
                break;
            else 
                 Prow_ind=find(A(i,:));
                num_elem=length(find(A(i,:)));
                sump=sum(abs(A(i,Prow_ind)).^p);
                for j=1:num_elem
                    P(i,Prow_ind(j))=abs(A(i,Prow_ind(j))).^p/sump;
                    cdf(i,Prow_ind(j))=sum(abs(A(i,Prow_ind(1:j))))/sump;
                end
            end
        end

    end


    P=sparse(P);
    cdf=sparse(cdf);
end
