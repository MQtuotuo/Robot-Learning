% Transition and Reward Probabilities
% These functions define the transition and reward probabilities of the Markov Decision Process.
% 'Deterministic' refers to the probabilities as defined in Question 3.1 (|Pssa| and |Rssa|).
% 'Non-deterministic' refers to the probabilities as defined in Question 3.3 (|Pssan| and |Rssan|).

% Implements the transition probabilities defined in Question 3.1
function Prob = Pssa(s,sd,a,g)

	% Calculate the ideal target square of the action
	move = [-1 0;1 0;0 -1;0 1]; % In the order up/down/left/right
	stmp = s + move(a,:);
	if any((stmp<1)|(stmp>9)) || g(stmp(1),stmp(2)) == 1
		stmp = s; % Tried to go off the grid or on an X, so it moves nowhere...
	end
	
	% Unit probability iff the ideal target square is sd
    Prob = all(stmp == sd); % Comparing row and column...

end


