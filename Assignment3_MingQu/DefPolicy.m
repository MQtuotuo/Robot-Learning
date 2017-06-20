% Implements the policy specified in Question 3.1
function Prob = DefPolicy(s,a) %#ok<INUSL>

	% Choose a random action with probability 0.5, otherwise move to the right
	PVec = [0.125 0.125 0.125 0.625]; % In the order up/down/left/right
	Prob = PVec(a);
	
end