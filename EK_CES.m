% Modified EK with tradable oil
% 8/5/2017 (final) 
% Reza Parsi



% Instruction:
% 1) set the # of countries 'N'
% 2) set the technology function 't'
% 3) set the proven oil reservoirs 'oii'
% 4) set the trade costs 'dni'
% 5) set the labor force 'l'
% 6) see the variable 'Resultsoil'


N     = 2;                           % n = # of the countries
%-------------------------------------------------------------------
t     = [1;2];                     % technology of countries
t     = bsxfun(@rdivide,t,t(N,1));   % tech relative to US

oii   = [1;0];               % proven oil reservoirs of countries
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

beta  = 1;                         % Labor share 
alpha = 0.8;
%alpha = getappdata(0,'alpha');        % oil share
%-------------------------------------------------------------------
l     = ones(N,1);                      % labor force
l     = bsxfun(@rdivide,l,l(N,:));    % labor force  relative to US
%-------------------------------------------------------------------




%-------------------------------------------------------------------
% solver  = N price functions, N wage functions, N^2 trade share functions
%-------------------------------------------------------------------

options2 = optimoptions(@fsolve,'Algorithm','levenberg-marquardt','MaxIterations',500,...
    'MaxFunctionEvaluations',500,'OptimalityTolerance',1e-10);

f2 = @(param) solverEKMCES(N,t,dni,theta,gama,beta,alpha,oii,l,param);
x0 = 0.5 * ones(N^2+3*N,1);

x2 = fsolve(f2,x0,options2);

%-------------------------------------------------------------------
% Results : w = wages, p = prices, pini = trade shares, ...
%-------------------------------------------------------------------


p    = x2(1:N,1);
w    = x2(N^2+N+1:N^2+2*N,1);
pini = x2(N+1:N^2+N,1);
pini = reshape(pini,N,N);
o    = x2(N^2+2*N+1:N^2+3*N,1);

Resultsoil = struct('Price',p,'Wage',w,'TradeShare',pini,'OilPrice',po,'ProvenOilReservoirsPercentage',oii,'OilConsumption',o,...
    'Technology',t,'LaborForce',l,'GeographicBarriers',dni);
 

