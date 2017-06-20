% Implements the optimal policy defined as greedy with respect to the optimal value function
function Prob = OptPolicy(s,a,Vstar,Pfn,Rfn,gamma)

	% Calculate the greedy move with respect to Vstar
	maxv = -Inf;
	for aa = 1:4 % Every possible action...
		sum = 0;
		for inc = [-1 -1;-1 0;-1 1;0 -1;0 0;0 1;1 -1;1 0;1 1]' % Every possible successor cell is within +-1 in r and c, and there's always at least one
			sd = s + inc';
			if ~any((sd<1)|(sd>9)) % Bound sd to within the grid
				sum = sum + Pfn(s,sd,aa) * (Rfn(s,sd,aa) + gamma * Vstar(sd(1),sd(2)));
			end
		end
		if sum > maxv % Find the value and action for the greediest move
			maxv = sum;
			maxa = aa;
		end
	end
	
	% Implement the policy to always choose the greedy move
	if a == maxa
		Prob = 1;
	else
		Prob = 0;
	end
					
end
