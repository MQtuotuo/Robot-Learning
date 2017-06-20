function [states ] = calculateState( states, f )
%calculating states

noise=[0.001 0.001 0.001 0.001];
 prevAngle=states(3);
    prevAngSpeed=states(4);
    prevSpeed=states(2);
    
    %calculate the states
    secDerAngl = secondDerivAngl( prevAngle, prevAngSpeed, f);
    secDerPos = secondDerivPos(prevAngle,prevAngSpeed,secDerAngl, f);
    states(4) = states(4)+secDerAngl*0.01 + noise(4);
    states(3) = states(3)+prevAngSpeed*0.01 + noise(3);
    states(2) = states(2)+secDerPos*0.01 + noise(2);
    states(1) = states(1)+prevSpeed*0.01 + noise(1);
    
    
end

