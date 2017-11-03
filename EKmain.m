
% Technology, Geography, and Trade by Eaton and Kortum
% 7/19/2017 (final) 
% Reza Parsi


tic;
clear;
clc;

N     = 4;                           % n = # of the countries
%-------------------------------------------------------------------
t     = [1;1;1;1];                     % technology of countries
t     = bsxfun(@rdivide,t,t(N,1));   % tech relative to US
%-------------------------------------------------------------------
dni   = 2 * ones(N,N);                   % trade costs

for i = 1:N
    dni(i,i) =1;
end
%-------------------------------------------------------------------
sigma = 2;                            % elasticity of substitution
theta = 4;                         % Comparative advantage

gamafun = @(x) x.^((1-sigma)/theta) .* exp(-x);  % gama function
gama  = integral(gamafun,0,Inf).^(1/(1-sigma));    

beta  = 0.5;                         % Labor share 
%-------------------------------------------------------------------
l     = [1;1;1;1];                    % labor force
l     = bsxfun(@rdivide,l,l(N,:));    % labor force  relative to US
%-------------------------------------------------------------------


options2 = optimoptions(@fsolve,'Algorithm','trust-region-dogleg','MaxIterations',5000,...
    'MaxFunctionEvaluations',100000,'OptimalityTolerance',1e-10');

% solver2  = N price functions, N wage functions, N^2 trade share functions

f2 = @(param) solver2(N,t,dni,theta,gama,beta,l,param);
x0 = 0.2 * ones(N^2+2*N,1);

x2 = fsolve(f2,x0,options2);

% Results : w = wages, p = prices, pini = trade shares


p    = x2(1:N,1);
w    = x2(N^2+N+1:end,1);
pini = x2(N+1:N^2+N,1);
pini = reshape(pini,N,N);
   

toc;
