% Implements the transition probabilities defined in Question 3.3
function Prob = Pssan(s,sd,a,g)

    % Problem constants
    PVec = [0.2 0.6 0.2];
    off = [-1 -1 -1 -1 0 1;1 1 1 -1 0 1;-1 0 1 -1 -1 -1;-1 0 1 1 1 1];

	% Calculate the possible target squares and see whether sd is one of them
    rtmp = s(1) + off(a,1:3);
    ctmp = s(2) + off(a,4:6);
    for k = 1:3
        if (rtmp(k)<1) || (rtmp(k)>9) || (ctmp(k)<1) || (ctmp(k)>9) || (g(rtmp(k),ctmp(k))==1)
            rtmp(k) = s(1); % If try to move off edge or onto an X, stay where you are
            ctmp(k) = s(2);
        end
    end
    Prob = ((rtmp==sd(1)) & (ctmp==sd(2))) * PVec';
    
end
