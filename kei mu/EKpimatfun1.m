function pimat=EKpimatfun1
global ncoun tmat dmat p theta beta gama w 
pimat=zeros(ncoun,ncoun);
for iter = 1:ncoun
    for jter = 1:ncoun
        pimat(iter,jter)=tmat(jter)*(gama*dmat(iter,jter)*(w(jter)^beta)*(p(jter)^(1-beta))/p(iter))^(-theta);
    end;
end;

