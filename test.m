x =(1:app.stackInfo.nFrames)';
y = app.ROIsData.traces(:,2);
modelfun = @(b,x) b(1) + b(2) * exp(b(3)-b(4)*x(:,1));
beta0 = [100, 250, -0.5, -0.005];
mdl = fitnlm(x, y, modelfun, beta0);

coef = mdl.Coefficients{:, 'Estimate'};
yFitted = coef(1) + coef(2) * exp(coef(3)-coef(4)*x);
plot(yFitted)
