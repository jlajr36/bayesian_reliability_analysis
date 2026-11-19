theta = 0.01:0.01:0.99;

alpha = 8.0;
beta = 4.0;

prior = gamma(alpha+beta) / gamma(alpha) / gamma(beta) * power(theta,alpha-1) .* power(1-theta,beta-1);
[pks, locs] = findpeaks(prior/sum(prior), theta);
peakAt = locs;
figure(Name="Prior");
plot(theta, prior/sum(prior));
hold on;
plot(locs, pks, 'r*', 'DisplayName', 'Peaks');
text(locs, pks, [' Location: ', num2str(locs)], 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
hold off;

n = 100;
x = 92;

likelihood = factorial(n) / factorial(n-x) / factorial(x) * power(theta,x) .* power(1-theta,n-x);
[pks, locs] = findpeaks(likelihood/sum(likelihood), theta);
likelihoodPeakAt = locs;
figure(Name="Likelihood");
plot(theta, likelihood/sum(likelihood));
hold on;
plot(locs, pks, 'r*', 'DisplayName', 'Peaks');
text(locs, pks, [' Location: ', num2str(locs)], 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
hold off;

posterior = likelihood .* prior;
posterior = posterior / sum(posterior);
[pks, locs] = findpeaks(posterior, theta);
posteriorPeakAt = locs;
figure(Name="Posterior");
plot(theta, posterior);
hold on;
plot(locs, pks, 'r*', 'DisplayName', 'Peaks');
text(locs, pks, [' Location: ', num2str(locs)], 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
hold off;