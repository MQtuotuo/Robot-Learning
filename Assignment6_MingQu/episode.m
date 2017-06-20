function [ reward2 ] = episode( k1, k2, k3, k4, states )
%generating spisodes
 noise=[0.001 0.001 0.001 0.001];
 t=0;
 reward2=0;
    %generating the episodes
    while true 
        t=t+1;
        %calculate the force
        F = calculateForce( states, k1, k2, k3, k4 );
        %calculate the states
        states=calculateState( states, F );
        if abs(states(1))<=0.1 && abs(states(3))<=0.1
                reward2 =reward2+ 0;
        else if abs(states(1))>3.0 || abs(states(3))>0.8 
                reward2 =reward2 - 2 * (1000 - t);
                break;
        else 
                reward2 = reward2 - 1;
            end
        end
                
    end
end

