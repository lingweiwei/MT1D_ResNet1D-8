% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Calculate RMSE
% Y is the true value, Y_YC is the predicted value XX is the root mean square error of this set of numbers
%Input:Two sets of same dimensional data
%Output:Root Mean Square Error between the two sets of data

function XX = RMSE(Y,Y_YC)
XX = sqrt(mean((Y-Y_YC).^2));
end
