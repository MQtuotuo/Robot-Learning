% Policy Optimisation
% Apply the value iteration algorithm to numerically calculate the optimal value function $V^*(s)$.
% The core equation of this method is the following.
%
% $$ V(s) \leftarrow max_a \Sigma_{s'} P_{ss'}^a [ R_{ss'}^a + \gamma V(s') ] $$
%
% This is iterated over every state in sweeps until the maximum absolute change of any value of V during a sweep is below some stopping criterion.
% The optimal policy can then be evaluated based on the optimal value function using the following formula.
%
% $$ \pi^*(s) = arg max_a \Sigma_{s'} P_{ss'}^a [ R_{ss'}^a + \gamma V^*(s') ] $$
%
% The |DefPolicy| function implements the policy defined in Question 3.1.

% Apply value iteration algorithm to obtain an optimal value function V*
function V = OptimalV(Pfn,Rfn,gamma,tol)

	% Calculate the optimum point values of all the cells iteratively
	V = zeros(9,9);
	delta = Inf;
	while delta > tol % Wait until the maximum absolute change in V of any cell is less than a specified tolerance
		delta = 0;
		for r = 1:9
			for c = 1:9
				if ~((r == 5) && (c == 9)) % Force goal position to stay at V = 0 as the episode ends if you go there
				
					% Save the old value of V for this cell
					VOldrc = V(r,c);
					
					% Update our value for V
					s = [r c];
					maxv = -Inf;
					for a = 1:4 % Every possible action...
						sum = 0;
						for inc = [-1 -1;-1 0;-1 1;0 -1;0 0;0 1;1 -1;1 0;1 1]' % Every possible successor cell is within +-1 in r and c, and there's always at least one
							sd = s + inc';
							if ~any((sd<1)|(sd>9)) % Bound sd to within the grid
								sum = sum + Pfn(s,sd,a) * (Rfn(s,sd,a) + gamma * V(sd(1),sd(2)));
							end
						end
						if sum > maxv % Find the value for the greediest move
							maxv = sum; % Note that if two greedy moves are the same value, this just systematically picks one of them
						end
					end
					V(r,c) = maxv;
					
					% Update delta if we just saw a bigger change in V than anywhere previously in this sweep
					delta = max([delta abs(V(r,c) - VOldrc)]);
					
				end
			end
		end
	end

end