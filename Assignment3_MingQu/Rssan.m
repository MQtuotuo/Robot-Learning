% Implements the reward probabilities defined in Question 3.3
function Reward = Rssan(s,sd,a,g)

	% Problem constants
    PVec = [0.2 0.6 0.2];
	RVec = [-1 -20 1 100]; % [Free X * G]
    off = [-1 -1 -1 -1 0 1;1 1 1 -1 0 1;-1 0 1 -1 -1 -1;-1 0 1 1 1 1];
	
    % Work out where the move would ideally go
    rtmp = s(1) + off(a,1:3);
    ctmp = s(2) + off(a,4:6);
    Reward = 0;
    Rwd = [0 0 0];
    Invalid = [0 0 0];
    for k = 1:3
        if (rtmp(k)<1) || (rtmp(k)>9) || (ctmp(k)<1) || (ctmp(k)>9) % If you went off the grid...
            Rwd(k) = -5;
            Invalid(k) = PVec(k); % Hack that simplifies Reward calculation below
        else
            Rwd(k) = RVec(g(rtmp(k),ctmp(k))+1); % Apply the appropriate reward based on the square you are entering
            if g(rtmp(k),ctmp(k)) == 1 % If you hit an X...
                Invalid(k) = PVec(k); % Hack that simplifies Reward calculation below
            end
        end
        if (rtmp(k)==sd(1)) && (ctmp(k)==sd(2)) && (Invalid(k)==0) % Note: It is implicitly assumed here that this is only true at most one of the three times it is evaluated - this makes logical sense
            Reward = Rwd(k);
        end
    end
    
    % Handle case where sd is the same as s
    if all(sd == s) % Only way to stay where you are is to have made an invalid move
        if ~all(Invalid == 0)
            Reward = Rwd*(Invalid/sum(Invalid))'; % Calculate the expected value (weight by probabilities)
         end
    end

end
% EOF

