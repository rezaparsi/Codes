% This program solves EK model using Alvarez-Lucas algorithm
% Set up 2-country  model first
d=datetime('today'); disp(d);
tic;
diary('ek1c.out');

% Global parameters
global beta theta sigma gama ncoun tmat lbar dmat toler Tw w p pimat 
beta=0.5;
theta=4;
ncoun=3;
sigma=2;
lbar=ones(ncoun,1);
lbar(1)=1;lbar(2)=1;lbar(3)=1;
disp(lbar);
dmat=ones(ncoun,ncoun);
trcost=2;
for i = 1:ncoun;
    for j=1:ncoun;
        if (i~=j);
            dmat(i,j)=trcost;
        end;
    end;
end;
disp(dmat);
tmat=ones(ncoun,1);
gamarg=(theta+1-sigma)/theta;
gama=gamma(gamarg); gama=gama^(1/(1-sigma));
maxit=500;
toler=1e-6;
disp('ncoun='); disp(ncoun); 

% Guess initial wages
iter=1; wgap=ones(ncoun,1);
x0=(1/sum(lbar))*ones(ncoun,1);
w=x0;
maxwgap=1;
Tw=zeros(ncoun,1); p=ones(ncoun,1);
w(1)=(1-(w'*lbar-w(1)*lbar(1)))/lbar(1);
disp(w);
while maxwgap > toler;
    Tw=EKwagesol1;
    % disp(Tw);
    maxwgap=max(abs(w-Tw));
    w=Tw;
    iter=iter+1;
end;
disp('done');
disp('w='); disp(w);
disp('iterations=');
disp(iter);
disp('p='); disp(p);
disp('pimat'); disp(pimat);
impsh=ones(ncoun,1);
for iter=1:ncoun
    impsh(iter)=1-pimat(iter,iter);
end;
disp(impsh');
toc;

diary off;





