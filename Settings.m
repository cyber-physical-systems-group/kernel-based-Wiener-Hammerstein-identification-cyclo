% Experiment settings

% Bandwith parameters

a = [0.46; 1   ; 1   ; 50  ];
b = [-0.1; -1/6; -1/6; -1/2];

% Notation: h_all(n) = a(n) * N^(b(n))
%
% In code  | In paper          | Used to estimate
% ---------|-------------------|----------------------------
% h_all(1) | $h$               | convoluted impulse response
% h_all(2) | $h_{\mathcal{M}}$ | $\mathcal{M}_{k_0}$
% h_all(3) | $h_{\text{loc}}$  | local nonlinearities
% h_all(4) | $h_{\text{nonl}}$ | entire nonlinearity

% System
lambda = [3 1]';
lambda = lambda/lambda(1);
S = length(lambda) - 1;

gamma = [2 1]';
gamma = gamma/gamma(1);
R = length(gamma) - 1;

TrueConvImp = conv(lambda,gamma,'full');

% Input process
eps_amp = (1/sqrt(2))*[1 1]; % Format: [Value_for_first_half_of_data, Value_for_second_half]
eps_PDF = 'Gaussian'; %'uniform', 'triangular', 'Gaussian'
z_amp = 0.1*eps_amp;

P = 200000;
T = 5;
N = P*T;

% Other
refPoint = zeros(R+S+1,1); % first index is newest sample
refPoint = flip(refPoint); % due to the Dk implementation, first index is oldest sample in code

ShowPlots = logical(true);
PlotPositionAndSize = [200 100 700 300];