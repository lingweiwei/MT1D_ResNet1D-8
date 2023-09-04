% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Comparison code between the SA algorithm and R8 network
%Input:experimental data
%Output:Comparison of model predictions
clear;clc
k=1;
t=60;
T=logspace(0,4,t)';  % Cycle
figure
for i=1:5
    baseLine=readmatrix('SAandResNet1d8.xlsx','Sheet',i,'Range','a2:a61');
    apparentResistivity18=readmatrix('SAandResNet1d8.xlsx','Sheet',i,'Range','b2:b61');
    apparentResistivity31=readmatrix('SAandResNet1d8.xlsx','Sheet',i,'Range','c2:c61'); 
        subplot(2,3,k)
        k=k+1;
        plot(T,baseLine,'k','LineWidth',1.5);
        hold on
        plot(T,apparentResistivity18,'-.b','LineWidth',1.5);
        plot(T,apparentResistivity31,'-.r','LineWidth',1.5);
        set(gca, 'XScale', 'log');

        a1=min(T)-1;
        a2=max(T)+1;
        a3=min([apparentResistivity18;apparentResistivity31;baseLine]);
        a4=max([apparentResistivity18;apparentResistivity31;baseLine]);
        m=(a4-a3)*0.02;
        axis([a1,a2,a3-m,a4+m]);
        
        set(gca,'XDir','Reverse'); % Y inverse axis       
        set(gca,'LineWidth',1)
        xlabel('Frequency(Hz)');
        ylabel('apparentResistivity(Ωm)')
        hold off
end
legend('True Model','Predicted data (SA)','Predicted data (ResNet1D-8)')
