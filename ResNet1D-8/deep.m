% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:depth calculation
%Enter a position matrix and calculate the corresponding depth
%point is the point matrix of the input position, and corresponding h is the depth of each layer
%h is the thickness matrix
% Input: a position matrix and calculate the 
% Output: corresponding depth

function [returnx]=deep(point,h)
    returnx(1,1)=sum(h(1,point(1,1):point(1,2)-1));
    returnx(1,2)=sum(h(1,point(1,2):point(1,3)-1));
    returnx(1,3)=sum(h(1,point(1,3):point(1,4)-1));
    returnx(1,4)=sum(h(1,point(1,4):point(1,5)-1));
    returnx(1,5)=sum(h(1,point(1,5):point(1,6)-1));

end
