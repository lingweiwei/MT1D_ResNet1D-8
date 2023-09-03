% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Inverse normalization function
% Input: Normalized data after normalization, normalized eigenvalues
% Output: Inverse normalized data
function [XX]=InverseNormalization(Y,max_output)
X=Y.*max_output;
XX=10.^X;
end
