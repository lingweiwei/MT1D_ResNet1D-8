% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Forward program
%Input : Resistivity, layer thickness, frequency
%Output : apparent resistivity,phase

function [apparentResistivity, phase] = modelMTForward(resistivities, thicknesses,frequency)

mu = 4*pi*1E-7; 
w = 2 * pi * frequency; 
n1=length(resistivities); 

impedances = zeros(n1,1);

%Symbols
% Zn - Basement Impedance
% Zi - Layer Impedance
% wi - Intrinsic Impedance
% di - Induction parameter
% ei - Exponential Factor
% ri - Reflection coeficient
% re - Earth R.C.

Zn = sqrt(sqrt(-1)*w*mu*resistivities(n1)); 
impedances(n1) = Zn; 
        
for j = n1-1:-1:1
    resistivity = resistivities(j);
    thickness = thicknesses(j);
                

    dj = sqrt(sqrt(-1)* (w * mu * (1/resistivity)));
    wj = dj * resistivity;
        

    ej = exp(-2*thickness*dj);                     


    belowImpedance = impedances(j + 1);
    rj = (wj - belowImpedance)/(wj + belowImpedance); 
    re = rj*ej; 
    Zj = wj * ((1 - re)/(1 + re));
    impedances(j) = Zj;               
end

Z = impedances(1);
absZ = abs(Z); 
apparentResistivity = (absZ * absZ)/(mu * w);
phase = atan2d(imag(Z),real(Z));
