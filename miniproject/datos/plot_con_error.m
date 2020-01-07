close all
clear all
clc

prueba_100_rpm = load('real_100_step_2.mat');

fig = figure(1);

%3-phase current
subplot(5,1,1)
hold on
grid on
plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.iabc_meas.a)
plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.iabc_meas.b)
plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.iabc_meas.c)
legend('$i_a$','$i_b$','$i_c$','Interpreter','Latex')
ylabel('3-phase current [A]','Interpreter','Latex')

%dq current
subplot(5,1,2)
hold on
grid on
plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.idq_meas.d)
plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.idq_meas.q)
legend('$i_d$','$i_q$','Interpreter','Latex')
ylabel('dq current [A]','Interpreter','Latex')

%real rotor speed
subplot(5,1,3)
hold on
grid on
plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.omega*60/(4*2*pi))
plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.omegaest*60/(4*2*pi))
legend('$\omega_{r}$','$\hat{\omega}_{r}$','Interpreter','Latex')
ylabel('Speed [rpm]','Interpreter','Latex')

%real and estimated rotor position
subplot(5,1,4)
hold on
grid on

plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.theta)
plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.thetaest)
legend('$\theta_{r}$','$\hat{\theta}_{r}$','Interpreter','Latex')
ylabel('Angle [rad]','Interpreter','Latex')
xlabel('Time [s]','Interpreter','Latex')


subplot(5,1,5)
hold on
grid on

for i=1:length(prueba_100_rpm.prueba_100_rpm.theta_error)
if    prueba_100_rpm.prueba_100_rpm.theta_error(i)>2
         a(i)=prueba_100_rpm.prueba_100_rpm.theta_error(i)-2*pi;
else
         a(i)=prueba_100_rpm.prueba_100_rpm.theta_error(i);
end
end
    plot(prueba_100_rpm.prueba_100_rpm.t,a)
%plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.theta_error)
%plot(prueba_100_rpm.prueba_100_rpm.t,prueba_100_rpm.prueba_100_rpm.thetaest)
legend('$\theta_{r}$','$\hat{\theta}_{r}$','Interpreter','Latex')
ylabel('Angle error [rad]','Interpreter','Latex')
xlabel('Time [s]','Interpreter','Latex')


  