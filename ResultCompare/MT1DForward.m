% -*- coding: utf-8 -*-
% @Author  : LingWeiWei&XiaoWenBo
% @Function:Forward program
%Input:Resistivity, layer thickness, frequency
%Output:apparent resistivity,phase
function [apparentRho,Phase] = MT1DForward(rho,h,f)

   % Calculation of the number of frequencies nFreqs and stratigraphic layers nLayer
    nFreqs = length(f);
    nLayer = length(rho);
    apparentRho=zeros(21,1);
    Phase  = zeros(21,1);
    % For each frequency, the response needs to be calculated once, so the large cycle is the frequency
    for iFreq = 1:nFreqs
        omega = 2*pi*f(iFreq)  ;     % ω is the angular frequency (in radians), ω = 2πf
        u0 = 4*pi*1e-7    ;          % u0 is the vacuum magnetic permeability (H/m), u0=4π×10-7
        
        % Small cycle for each stratum (1st stratum backwards from N)
        for j = nLayer :-1:1
            k = sqrt(1i*omega*u0/rho(j));
            Z0 = sqrt(1i*omega*u0*rho(j));
            if j == nLayer  % When calculating to three levels
                Z = Z0;
                continue
            end
            R = (Z0-Z)/(Z0+Z);
            Q = exp(-2*k*h(j));
            Z  = Z0*(1-R*Q)/(1+R*Q);
        end     
        
        % Finally, the ground surface (top interface of the first layer) impedance is calculated for each frequency point, here Z i.e. Zj = 1
        Z(iFreq) = Z;
        
         % The apparent resistivity and phase are then obtained as follows.
        apparentRho(iFreq) = (abs(Z(iFreq)).^2)./(omega*u0) ;      %Resistivity
        Phase(iFreq) = atan2d(imag(Z(iFreq)),real(Z(iFreq))) ;     % Phase
        % imag() means the imaginary part of the complex number, real() means the real part of the complex number
        % Note: The phase unit calculated in the formula is radian, here it is ° because the atan2d function is used to convert the degree
      
    end
end 
