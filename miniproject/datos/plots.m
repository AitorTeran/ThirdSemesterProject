close all
clear all
clc

%% Read data
real_0 = load('real_0.mat');
real_100 = load('real_100.mat');
real_100_step = load('real_100_step.mat');
real_500 = load('real_500.mat');
real_500_step = load('real_500_step.mat');
est_100 = load('est_100.mat');
est_100_step = load('est_100_step.mat');

%% 500 rpm

fig = figure(1);

%3-phase current
subplot(4,1,1)
hold on
grid on
plot(real_500.real_500.t,real_500.real_500.iabc_meas.a)
plot(real_500.real_500.t,real_500.real_500.iabc_meas.b)
plot(real_500.real_500.t,real_500.real_500.iabc_meas.c)
legend('$i_a$','$i_b$','$i_c$','Interpreter','Latex')
ylabel('3-phase current [A]','Interpreter','Latex')

%dq current
subplot(4,1,2)
hold on
grid on
plot(real_500.real_500.t,real_500.real_500.idq_meas.d)
plot(real_500.real_500.t,real_500.real_500.idq_meas.q)
legend('$i_d$','$i_q$','Interpreter','Latex')
ylabel('dq current [A]','Interpreter','Latex')

%real rotor speed
subplot(4,1,3)
hold on
grid on
plot(real_500.real_500.t,real_500.real_500.omega*60/(4*2*pi))
plot(real_500.real_500.t,real_500.real_500.omegaest*60/(4*2*pi))
legend('$\omega_{r}$','$\hat{\omega}_{r}$','Interpreter','Latex')
ylabel('Speed [rpm]','Interpreter','Latex')

%real and estimated rotor position
subplot(4,1,4)
hold on
grid on
plot(real_500.real_500.t,real_500.real_500.theta)
plot(real_500.real_500.t,real_500.real_500.thetaest)
legend('$\theta_{r}$','$\hat{\theta}_{r}$','Interpreter','Latex')
ylabel('Angle [rad]','Interpreter','Latex')
xlabel('Time [s]','Interpreter','Latex')


%% 500 rpm frequency step
fig = figure(2);

%3-phase current
subplot(4,1,1)
hold on
grid on
plot(real_500_step.real_500_step.t,real_500_step.real_500_step.iabc_meas.a)
plot(real_500_step.real_500_step.t,real_500_step.real_500_step.iabc_meas.b)
plot(real_500_step.real_500_step.t,real_500_step.real_500_step.iabc_meas.c)
legend('$i_a$','$i_b$','$i_c$','Interpreter','Latex')
ylabel('3-phase current [A]','Interpreter','Latex')

%dq current
subplot(4,1,2)
hold on
grid on
plot(real_500_step.real_500_step.t,real_500_step.real_500_step.idq_meas.d)
plot(real_500_step.real_500_step.t,real_500_step.real_500_step.idq_meas.q)
legend('$i_d$','$i_q$','Interpreter','Latex')
ylabel('dq current [A]','Interpreter','Latex')

%real and estimated rotor speed
subplot(4,1,3)
hold on
grid on
plot(real_500_step.real_500_step.t,real_500_step.real_500_step.omega*60/(4*2*pi))
plot(real_500_step.real_500_step.t,real_500_step.real_500_step.omegaest*60/(4*2*pi))
legend('$\omega_{r}$','$\hat{\omega}_{r}$','Interpreter','Latex')
ylabel('Speed [rpm]','Interpreter','Latex')
ylim([-200,600])

theta_500_est = real_500_step.real_500_step.thetaest;
theta_500_real = real_500_step.real_500_step.theta;

for i = 1:length(theta_500_est)
    while theta_500_est(i)<0
        theta_500_est(i) = theta_500_est(i)+2*pi;
    end
end
for i = 1:length(theta_500_est)
    while theta_500_real(i)<0
        theta_500_real(i) = theta_500_real(i)+2*pi;
    end
end

