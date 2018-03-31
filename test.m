clear ;
clc;


N     = 3;                           % n = # of the countries
%-------------------------------------------------------------------
t     = [1;1;1];                     % technology of countries
t     = bsxfun(@rdivide,t,t(N,1));   % tech relative to US

oii   = [0.7;0.1;0.2];               % proven oil reservoirs of countries
oii   = oii./sum(oii);               % assuming the sum is 1
%-------------------------------------------------------------------
dni   = ones(N,N);                   % trade costs

for i = 1:N
    dni(i,i) =1;
end


%-------------------------------------------------------------------
sigma = 2;                            % elasticity of substitution
theta = 8.28;                         % Comparative advantage

gamafun = @(x) x.^((1-sigma)/theta) .* exp(-x);  % gama function
gama  = integral(gamafun,0,Inf).^(1/(1-sigma));    

beta  = 0.2;                         % Labor share 
alpha = 1;        % oil share
%-------------------------------------------------------------------
l     = ones(N,1);
w    = ones(N,1);
p = ones(N,1);

    pp = zeros(N,1);
    
    for i = 1:N
        
        pp(i) = (w(i)^(beta) * p(i)^(1-beta))^(1-alpha); 
    
    end


options = optimoptions(@fsolve,'Algorithm','trust-region-dogleg','MaxIterations',10000,...
    'MaxFunctionEvaluations',100000,'OptimalityTolerance',1e-10');

 oilpricefun = @(po) oil_price_solver_CES(N,w,l,beta,alpha,pp,po);
    x00 =  rand(1);
    [price,fval] = fsolve(oilpricefun,x00,options);
    
    
    
    
    
    