% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:18 layer residual network training code
%Input:Resistivity set, number of samples, number of interpolation layers
%Output:Predictive model parameter package, model training information
clc,clear,close all
mx=[2,6,10,40,80,120,160,180,200,220];
num=5000;  % Total number of samples
NUM=500;   % Number of samples tested
dw=6;  % Number of resistivity
t=60;  % Number of frequencies
C=60;  % Interpolation length
number_matrix=zeros(num,dw-1);  % Interpolation pit position
T=logspace(0,4,t)';  % Cycle time
h=20+10.^(0.0295*(0:t-2)); % 60 layers
% h=20+10.^(0.057*(0:t-2));  % 40 original value  
w=zeros(num,C);  % Resistivity samples
apparentResistivity=zeros(t,num);  % Visual resistivity
phase=zeros(t,num);  % Phase
B = repmat(T,1,num);
func= @(x) floor(x/t)+(mod(x,t)==0)*-1+1;
matrix=mx(fix(unifrnd(1,length(mx)+1,[num,dw])));
TP=fix(unifrnd(1,dw,[num,C-dw]));


%% Distribution correction 
v=3;
for i=1:num
    matrix(i,1:v)=sort(matrix(i,1:v),'ascend');
    if(matrix(i,2)>matrix(i,3)|| matrix(i,3)<matrix(i,4))
        matrix(i,2:3)=sort(matrix(i,2:3),'ascend');
        matrix(i,3:4)=sort(matrix(i,3:4),'descend');
        matrix(i,4:5)=sort(matrix(i,3:4),'descend');
    end
    matrix(i,v+1:end)=sort(matrix(i,v+1:end),'descend');

    if v==4
        v=3;
    else
        v=v+1;
    end
end


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
end
w=w';
n=size(matrix,1);
nn=n*t;
parfor i=1:nn
    [apparentResistivity(i),phase(i)] =modelMTForward(w(1+(ceil(i/t)-1)*C : C+(ceil(i/t)-1)*C),h,B(i));
end

%-------------------------------------------------------------------------------------

load ResNet1d18_layers.mat % Model
% Set number of samples
[m,n]=size(apparentResistivity);
num=n;  % Total number of samples
% Normalization of visual resistivity data
app_log=log10(apparentResistivity); % Logarithmically normalized
max_input=max(max(app_log));        % Take the maximum value
app_a=app_log/max_input;            % Mapped to (0, 1]
% Normalization of resistivity data 
w_log=log10(w);                     % Logarithmically normalized
max_output=max(max(w_log));         % Take the maximum value
w_a=w_log/max_output;               % Mapped to (0, 1]
% Assign training samples
app_a_train=app_a(:,1:num-NUM);     % Extraction of VFR training data
app_a_test=app_a(:,num-NUM+1:num);  % Extraction of resistivity test data
% Assign test samples
w_a_train=w_a(:,1:num-NUM);         % Extraction of VFR training data
w_a_test=w_a(:,num-NUM+1:num);      % Extraction of resistivity test data
% Build the training data set
for i=1:num-NUM  
     XTrain{i,1}=app_a_train(:,i);
     YTrain{i,1}=w_a_train(:,i);
end
% Build the test data set
for i=1:NUM      
    XTest{i,1}=app_a_test(:,i);
    YTest{i,1}=w_a_test(:,i);
end

options = trainingOptions('adam', ...
    'MaxEpochs',150, ...
    'MiniBatchSize',256, ...
    'InitialLearnRate',0.0001, ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',10,...
    'LearnRateDropFactor',0.8,...
    'Shuffle','every-epoch', ...
    'Plots','training-progress',...
    'ValidationData',{XTest,YTest},...
    'ValidationFrequency',10000, ...
    'Verbose',1);

[resnet1d18net_500K,resnet1d18info_5000K] = trainNetwork(XTrain,YTrain,ResNet1d18_layers,options);

