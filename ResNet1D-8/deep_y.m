% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Calculated depth
%The matrix corresponding to the thickness is given
%h is the thickness matrix, so here we have a matrix with 59 rows, and t is the number of frequency points
% Input: a thickness matrix,frequency points
% Output: corresponding depth

function [deep]=deep_y(h,t)
deep(1,1)=0;
for i=1:length(h)
    if i==t
        break
    end
    deep(i+1,1)=deep(1,1)+sum(h(1,1:i));
end
end
