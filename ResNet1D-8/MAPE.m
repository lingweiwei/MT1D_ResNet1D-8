% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Computational MAPE
% Y is the true value, Y_YC is the predicted value XX is the root mean square error of this set of numbers
%input:Two sets of same dimensional data
%Output:Mean absolute percentage error between the two sets of data

function XX = MAPE(Y,Y_YC)
XX = mean(abs((Y - Y_YC)./Y))*100;
end
