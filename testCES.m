
% Modified EK with tradable oil (alpha variation and real wage plots)
% 8/5/2017 (final) 
% Reza Parsi


% Instruction:
% 1) set the # of countries 'N'
% 2) set the technology function 't'
% 3) set the proven oil reservoirs 'oii'
% 4) set the trade costs 'dni'
% 5) set the labor force 'l'
% 6) see the variable 'Results'

tic;
clear;
clc;

N     = 3;                           % n = # of the countries
%-------------------------------------------------------------------
t     = [1;1;1];                     % technology of countries
t     = bsxfun(@rdivide,t,t(N,1));   % tech relative to US

oii   = [0.6;0.1;0.3];                   % proven oil reservoirs of countries
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

beta  = 0.21;                         % Labor share 
alpha = 0.20;                         % oil share
%-------------------------------------------------------------------
l     = ones(N,1);                    % labor force
l     = bsxfun(@rdivide,l,l(N,:));    % labor force  relative to US
%-------------------------------------------------------------------


alphaa = linspace(.01,0.4,50);

for i = 1:size(alphaa,2)
alpha = alphaa(i);   

options2 = optimoptions(@fsolve,'Algorithm','trust-region-dogleg','MaxIterations',5000,...
    'MaxFunctionEvaluations',100000,'OptimalityTolerance',1e-10');

% solver2  = N price functions, N wage functions, N^2 trade share functions

f2 = @(param) solverEKMCES(N,t,dni,theta,gama,beta,alpha,oii,l,param);
x0 = 0.02 * ones(N^2+3*N,1);

x2 = fsolve(f2,x0,options2);

% Results : w = wages, p = prices, pini = trade shares, ...



p    = x2(1:N,1);
w    = x2(N^2+N+1:N^2+2*N,1);
pini = x2(N+1:N^2+N,1);
pini = reshape(pini,N,N);
po   = alpha * sum(w.*l) / beta;
o    = x2(N^2+2*N+1:end,1);

Results(i) = struct('Price',p,'Wage',w,'TradeShare',pini,'OilPrice',po,'ProvenOilReservoirsPercentage',oii,'OilConsumption',o,...
    'Technology',t,'LaborForce',l,'GeographicBarriers',dni);

end


%--------------------------Real Wage Plot---------------------------------

realwage = zeros(N,size(alphaa,2));

for j = 1:N;
for i = 1:size(alphaa,2);
realwage(j,i) = Results(i).Wage(j)/Results(i).Price(j);
end
end 

for j = 1:N;   
plot(alphaa,realwage(j,:),'linewidth',1);
hold on;
end

legend('Initial Oil Reserve = 60%','Initial Oil Reserve = 10%','Initial Oil Reserve = 30%')
xlabel('Alpha');
ylabel('Real Wage');
hold off;
 %---------------------------Realtive prices-----------------------------
 
op = zeros(size(alphaa,2),1);
pp = zeros(size(alphaa,2),1);

 for i = 1:30;
op(i) = Results(i).OilPrice;
 end


Resultsz = Results;
realwagez = realwage;



toc;
