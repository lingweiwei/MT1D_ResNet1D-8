% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Computational MAPE
% Y is the real value, Y_YC the predicted sin, is this compilation
%Input:Two sets of same dimensional data
%Output:Mean absolute percentage error between the two sets of data
function XX = MAPE(Y,Y_YC)
XX = mean(abs((Y - Y_YC)./Y))*100;
end
