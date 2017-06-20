% Draw an arrow in the right spot and in the right direction to signify an action at a state
function DrawArrow(r,c,a) % Arrows aren't usably implemented in Octave/Matlab... :(

	% Arrow shape constants
	b = 0.1;
	e = 0.5;
	d = e - b * 1.3;
	rfleche = [-d -e -d;d e d;-b 0 b;-b 0 b];
	cfleche = [-b 0 b;-b 0 b;-d -e -d;d e d];
	
	% Plot the required arrow
	plot(c+[0 cfleche(a,2)],10-r-[0;rfleche(a,2)],'b','LineWidth',1.5);
	plot(c+cfleche(a,:),10-r-rfleche(a,:),'b','LineWidth',1.5);
	
end
