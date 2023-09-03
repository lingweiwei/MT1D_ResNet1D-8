% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:18-layer residual network forward and inversion
% Note: This is a debugger, used in the same way as "ResNet1D18_Train.m", used in parallel with debugging, training, and prediction.

clc,clear,close all
mx=[2,6,10,40,80,120,160,180,200,220];
num=500;  % Total number of samples
dw=6;  % Number of resistivity
t=60;  % Number of frequencies
C=60;  % Interpolation length
number_matrix=zeros(num,dw-1);  % Interpolation pitches
T=logspace(0,4,t)';  % Cycle time
h=20+10.^(0.0295*(0:t-2)); % 60 floors
w=zeros(num,C);  % Resistivity samples
apparentResistivity=zeros(t,num);  % Visual resistivity
phase=zeros(t,num);  % Phase
B = repmat(T,1,num);
func = @(x) floor(x/t)+(mod(x,t)==0)*-1+1;
matrix=mx(fix(unifrnd(1,length(mx)+1,[num,dw])));
TP=fix(unifrnd(1,dw,[num,C-dw]));

parfor j=1:num
    n=tabulate(TP(j,:));
    if length(n(:,2))==dw-1
        number_matrix(j,:)=n(:,2)';
    else
        number_matrix(j,:)=[n(:,2)',0];
    end
end

for i=1:num
    a=matrix(i,:);b=number_matrix(i,:);
    w(i,1:b(1)+2)=linspace(a(1),a(2),b(1)+2);
    w(i,b(1)+2:sum(b(1,1:2))+3)=linspace(a(2),a(3),b(2)+2);
    w(i,sum(b(1,1:2))+3:sum(b(1,1:3))+4)=linspace(a(3),a(4),b(3)+2);
    w(i,sum(b(1,1:3))+4:sum(b(1,1:4))+5)=linspace(a(4),a(5),b(4)+2);
    w(i,sum(b(1,1:4))+5:sum(b(1,1:5))+6)=linspace(a(5),a(6),b(5)+2);
%     w(i,sum(b(1,1:5))+6:sum(b(1,1:6))+7)=linspace(a(6),a(7),b(6)+2);

end

w=w';
parfor i=1:num*t
    [apparentResistivity(i),phase(i)] = modelMTForward(w(1+(ceil(i/t)-1)*C : C+(ceil(i/t)-1)*C),h,B(i));
end


% Model Prediction
load ResNet1d18_TrainedModel_5000K_samples.mat
% Normalization of visual resistivity data
app_log=log10(apparentResistivity); % Logarithmically normalized
max_input=max(max(app_log));        % Take the maximum value
app_a=app_log/max_input;            % mapped to (0, 1]
%% Normalization of resistivity data
w_log=log10(w);                     % Logarithmically normalized
max_output=max(max(w_log));         % Take the maximum value
w_a=w_log/max_output;               % Mapped to (0, 1]
% Assign training samples
NUM=500;
app_a_test=app_a(:,1:NUM);  % Extraction of resistivity test data
% Assign test samples
w_a_test=w_a(:,1:NUM);      % Extraction of resistivity test data
% Build the test data set
XTest=cell(NUM,1);
YTest=cell(NUM,1);
YPred18=cell(NUM,1);
for i=1:NUM
    XTest{i,1}=app_a_test(:,i); % Generate input set
    YTest{i,1}=w_a_test(:,i);   % Generate output comparison set
    YPred18{i,1} = predict(ResNet1d18_TrainedModel_5000K_samples,XTest{i});  % 18-layer network prediction
end



%% Inverse and then forward visual resistivity fitting curve drawing
t=60;  % Number of frequencies
T=logspace(0,4,t)';  % Cycle time
B = repmat(T,1,10);
h=20+10.^(0.0295*(0:t-2)); % 60 floors
for i=1:1:20
    m=i;
    
    baseLine=apparentResistivity(:,m);
    YC_DZ18=InverseNormalization(YPred18{m},max_output);  % Inverse normalization of predicted data
    [apparentResistivity18,phase18] = MT1DForward(YC_DZ18,h',B);
    figure(i)
        plot(T,baseLine,'k','LineWidth',1.5);
        hold on
        plot(T,apparentResistivity18,'-.b','LineWidth',1.5);
        set(gca, 'YScale', 'log');
        set(gca, 'XScale', 'log');
        axis equal
        axis([10^0 10^4 10^0 10^4]);
        set(gca,'XDir','Reverse'); % Y inverse axis       
        set(gca,'LineWidth',1)
        xlabel('Frequency');
        ylabel('apparentResistivity(Ωm)')
        hold off
end
legend('True Model apparentResistivity','Predicted apparentResistivity (ResNet1D-18)')


%% stairs figure
 for i =150:10:200
    m=i;
    YC_DZ18=InverseNormalization(YPred18{m},max_output);  % Inverse normalization of predicted data
    MX_DZ=InverseNormalization(YTest{m},max_output);      % Inverse normalization of model data
    t=60;  % 60 floors
    h=20+10.^(0.0295*(0:t-2));  % Layer thickness per layer

    SD=deep_y(h,t);  % Predicted data depth
    [R,point] = returnLocation(m,number_matrix,w);

    thk=deep(point,h);  % Model layer thickness
    rho_plot = [0 R];  % Model ladder data
    thk_plot = [0 cumsum(thk) max(thk)*10000]; % Model ladder data

    rmse_18=RMSE(YTest{m},YPred18{m});
    MAPE_18=MAPE(YTest{m},YPred18{m});
            figure(i)
            table3=[rho_plot',thk_plot'];
            stairs(rho_plot,thk_plot,'b','Linewidth',2.5);
            hold on
            XX18=InverseNormalization(YPred18{m},max_output);
            FAN_Ytest=InverseNormalization(YTest{m},max_output);
            XX18=[XX18(1);XX18;XX18(end)];

            YY=deep_y(h,t)+thk(1)/2;
            YY=[0;YY;2500];
            YYY{i}=YY;
            plot(XX18,YY,'--g','Linewidth',2.5)
            axis([10^-1 10^4 0 2200]);
            set(gca,'YDir','Re verse'); % Y inverse axis
            set(gca, 'XScale', 'log');  % X to logarithm
            legend('True Model','ResNet1D-18')
            xlabel('Resistivity(Ωm)')
            ylabel('Depth(m)')
      
 end


