function f = solverEKMCES(N,t,dni,theta,gama,beta,alpha,oii,l,param)

    p    = param(1:N);
    pini = param(N+1:N^2+N);
    pini = reshape(pini,N,N);
    w    = param(N^2+N+1:N^2+2*N);
    o    = param(N^2+2*N+1:N^2+3*N);
    
    f1 = zeros(N,1);
    f2 = zeros(N^2,1);
    f3 = zeros(N,1);
    f4 = zeros(N,1);
    
    
    
    % price of labor and intermediate goods combined for simplification of
    % coding (it does not have a meaning)
    
    pp = zeros(N,1);
    
    for i = 1:N
        
        pp(i) = (w(i)^(beta) * p(i)^(1-beta))^(1-alpha);
    
    end
    
    % oil price
    
    oilpricefun = @(po) oil_price_solver_CES(N,w,l,beta,alpha,pp,po);
    price = fsolve(oilpricefun,mean(pp))
    

     
    % price functions
    
    for n = 1:N
        
        temp = 0;
        
        for i = 1:N
            
        temp = temp + t(i) * (dni(n,i)* (pp(i) + price^(1-alpha))^(1/(1-alpha)))^(-theta);
        
        end
        
        f1(n) = p(n)-gama*(temp^(-1/theta));
    end
    
    % share functions
    
    for n = 1:N
        for i = 1:N
            
         f2(N*(n-1)+i) =  pini(n,i) - t(i)*((gama * dni(n,i) * (pp(i) + price^(1-alpha))^(1/(1-alpha))) / p(n))^(-theta);
        
        end
    end
    
    % wage functions
    
    for i = 1:N
        
        
        for n = 1:N
        
        f3(i) = f3(i) + pini(n,i) * (pp(n)+price^(1-alpha))/pp(n) * w(n) * l(n);
        
        end
        
        f3(i) = w(i) * l(i) - f3(i) * pp(i)/ (pp(i)+price^(1-alpha)) - price * (oii(i)-o(i));
    end
    
    % oil consumtion
    
    for i = 1:N
        
        f4(i) = (1/beta) * price^(1-alpha)/pp(i) * w(i) * l(i) - price * o(i); 
    end
   
    
    f = [f1;f2;f3;f4];
    
end
        