%% Bayesian Reliability Analysis for New Pump Component
% Self-contained script implementing Prior, Likelihood, and Posterior calculations

clear; clc; close all;

%% 1. Parameter Definitions
% Prior Beta Distribution Parameters (Historical Estimates)
alpha = 9;
beta  = 3;

% New Supplier Test Data
N = 200;  % Total units tested
x = 182;  % Successful units

%% 2. Theta Domain Definition
theta = linspace(0, 1, 1000); % Reliability parameter domain [0, 1]

%% 3. Prior Distribution Calculation
% Beta prior PDF
prior = (gamma(alpha + beta) / (gamma(alpha) * gamma(beta))) .* (theta.^(alpha - 1)) .* ((1 - theta).^(beta - 1));
prior_norm = prior / sum(prior); % Normalized discrete PDF

[prior_pk, prior_idx] = max(prior_norm);
prior_loc = theta(prior_idx);

%% 4. Likelihood Function Calculation
% Binomial likelihood for N tests with x successes
% Note: Omitted nchoosek constant to prevent numerical overflow at large N
likelihood = (theta.^x) .* ((1 - theta).^(N - x));
likelihood_norm = likelihood / sum(likelihood); % Normalized discrete PDF

[like_pk, like_idx] = max(likelihood_norm);
like_loc = theta(like_idx);

%% 5. Posterior Distribution Calculation
% Bayes' Rule: Posterior ~ Likelihood * Prior
posterior_raw = likelihood_norm .* prior_norm;
posterior = posterior_raw / sum(posterior_raw); % Normalized discrete PDF

[post_pk, post_idx] = max(posterior);
post_loc = theta(post_idx);

%% 6. Display Numerical Results
fprintf('========================================\n');
fprintf('     BAYESIAN RELIABILITY RESULTS       \n');
fprintf('========================================\n');
fprintf('Prior Peak (Mode):      theta = %.4f\n', prior_loc);
fprintf('Likelihood Peak (Mode): theta = %.4f\n', like_loc);
fprintf('Posterior Peak (Mode):  theta = %.4f\n', post_loc);
fprintf('========================================\n');

%% 7. Visualizations

% Figure 1: Individual Subplots
figure('Name', 'Bayesian Reliability Analysis - Subplots', 'Color', 'w');

% Prior Subplot
subplot(3, 1, 1);
plot(theta, prior_norm, 'b-', 'LineWidth', 1.5); hold on;
plot(prior_loc, prior_pk, 'r*', 'MarkerSize', 8);
title(sprintf('Prior Distribution (\\alpha = %d, \\beta = %d)', alpha, beta));
xlabel('\theta (Reliability)'); ylabel('Probability');
grid on;
legend('Prior PDF', sprintf('Peak: \\theta = %.2f', prior_loc), 'Location', 'northwest');

% Likelihood Subplot
subplot(3, 1, 2);
plot(theta, likelihood_norm, 'g-', 'LineWidth', 1.5); hold on;
plot(like_loc, like_pk, 'r*', 'MarkerSize', 8);
title(sprintf('Likelihood Function (N = %d, x = %d)', N, x));
xlabel('\theta (Reliability)'); ylabel('Probability');
grid on;
legend('Likelihood', sprintf('Peak: \\theta = %.2f', like_loc), 'Location', 'northwest');

% Posterior Subplot
subplot(3, 1, 3);
plot(theta, posterior, 'm-', 'LineWidth', 1.5); hold on;
plot(post_loc, post_pk, 'r*', 'MarkerSize', 8);
title('Posterior Distribution');
xlabel('\theta (Reliability)'); ylabel('Probability');
grid on;
legend('Posterior PDF', sprintf('Peak: \\theta = %.4f', post_loc), 'Location', 'northwest');

% Figure 2: Combined Overlay Comparison
figure('Name', 'Combined Bayesian Distributions', 'Color', 'w');
plot(theta, prior_norm, 'b--', 'LineWidth', 1.5, 'DisplayName', sprintf('Prior (Peak: %.2f)', prior_loc)); hold on;
plot(theta, likelihood_norm, 'g:', 'LineWidth', 1.5, 'DisplayName', sprintf('Likelihood (Peak: %.2f)', like_loc));
plot(theta, posterior, 'm-', 'LineWidth', 2.0, 'DisplayName', sprintf('Posterior (Peak: %.4f)', post_loc));
title('Bayesian Reliability Analysis: Combined Distribution Comparison');
xlabel('\theta (Pump Reliability Parameter)'); ylabel('Normalized Probability');
grid on;
legend('Location', 'northwest');