function [ out ] = secondDerivPos( angle, angleSpeed, angleAccell, f )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
l = 0.75;
mc = 1.0; mp = 0.5; 

out=(f-mp*l*(angleAccell*cos(angle)-angleSpeed*angleSpeed*sin(angle)))/(mc+mp);
 
end

