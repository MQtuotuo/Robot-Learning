function [ F ] = calculateForce( states, k1, k2, k3, k4 )
%calculating forces
 policyForce = 0.0;
    policyForce = k1*states(1)+k2*states(2)+k3*states(3)+k4*states(4);
    if  policyForce>-30
          F = policyForce;
    else
            F = -30;
    end
    
    if(F>30)
          F = 30;
    end

end

