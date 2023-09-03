% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Calculated depth
% Input: a thickness matrix,frequency points
% Output: corresponding depth
% Gives the matrix used to correspond to the thickness
% h is the thickness matrix, given here as a matrix with 59 columns in a row, and t is the number of frequency points

function [deep]=deep_y(h,t)
deep(1,1)=0;
for i=1:length(h)
    if i==t
        break
    end
    deep(i+1,1)=deep(1,1)+sum(h(1,1:i));
end
end
