function [posteriorPeakAt, peakAt, likelihoodPeakAt, prior, likelihood, posterior, theta] = runBayesianAnalysis(alpha, beta, N, x)
    % 1. Create Theta Domain
    theta = linspace(0.001, 0.999, 1000);

    % 2. Prior Calculation
    prior_raw = (gamma(alpha+beta) / (gamma(alpha)*gamma(beta))) .* (theta.^(alpha-1)) .* ((1-theta).^(beta-1));
    prior = prior_raw / sum(prior_raw);
    [~, idx_prior] = max(prior);
    peakAt = theta(idx_prior);

    % 3. Likelihood Calculation
    likelihood_raw = (theta.^x) .* ((1-theta).^(N-x));
    likelihood = likelihood_raw / sum(likelihood_raw);
    [~, idx_like] = max(likelihood);
    likelihoodPeakAt = theta(idx_like);

    % 4. Posterior Calculation
    posterior_raw = likelihood .* prior;
    posterior = posterior_raw / sum(posterior_raw);
    [~, idx_post] = max(posterior);
    posteriorPeakAt = theta(idx_post);

    % 5. Plotting (Executes seamlessly once at the end)
    figure('Name', 'Bayesian Reliability Results', 'Color', 'w');
    plot(theta, prior, 'b--', 'LineWidth', 1.5, 'DisplayName', sprintf('Prior (Peak: %.2f)', peakAt)); hold on;
    plot(theta, likelihood, 'g:', 'LineWidth', 1.5, 'DisplayName', sprintf('Likelihood (Peak: %.2f)', likelihoodPeakAt));
    plot(theta, posterior, 'm-', 'LineWidth', 2.0, 'DisplayName', sprintf('Posterior (Peak: %.4f)', posteriorPeakAt));
    title('Bayesian Reliability Analysis');
    xlabel('\theta (Reliability Parameter)'); ylabel('Normalized Probability');
    grid on; legend('Location', 'northwest');
end