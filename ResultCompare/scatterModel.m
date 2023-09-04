% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:scatterModel drawing
%Input:experimental data
%Output:Performance diagrams of different structural models
X=[46.2,128.3,210.3,292.4,464.1,792.1,1200,1500,2400,2100,2200,4500,1000];
X1=[2100,2200,4500,1000];
Y=[0.66,0.6,0.44,0.4,0.32,0.21,0.16,0.09,0.054,0.048,0.054,0.016,0.02];
Y1=[0.048,0.054,0.016,0.02];
figure
plot(X,Y,'r.','MarkerSize',30)
hold on
plot(X1,Y1,'G.','MarkerSize',30)
set(gca,'YDir','reverse');
xlabel('Total Learnables(K)')
ylabel('RMSE')
axis([0 4800,0,0.7])
legend('1D-CNN','1D-ResNet')
% Z=['C-6','C-8','C-10','C-13','C-16','C-18','C-24','C-26','C-26*','R-15','R-22','R-31','R-72'];
text(X(1)+100,Y(1),'C-6')
text(X(2)+100,Y(2),'C-8')
text(X(3)+100,Y(3),'C-10')
text(X(4)+100,Y(4),'C-13')
text(X(5)+100,Y(5),'C-16')
text(X(6)+100,Y(6),'C-18')
text(X(7)+100,Y(7),'C-24')
text(X(8)+100,Y(8),'C-26')
text(X(9)+100,Y(9),'C-26*')
text(X(10)-400,Y(10),'R-4')
text(X(11)-100,Y(11)+0.04,'R-6')
text(X(12)-400,Y(12),'R-8')
text(X(13)-400,Y(13),'R-18')
