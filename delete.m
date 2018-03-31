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


N     = 4;                           % n = # of the countries
%-------------------------------------------------------------------
t     = [1;0.278032608376849;1.30267608263951;1.76736146111254];                     % technology of countries
t     = bsxfun(@rdivide,t,t(N,1));   % tech relative to US

oii   = [1479710000
1488470000
3538310000
20564100000];                   % proven oil reservoirs of countries
oii   = oii./sum(oii);               % assuming the sum is 1
%-------------------------------------------------------------------
dni = [1,2.14402131377780,2.02428633380607,1.33391511034992;1.85852755182631,1,1.84350818033416,1.27967424802834;2.07414791930063,1.84208938103939,1,1.43786544705845;1.76648034885976,1.33081100568226,1.44605216458988,1];
for i = 1:N
    dni(i,i) =1;
end


%-------------------------------------------------------------------
sigma = 2;                            % elasticity of substitution
theta = 8.28;                         % Comparative advantage

gamafun = @(x) x.^((1-sigma)/theta) .* exp(-x);  % gama function
gama  = integral(gamafun,0,Inf).^(1/(1-sigma));    

beta  = 0.21;                         % Labor share 
alpha = 0.016;
%alpha = getappdata(0,'alpha');        % oil share
%-------------------------------------------------------------------
l     = ones(N,1);                      % labor force
l     = bsxfun(@rdivide,l,l(N,:));    % labor force  relative to US
%-------------------------------------------------------------------




%-------------------------------------------------------------------
% solver2  = N price functions, N wage functions, N^2 trade share functions
%-------------------------------------------------------------------

options2 = optimoptions(@fsolve,'Algorithm','trust-region-dogleg','MaxIterations',5000,...
    'MaxFunctionEvaluations',100000,'OptimalityTolerance',1e-16');

f2 = @(param) solverEKM(N,t,dni,theta,gama,beta,alpha,oii,l,param);
x0 = 1 * ones(N^2+3*N,1);

x2 = fsolve(f2,x0,options2);

%-------------------------------------------------------------------
% Results : w = wages, p = prices, pini = trade shares, ...
%-------------------------------------------------------------------


p    = x2(1:N,1);
w    = x2(N^2+N+1:N^2+2*N,1);
pini = x2(N+1:N^2+N,1);
pini = reshape(pini,N,N);
po   = alpha * sum(w.*l) / beta;
o    = x2(N^2+2*N+1:end,1);



Resultsoil = struct('Price',p,'Wage',w,'TradeShare',pini,'OilPrice',po,'ProvenOilReservoirsPercentage',oii,'OilConsumption',o,...
    'Technology',t,'LaborForce',l,'GeographicBarriers',dni);
 

