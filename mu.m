function y = mu(x)
% Uncomment for different experiment setups
%y = 0.1*x.^2;
%y = 1*x.^2;
%y = -2*x;
%y = 2*x;
%y = abs(x);
y = 1*x.^2+1*sin(2*pi*x);
%y = 10*sawtooth(3*x,0.5);
end