%real and estimated rotor position
subplot(4,1,4)
hold on
grid on
plot(real_500_step.real_500_step.t,theta_500_real)
plot(real_500_step.real_500_step.t,theta_500_est)
legend('$\theta_{r}$','$\hat{\theta}_{r}$','Interpreter','Latex')
ylabel('Angle [rad]','Interpreter','Latex')
xlabel('Time [s]','Interpreter','Latex')


%% 100 rpm

fig = figure(3);

%3-phase current
subplot(4,1,1)
hold on
grid on
plot(real_100.real_100.t,real_100.real_100.iabc_meas.a)
plot(real_100.real_100.t,real_100.real_100.iabc_meas.b)
plot(real_100.real_100.t,real_100.real_100.iabc_meas.c)
legend('$i_a$','$i_b$','$i_c$','Interpreter','Latex')
ylabel('3-phase current [A]','Interpreter','Latex')

%dq current
subplot(4,1,2)
hold on
grid on
plot(real_100.real_100.t,real_100.real_100.idq_meas.d)
plot(real_100.real_100.t,real_100.real_100.idq_meas.q)
legend('$i_d$','$i_q$','Interpreter','Latex')
ylabel('dq current [A]','Interpreter','Latex')

%real rotor speed
subplot(4,1,3)
hold on
grid on
plot(real_100.real_100.t,real_100.real_100.omega*60/(4*2*pi))
plot(real_100.real_100.t,real_100.real_100.omegaest*60/(4*2*pi))
legend('$\omega_{r}$','$\hat{\omega}_{r}$','Interpreter','Latex')
ylabel('Speed [rpm]','Interpreter','Latex')

%real and estimated rotor position
subplot(4,1,4)
hold on
grid on
plot(real_100.real_100.t,real_100.real_100.theta)
plot(real_100.real_100.t,real_100.real_100.thetaest)
legend('$\theta_{r}$','$\hat{\theta}_{r}$','Interpreter','Latex')
ylabel('Angle [rad]','Interpreter','Latex')
xlabel('Time [s]','Interpreter','Latex')


%% 100 rpm step

fig = figure(4);

%3-phase current
subplot(4,1,1)
hold on
grid on
plot(real_100_step.real_100_step.t,real_100_step.real_100_step.iabc_meas.a)
plot(real_100_step.real_100_step.t,real_100_step.real_100_step.iabc_meas.b)
plot(real_100_step.real_100_step.t,real_100_step.real_100_step.iabc_meas.c)
legend('$i_a$','$i_b$','$i_c$','Interpreter','Latex')
ylabel('3-phase current [A]','Interpreter','Latex')

%dq current
subplot(4,1,2)
hold on
grid on
plot(real_100_step.real_100_step.t,real_100_step.real_100_step.idq_meas.d)
plot(real_100_step.real_100_step.t,real_100_step.real_100_step.idq_meas.q)
legend('$i_d$','$i_q$','Interpreter','Latex')
ylabel('dq current [A]','Interpreter','Latex')

%real rotor speed
subplot(4,1,3)
hold on
grid on
plot(real_100_step.real_100_step.t,real_100_step.real_100_step.omega*60/(4*2*pi))
plot(real_100_step.real_100_step.t,real_100_step.real_100_step.omegaest*60/(4*2*pi))
legend('$\omega_{r}$','$\hat{\omega}_{r}$','Interpreter','Latex')
ylabel('Speed [rpm]','Interpreter','Latex')
ylim([-200, 200])

theta_100_est = real_100_step.real_100_step.thetaest;
theta_100_real = real_100_step.real_100_step.theta;

for i = 1:length(theta_100_est)
    while theta_100_est(i)<0
        theta_100_est(i) = theta_100_est(i)+2*pi;
    end
end
for i = 1:length(theta_100_est)
    while theta_100_real(i)<0
        theta_100_real(i) = theta_100_real(i)+2*pi;
    end
end

