function Tp=EKpfun1
global ncoun tmat dmat p theta beta gama w
Tp=zeros(ncoun,1);
for iter = 1:ncoun
    for jter = 1:ncoun
        Tp(iter)=Tp(iter)+tmat(jter)*(dmat(iter,jter)*(w(jter)^beta)*(p(jter)^(1-beta)))^(-theta);
    end;
end;
Tp=gama.*Tp.^(-1/theta);

