%% Plotting Functions
% These functions are used to generalise the plotting of policies and value functions so that code does not need to be unnecessarily repeated.

% Plot the required policy (assumed that all probabilities are either 0 or 1)
function PlotPolicy(Pol,g,fig,name)

	% Do the required plotting
	figure(fig);
    set(fig,'Position',[100 100 850 580]);
	subplot(1,1,1);cla;
	axis([0 10 0 10]);
	set(gca,'xtick',0:1:10);
	set(gca,'ytick',0:1:10);
	hold on;
	plot([1 9],[5 5],'ro','MarkerSize',15);
	for r = 1:9
		for c = 1:9
			s = [r c];
			for a = 1:4
				if (Pol(s,a) > 0) && ~all(s == [5 9]) % If this is the greedy action for this state...
					DrawArrow(r,c,a);
				end
			end
			if g(r,c) == 1
				plot(c,10-r,'rx','MarkerSize',15);
			elseif g(r,c) == 2
				plot(c,10-r,'r*','MarkerSize',15);
			end
		end
	end
	hold off;
	grid on;
	title(name);
    axis equal;

end

