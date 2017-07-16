function z = estimatePosition( A, b, numFrame, uv, kappa1, kappa2, rho, alpha )

t_start = tic;

MAX_ITER = 100;
ABSTOL   = 1e-4;
RELTOL   = 1e-2;

[~, n] = size(A);
m = n*numFrame;
x_hat = zeros( m, 1 );
z = zeros( m, 1 );
u = zeros( m, 1 );

A_re = kron( speye(numFrame), A );
A_re = sparse(A_re);

A_cal = @(p) A_re'*(A_re*p) + kappa2*operatorA(p, uv) + rho.*p;
Atb = reshape( A'*b, m, 1 );

fprintf('ADMM iteration: ');
for k = 1:MAX_ITER
    fprintf('%d ',k);
    q = Atb + rho*(z - u);
    x = conj_grad(q, A_cal, x_hat, 100, 1e-6, 2);
    
    zold = z;
    x_hat = alpha*x + (1 - alpha)*zold;
    z = max( shrinkage(x_hat + u, kappa1./rho), 0);
    z = min( z,1 );
    
    u = u + (x_hat - z);
   
    history.r_norm(k)  = norm( x - z );
    history.s_norm(k)  = norm( -rho.*(z - zold) );

    history.eps_pri(k) = sqrt(n)*ABSTOL + ...
        RELTOL*max( norm( x ), norm( -z ) );
    history.eps_dual(k)= sqrt(n)*ABSTOL + RELTOL*norm( rho*u );

    if (history.r_norm(k) < history.eps_pri(k) && ...
       history.s_norm(k) < history.eps_dual(k))
         break;
    end
end

toc(t_start);

end

function z = shrinkage(x, kappa)
    z = max( 0, x - kappa ) - max( 0, -x - kappa );
end