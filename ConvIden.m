% Convoluted impulse response identification

h_all = a.*N.^(b);
h = [h_all(1); h_all(2)];
[ConvImpKw,~,~] = KW(1:T,P-1,eps(1:N),y(1:N),S+R,h,T,refPoint);

% Estimation of $c_{k_0}$
ck0 = ConvImpKw(1,:).';

x_bar = conv(Eu(1:(ceil(3*(R+S+1)/T)*T+T)),lambda,'full');
x_bar = x_bar(1:(ceil(3*(R+S+1)/T)*T+T));
x_bar = x_bar(end-T+1:end);
ck0_true = 2*x_bar + 2*pi*cos(2*pi*x_bar);

ConvImpTrue = zeros(R+S+1,T);
for k_0 = 1:T
  gamma_ck0 = gamma.*ck0_true(k0FromK(k_0-(0:R),T));
  ConvImpTrue(:,k_0) = conv(lambda,gamma_ck0);
end

ConvImpComparison = [ConvImpKw NaN(3,1) ConvImpTrue];
MSE_KWall = mean((ConvImpKw - ConvImpTrue).^2);
MSE_KW = mean(MSE_KWall)
M = M_est(1:T,P-1,eps(1:N),y(1:N),R+S,h(2),T,refPoint);
v_bar = mu(x_bar);
w_bar = zeros(T,1);
for k_0 = 1:T
  w_bar(k_0) = gamma(1)*v_bar(k0FromK(k_0,T)) + gamma(2)*v_bar(k0FromK(k_0-1,T));
end
MSE_M = mean((M-w_bar).^2)

% Uncomment for test with true values
% ck0 = ck0_true;
% ConvImpKw = ConvImpTrue;


