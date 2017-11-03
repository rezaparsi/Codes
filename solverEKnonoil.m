function f = solverEKnonoil(N,t,dni,theta,gama,beta,alpha,l,oii,param)

    p    = param(1:N);
    pini = param(N+1:N^2+N);
    pini = reshape(pini,N,N);
    w    = param(N^2+N+1:N^2+2*N);
    po   = param(N^2+2*N+1:N^2+3*N);

    f1 = zeros(N,1);
    f2 = zeros(N^2,1);
    f3 = zeros(N,1);
    f4 = zeros(N,1);
    
    % price functions
    for i = 1:N
        f4(i) = po(i) - alpha * w(i) * l(i)/ (oii(i) * beta);
    end
    
    
    for n = 1:N
        
        temp = 0;
        
        for i = 1:N
            
        temp = temp + t(i) * (dni(n,i)* w(i)^(beta) * po(i)^(alpha) * p(i)^(1-beta-alpha))^(-theta) ;
        
        end
        
        f1(n) = p(n)-gama*(temp^(-1/theta));
    end
    
    % share functions
    
    for n = 1:N
        for i = 1:N
            
         f2(N*(n-1)+i) =  pini(n,i) - t(i)*((gama * dni(n,i) * w(i)^beta * po(i)^(alpha) * p(i)^(1-alpha - beta)) / p(n))^(-theta);
        
        end
    end
    
    % wage functions
    
    for i = 1:N
        
        
        for n = 1:N
        
        f3(i) = f3(i) + pini(n,i) * w(n) * l(n);
        
        end
        
        f3(i) = w(i) * l(i) - f3(i);
    end
    
    f = [f1;f2;f3;f4];
    
end
        