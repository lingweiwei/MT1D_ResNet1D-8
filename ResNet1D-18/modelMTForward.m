% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Forward program
%Input : Resistivity, layer thickness, frequency
%Output : apparent resistivity,phase
function [apparentResistivity, phase] = modelMTForward(resistivities, thicknesses,frequency)
mu = 4*pi*1E-7; % Magnetic permeability (H / m) 
w = 2 * pi * frequency; % Angular frequency (radians);
n1=length(resistivities); % Number of layers

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

% Iterate through the layers starting from layer j = n-1 (i.e., the layer above the bottom layer)            
for j = n1-1:-1:1
    resistivity = resistivities(j);
    thickness = thicknesses(j);
                
     % 3. Calculate apparent resistivity from surface impedance  
     % Step 2. Iterate from the bottom layer to the top layer (instead of the bottom layer)  
     % Step 2.1 Calculate the intrinsic impedance of the current layer   
    dj = sqrt(sqrt(-1)* (w * mu * (1/resistivity)));
    wj = dj * resistivity;
        
% Calculation of exponential factor from intrinsic impedance  
    ej = exp(-2*thickness*dj);                     

     % Step 2.3 Calculation of reflection coefficient using current layer  
     % intrinsic impedance and next layer impedance  
    belowImpedance = impedances(j + 1);
    rj = (wj - belowImpedance)/(wj + belowImpedance); 
    re = rj*ej; 
    Zj = wj * ((1 - re)/(1 + re));
    impedances(j) = Zj;               
end
% Step 3. Calculation of apparent resistivity from surface impedance  
Z = impedances(1);
absZ = abs(Z); 
apparentResistivity = (absZ * absZ)/(mu * w);
phase = atan2d(imag(Z),real(Z));
