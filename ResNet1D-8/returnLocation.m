% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Depth auxiliary function
%Input 60 resistivity values and return resistivity value a and position b
%location represents the number of samples, number_matrix represents a value of the location, and w is used to return the resistivity
% Input: Location information, number of interpolations, interpolated data
% Output: Feature data, number of feature layers

function [a,b] = returnLocation(location,number_matrix,w)
a(1,1)=w(1,location);    
b(1,1)=1;
a(1,2)=w(number_matrix(location,1)+2,location);
b(1,2)=number_matrix(location,1)+2;
a(1,3)=w(sum(number_matrix(location,1:2))+3,location);
b(1,3)=sum(number_matrix(location,1:2))+3;
a(1,4)=w(sum(number_matrix(location,1:3))+4,location);
b(1,4)=sum(number_matrix(location,1:3))+4;
a(1,5)=w(sum(number_matrix(location,1:4))+5,location);
b(1,5)=sum(number_matrix(location,1:4))+5;
a(1,6)=w(sum(number_matrix(location,1:5))+6,location);
b(1,6)=sum(number_matrix(location,1:5))+6;
end
