% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:MT inversion using simulated annealing algorithm(SA)
%Input:Resistivity, layer thickness, frequency
%Output:Comparison of inversion results
clc;
clear ;
close all;
tic

%Data
R = [2 40 200 40 2 10 160];
thk = [213.83  489.17-213.83 779.62-489.17 966.97-779.62 1229.46-966.97 1948.53-1229.46];
freq = logspace(-3,3,50);
T = 1./freq;
[app_sin, phase_sin] = modelMT(R, thk ,T);


%% defining model
nlayer = 7; %Layer
nitr = 1000; %iterations

LBR = [1 1 1 1 1 1 1];

UBR = R*2;

LBT = [1 1 1 1 1 1];

UBT = thk*2;
Temp = 1;
dec = 1;

rho1(1 , :) = LBR + rand*(UBR - LBR);
thick1(1, :) = LBT + rand*(UBT - LBT); 

[apparentResistivity1, phase1]=modelMT(rho1(1,:),thick1(1,:),T);
app_mod1(1,:)=apparentResistivity1;
phase_mod1(1,:)=phase1;

[misfit1]=misfitMT(app_sin,phase_sin,app_mod1(1,:),phase_mod1(1,:));
E1=misfit1;
%iterative computations
for itr = 1 : nitr
    rho_int(1 , :) = LBR + rand*(UBR - LBR);
    thick_int(1, :) = LBT + rand*(UBT - LBT);
    ui = rand;
    yi = sign(ui-0.5)*Temp*((((1 + (1/Temp)))^abs(2*ui-1))-1);
    rho2(1 , :) = rho_int + yi*(UBR - LBR);
    thick2(1, :) = thick_int + yi*(UBT - LBT);
    [apparentResistivity2, phase2]=modelMT(rho2(1,:),thick2(1,:),T);
    app_mod2(1,:)=apparentResistivity2;
    phase_mod2(1,:)=phase2;
    [misfit2]=misfitMT(app_sin,phase_sin,app_mod2(1,:),phase_mod2(1,:));
    E2=misfit2;
    delta_E = E2 -E1;

    if delta_E < 0
        rho1 = rho2;
        thick1 = thick2;
        E1 = E2;
    else
        P = exp((-delta_E)/Temp);
        if  P >= rand
            rho1 = rho2;
            thick1 = thick2;
            E1 = E2;
        end
    end
    [apparentResistivity_new, phase_new]=modelMT(rho1(1,:),thick1(1,:),T);
    Egen(itr)=E1;
    Temp = Temp*exp(-dec*(itr)^(1/(2*nlayer)-1));
    Temperature(itr) = Temp;

    rho_plot = [0 R];
    thk_plot = [0 cumsum(thk) max(thk)*10000];
    rhomod_plot = [0 rho1];
    thkmod_plot = [0 cumsum(thick1) max(thick1)*10000];

    gca1=figure(1);

    loglog(T,app_sin,'.b',T,apparentResistivity_new,'r','MarkerSize',12,'LineWidth',1.5);
    axis([10^-3 10^3 1 10^3]);
    legend({'Synthetic Data','Calculated Data'},'EdgeColor','none','Color','none','FontWeight','Bold');
    xlabel('Periods (s)','FontSize',12,'FontWeight','Bold');
    ylabel('App. Resistivity (Ohm.m)','FontSize',12,'FontWeight','Bold');
    title(['\bf \fontsize{10}\fontname{Times}Period (s) vs Apparent Resistivity (ohm.m)  || Misfit : ', num2str(Egen(itr)),' || iteration : ', num2str(itr)]);
    grid on
    gca2= figure(2);

    loglog(T,phase_sin,'.b',T,phase_new,'r','MarkerSize',12,'LineWidth',1.5);
    axis([10^-3 10^3 0 90]);
    set(gca, 'YScale', 'linear');
    legend({'Synthetic Data','Calculated Data'},'EdgeColor','none','Color','none','FontWeight','Bold');
    xlabel('Periods (s)','FontSize',12,'FontWeight','Bold');
    ylabel('Phase (deg)','FontSize',12,'FontWeight','Bold');
    title(['\bf \fontsize{10}\fontname{Times}Period (s) vs Phase (deg)  || Misfit : ', num2str(Egen(itr)),' || iteration : ', num2str(itr)]);
    grid on
   
end
toc

