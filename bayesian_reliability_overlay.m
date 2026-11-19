% Discretize system reliability theta over [0.01, 0.99]
theta = 0.01:0.01:0.99;

% 1. Prior Distribution (Beta(alpha=8, beta=4))
alpha = 8.0;
beta = 4.0;
prior = gamma(alpha+beta) / gamma(alpha) / gamma(beta) * power(theta,alpha-1) .* power(1-theta,beta-1);
priorNorm = prior / sum(prior);
[priorPks, priorLocs] = findpeaks(priorNorm, theta);

% 2. Likelihood Function (Binomial(n=100, x=92))
n = 100;
x = 92;
likelihood = factorial(n) / factorial(n-x) / factorial(x) * power(theta,x) .* power(1-theta,n-x);
likelihoodNorm = likelihood / sum(likelihood);
[likePks, likeLocs] = findpeaks(likelihoodNorm, theta);

% 3. Posterior Distribution (Updated Beta)
posterior = likelihood .* prior;
posteriorNorm = posterior / sum(posterior);
[postPks, postLocs] = findpeaks(posteriorNorm, theta);

% --- Combined Overlay Plot ---
figure('Name', 'Bayesian System Reliability Analysis - Combined Overlay');
hold on;

% Plot all three probability curves on one set of axes
plot(theta, priorNorm, '--b', 'LineWidth', 2, 'DisplayName', 'Prior \pi(\theta)');
plot(theta, likelihoodNorm, ':m', 'LineWidth', 2, 'DisplayName', 'Likelihood p(x|\theta)');
plot(theta, posteriorNorm, '-g', 'LineWidth', 2.5, 'DisplayName', 'Posterior \pi(\theta|x)');

% Plot peak locations using your original 'r*' markers
plot(priorLocs, priorPks, 'r*', 'MarkerSize', 8, 'HandleVisibility', 'off');
plot(likeLocs, likePks, 'r*', 'MarkerSize', 8, 'HandleVisibility', 'off');
plot(postLocs, postPks, 'r*', 'MarkerSize', 8, 'HandleVisibility', 'off');

% Add peak location labels
text(priorLocs, priorPks, [' Prior Peak: ', num2str(priorLocs, '%.2f')], ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 9);
text(likeLocs, likePks, [' Likelihood Peak: ', num2str(likeLocs, '%.2f')], ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 9);
text(postLocs, postPks, [' Posterior Peak: ', num2str(postLocs, '%.2f')], ...
    'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'FontSize', 9);

% Chart formatting
title('Bayesian Reliability Updating: Prior, Likelihood, & Posterior Overlay');
xlabel('System Reliability Parameter (\theta)');
ylabel('Normalized Probability Density / Mass');
grid on;
legend('Location', 'northwest');
hold off;