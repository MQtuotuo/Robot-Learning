% Plot the required value function
function PlotValueFn(V,fig,name)
	
	% Do the required plotting
	figure(fig);
    set(fig,'Position',[100 100 850 580]);
	subplot(1,1,1);
	surf(V);
	title(name);
	
end
