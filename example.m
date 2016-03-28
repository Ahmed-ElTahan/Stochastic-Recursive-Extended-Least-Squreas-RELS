%
%{
        This is an example to show how to use the RecursiveExtendedLeastSquares (RELS)
        function. At first, Imagine that I have a transfer function that I
        know its parameters and its orders (na, nb, nc and d). By exciting its output with a certain input
        which is here is a damped sine, I can get the input and output of
        this dynamic system as similar as an experiment. Now I use these
        input and output vectors with the RELS algorithm to estimate the
        parameters
        This is going to be the model in this example
        A = [1 -0.4 0.5]; B = [1.2, 0.3]; C = [1, 0.8 -0.1]; % True plant to be estimated
        
        Note: the noise added shall not to be with a magnitude close to the
        system output, it should be smaller, this is in simulation such as
        here or the algorithm will go crazy that can't distinguish between
        the main and the noisy signal (This can be measured in practical 
        case finding noise to signal ratio).

%}
clc; clear all; close all;

% Gathering the input, output and the noise characteristics

Ts = 1; % sample time
t = 0:Ts:20000; % The number of points shall be large enough 

u= randn(length(t),1); % input
eps= randn(length(t),1); % noise addition

A = [1 -0.4 0.5]; B = [1.2, 0.3]; C = [1, 0.8 -0.1]; % True plant to be estimated
d = 1; %input output delay

% finding the output due to the input and the dynamics
L = zeros(length(t), 1);
M = zeros(length(t), 1);
y = zeros(length(t), 1);
for i = 1 : length(t)
    L(i) = outputestimation( A, B, d, u, L, i );
    M(i) = outputestimation( A,  C, 0, eps, M, i );
    y(i) = L(i)+M(i);
end
y = y';


%% Estimation using RecursiveExtendedLeastSquares function
[ theta, Gz_estm ] = RecursiveExtendedLeastSquares( u, y, 2, 1, 1, 2, Ts) % 2nd RELS order estimation
% [ theta, Gz_estm ] = RecursiveLeastSquares( u, y, 2, 1, 1, Ts) % 2nd order RLS estimation
