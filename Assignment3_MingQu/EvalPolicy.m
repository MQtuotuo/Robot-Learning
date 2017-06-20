% Policy Evaluation
% Apply the iterative policy evaluation algorithm on a generic policy, supplied as a parameter.
% The core equation of this method is the following.
%
% $$ V(s) \leftarrow \Sigma_a \pi(s,a) \Sigma_{s'} P_{ss'}^a [ R_{ss'}^a + \gamma V(s') ] $$
%
% This is iterated over every state in multiple sweeps, until the maximum absolute change of any value of V during a sweep is below some stopping criterion.

% Apply iterative policy evaluation to estimate the value function corresponding to a particular policy
function V = EvalPolicy(Pol,Pfn,Rfn,gamma,tol)

	% Calculate the expected point values of all the cells
	V = zeros(9,9);
	delta = Inf;
	while delta > tol % Wait until the maximum absolute change in V of any cell is less than a specified tolerance
		delta = 0;
		for r = 1:9
			for c = 1:9
				if ~((r == 5) && (c == 9)) % Force goal position to stay at V = 0 as the episode ends if you go there
				
					% Save the old value of V for this cell
					VOldrc = V(r,c);
					
					% Update our estimate for V
					s = [r c];
					sum = 0;
					for a = 1:4 % Every possible action...
						for inc = [-1 -1;-1 0;-1 1;0 -1;0 0;0 1;1 -1;1 0;1 1]' % Every possible successor cell is within +-1 in r and c
							sd = s + inc';
							if ~any((sd<1)|(sd>9)) % Bound sd to within the grid
								sum = sum + Pol(s,a) * Pfn(s,sd,a) * (Rfn(s,sd,a) + gamma * V(sd(1),sd(2)));
							end
						end
					end
					V(r,c) = sum;
					
					% Update delta if we just saw a bigger change in V than anywhere previously in this sweep
					delta = max([delta abs(V(r,c) - VOldrc)]);
					
				end
			end
		end
	end

end
