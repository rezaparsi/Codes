
% EK non-tradable oil vs tradable oil for different amount of alpha.
% Runing the script for both models in order to plot the graphs.
% Graphs saving directory HAS TO BE CHANGED BEFORE EXECUTING THE CODE.

clear;
clc;
tic;






alphas = linspace(0.01,0.79,10);

for counter = 1:size(alphas,2)
    setappdata(0,'alpha',alphas(counter));
    run EKMmain;
    resultoil(counter) = Resultsoil;
end

clearvars -except resultoil;

alphas = linspace(0.01,0.79,10);

for counter = 1:size(alphas,2)
    setappdata(0,'alpha',alphas(counter));
    run EKnonoilmain;
    resultnonoil(counter) = Resultsnonoil;
end

clearvars -except resultoil resultnonoil N alphas;

realwageoil    = zeros(N,size(alphas,2));
realwagenonoil = zeros(N,size(alphas,2));


for i = 1:size(alphas,2)
    for j = 1:N
    realwageoil(j,i) = resultoil(i).Wage(j)/resultoil(i).Price(j);
    end
end

for i = 1:size(alphas,2)
    for j = 1:N
    realwagenonoil(j,i) = resultnonoil(i).Wage(j)/resultnonoil(i).Price(j);
    end
end

%-------------------------------------------------------------------
% Plots
%-------------------------------------------------------------------
figure(1);
for j = 1:N  
plot(alphas,realwageoil(j,:),'linewidth',1.2);
hold on;
end

for j = 1:N  
plot(alphas,realwagenonoil(j,:),'--');
hold on;
end

hold off;
legend('Initial Oil Reserve = 60%','Initial Oil Reserve = 10%','Initial Oil Reserve = 30%')
xlabel('Alpha');
ylabel('Real Wage');

figure(2);

for j = 1:N;
    diffplot(j) = plot(alphas,100*(realwageoil(j,1:end)-realwagenonoil(j,1:end))./realwageoil(j,1:end),'linewidth',1.2);
    hold on;
end

legend('Initial Oil Reserve = 60%','Initial Oil Reserve = 10%','Initial Oil Reserve = 30%')
xlabel('Alpha');
ylabel('Decline in Real Wage (%)');


savepath = fullfile('/Users/rezaparsi/Desktop/Trade summer project/','Output');
saveas(figure(1),fullfile(savepath,'fig1'),'jpeg');
saveas(figure(2),fullfile(savepath,'fig2'),'jpeg');
toc