%real and estimated rotor position
subplot(4,1,4)
hold on
grid on
plot(real_100_step.real_100_step.t,theta_100_real)
plot(real_100_step.real_100_step.t,theta_100_est)
legend('$\theta_{r}$','$\hat{\theta}_{r}$','Interpreter','Latex')
ylabel('Angle [rad]','Interpreter','Latex')
xlabel('Time [s]','Interpreter','Latex')


%% 100 rpm estimated

fig = figure(5);

%3-phase current
subplot(4,1,1)
hold on
grid on
plot(est_100.est_100.t,est_100.est_100.iabc_meas.a)
plot(est_100.est_100.t,est_100.est_100.iabc_meas.b)
plot(est_100.est_100.t,est_100.est_100.iabc_meas.c)
legend('$i_a$','$i_b$','$i_c$','Interpreter','Latex')
ylabel('3-phase current [A]','Interpreter','Latex')

%dq current
subplot(4,1,2)
hold on
grid on
plot(est_100.est_100.t,est_100.est_100.idq_meas.d)
plot(est_100.est_100.t,est_100.est_100.idq_meas.q)
legend('$i_d$','$i_q$','Interpreter','Latex')
ylabel('dq current [A]','Interpreter','Latex')

%real rotor speed
subplot(4,1,3)
hold on
grid on
plot(est_100.est_100.t,est_100.est_100.omega*60/(4*2*pi))
plot(est_100.est_100.t,est_100.est_100.omegaest*60/(4*2*pi))
legend('$\omega_{r}$','$\hat{\omega}_{r}$','Interpreter','Latex')
ylabel('Speed [rpm]','Interpreter','Latex')

%real and estimated rotor position
subplot(4,1,4)
hold on
grid on
plot(est_100.est_100.t,est_100.est_100.theta)
plot(est_100.est_100.t,est_100.est_100.thetaest)
legend('$\theta_{r}$','$\hat{\theta}_{r}$','Interpreter','Latex')
ylabel('Angle [rad]','Interpreter','Latex')
xlabel('Time [s]','Interpreter','Latex')


%% 0 rpm step

fig = figure(6);

%3-phase current
subplot(4,1,1)
hold on
grid on
plot(real_0.real_0.t,real_0.real_0.iabc_meas.a)
plot(real_0.real_0.t,real_0.real_0.iabc_meas.b)
plot(real_0.real_0.t,real_0.real_0.iabc_meas.c)
legend('$i_a$','$i_b$','$i_c$','Interpreter','Latex')
ylabel('3-phase current [A]','Interpreter','Latex')

%dq current
subplot(4,1,2)
hold on
grid on
plot(real_0.real_0.t,real_0.real_0.idq_meas.d)
plot(real_0.real_0.t,real_0.real_0.idq_meas.q)
legend('$i_d$','$i_q$','Interpreter','Latex')
ylabel('dq current [A]','Interpreter','Latex')

%real rotor speed
subplot(4,1,3)
hold on
grid on
plot(real_0.real_0.t,real_0.real_0.omega*60/(4*2*pi))
plot(real_0.real_0.t,real_0.real_0.omegaest*60/(4*2*pi))
legend('$\omega_{r}$','$\hat{\omega}_{r}$','Interpreter','Latex')
ylabel('Speed [rpm]','Interpreter','Latex')
ylim([-200,200])

theta_0_est = real_0.real_0.thetaest;
theta_0_real = real_0.real_0.theta;

for i = 1:length(theta_0_est)
    while theta_0_est(i)<0
        theta_0_est(i) = theta_0_est(i)+2*pi;
    end
end
for i = 1:length(theta_0_est)
    while theta_0_real(i)<0
        theta_0_real(i) = theta_0_real(i)+2*pi;
    end
end

%real and estimated rotor position
subplot(4,1,4)
hold on
grid on
plot(real_0.real_0.t,theta_0_real)
plot(real_0.real_0.t,theta_0_est)
legend('$\theta_{r}$','$\hat{\theta}_{r}$','Interpreter','Latex')
ylabel('Angle [rad]','Interpreter','Latex')
xlabel('Time [s]','Interpreter','Latex')
