function [answer]=block_ostrowski(A,size_block,pol)

    n_blocks=size(A,1)/size_block;

    D_inv=zeros(size(A));

    for i=0:n_blocks-1
        D_inv(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block)=inv(A(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block));
    end

    D_inv=sparse(D_inv);
   
if pol ~=2    
    Atilde=zeros(n_blocks,n_blocks);
    for i=0:n_blocks-1
        for j=0:n_blocks-1
            if (j==i)
                Atilde(i+1,j+1)=(norm( D_inv(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block)*...
                    A(i*size_block+1:(i+1)*size_block,j*size_block+1:(j+1)*size_block),pol ))^(-1);
            else
                Atilde(i+1,j+1)=-norm( D_inv(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block)*...
                    A(i*size_block+1:(i+1)*size_block,j*size_block+1:(j+1)*size_block),pol );
            end
        end
    end
    
    display('Block Jacobi preconditining applied on the left')
    answer=isempty(find(inv(Atilde)<0, 1))
    
    Atilde=zeros(n_blocks,n_blocks);
    for i=0:n_blocks-1
        for j=0:n_blocks-1
            if (j==i)
                Atilde(i+1,j+1)=(norm( A(i*size_block+1:(i+1)*size_block,j*size_block+1:(j+1)*size_block)*...
                    D_inv(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block),pol ))^(-1);
            else
                Atilde(i+1,j+1)=-norm( A(i*size_block+1:(i+1)*size_block,j*size_block+1:(j+1)*size_block)*...
                    D_inv(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block),pol );
            end
        end
    end
    
    display('Block Jacobi preconditining applied on the right')
    answer=isempty(find(inv(Atilde)<0, 1))
    
else
    Atilde=zeros(n_blocks,n_blocks);
    for i=0:n_blocks-1
        for j=0:n_blocks-1
            if (j==i)
                Atilde(i+1,j+1)=(svds( inv(D_inv(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block)*...
                    A(i*size_block+1:(i+1)*size_block,j*size_block+1:(j+1)*size_block)),1))^(-1);
            else
                Atilde(i+1,j+1)=-svds( D_inv(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block)*...
                    A(i*size_block+1:(i+1)*size_block,j*size_block+1:(j+1)*size_block),1);
            end
        end
    end
    
    display('Block Jacobi preconditining applied on the left')
    answer=isempty(find(inv(Atilde)<0, 1))
    
    Atilde=zeros(n_blocks,n_blocks);
    for i=0:n_blocks-1
        for j=0:n_blocks-1
            if (j==i)
                Atilde(i+1,j+1)=(svds( inv(D_inv(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block)*...
                    A(i*size_block+1:(i+1)*size_block,j*size_block+1:(j+1)*size_block)),1))^(-1);
            else
                Atilde(i+1,j+1)=-svds( A(i*size_block+1:(i+1)*size_block,j*size_block+1:(j+1)*size_block)*...
                    D_inv(i*size_block+1:(i+1)*size_block,i*size_block+1:(i+1)*size_block),1);
            end
        end
    end
    
    display('Block Jacobi preconditining applied on the right')
    answer=isempty(find(inv(Atilde)<0, 1))
end

return;