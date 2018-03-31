function Tw=EKwagesol1
global ncoun lbar pimat p toler w
% disp('wagesol');
nu=0.2;
maxpgap=1; 
while maxpgap > toler;
    Tp=EKpfun1;
    maxpgap=max(abs(p-Tp));
    p=Tp;
end;
pimat=EKpimatfun1;
% disp(pimat);
Zw=zeros(ncoun,1);
for iter = 1:ncoun
    %disp(iter)
    for jter = 1:ncoun
        % disp(jter)
        Zw(iter)=Zw(iter)+w(jter)*lbar(jter)*pimat(jter,iter);
    end;
end;
Zw=(Zw-w.*lbar)./w;
Tw=w.*(1+nu*Zw./lbar);

    
    

