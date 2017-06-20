% Implements the reward probabilities defined in Question 3.1
function Reward = Rssa(s,sd,a,g) %#ok<INUSL>

	% Problem constants
	RVec = [-1 -20 1 100]; % [Free X * G]
	move = [-1 0;1 0;0 -1;0 1]; % In the order up/down/left/right
	
	% Work out where the move would ideally go
	stmp = s + move(a,:);
	
	% Assign the appropriate rewards (assume the move is possible/legal - if not Pssa is zero anyway)
	if any((stmp<1)|(stmp>9))
		Reward = -5; % Note: Assume that if you're on a * field and you move against the border you don't get an extra +1
	else
		Reward = RVec(g(stmp(1),stmp(2))+1);
	end

end
