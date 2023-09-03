% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Different noise data calculation
%Input : experimental data
%Outut : The results of different noises are compared
clear;clc
k=1;
load NoiseBaseline.mat
figure
for i =1:5

     rho_plot=NoiseBaseline{i}(:,1);
     thk_plot=NoiseBaseline{i}(:,2);

    XX0=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','d2:d63');
    YY=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','e2:e63');
    XX1=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','f2:f63'); 
    XX3=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','g2:g63'); 
    XX5=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','h2:h63'); 
    XX10=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','i2:i63'); 

    subplot(3,2,i)
    stairs(rho_plot,thk_plot,'b','Linewidth',1.5);
    hold on
    plot(XX0,YY,'-r','Linewidth',1.5)
%     plot(XX1,YY,'--m','Linewidth',1.5)
    plot(XX3,YY,'--y','Linewidth',1.5)
    plot(XX5,YY,'--','Linewidth',1.5)
    plot(XX10,YY,'--k','Linewidth',1.5)
    axis([10^-1 10^4 0 2200]);
    xticks([1,10,100,1000]);
    xticklabels({'1','10','100','1000'});
    xlim([1,1000]);
    set(gca,'YDir','Reverse'); % Y inverse axis
    set(gca, 'XScale', 'log'); % X variable log
    xlabel('Resistivity(Ωm)')
    ylabel('Depth(m)')
       set(gca,'LineWidth',1)
    hold off
end
% legend('True Model','Predicted Data(ResNet1D-8 gaussian noise 0%) ','Predicted Data(ResNet1D-8 gaussian noise 1%)','Predicted Data(ResNet1D-8 gaussian noise 3%)','Predicted Data(ResNet1D-8 gaussian noise 5%)','Predicted Data(ResNet1D-8 gaussian noise 10%)')
legend('True Model','Inversion result Without Noise','Inversion Result with 3% Noise','Inversion Result with 5% Noise','Inversion Result with 10% Noise');
