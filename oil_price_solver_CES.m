
function f = oil_price_solver_CES(N,w,l,beta,alpha,pp,po)
    
    temp = 0;
    
    for i = 1:N
        
        temp = temp + (1/beta) *  (po^(1-alpha)/ pp(i)) * w(i) * l(i);
        
    end
    
    f = temp - po;
    
end

