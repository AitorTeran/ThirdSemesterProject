function [vector, vref_alpha, vref_beta] = MPC_fcn(time, vc_alpha, vc_beta,if_alpha, if_beta, R, x_opt_old, v, states, Adf, Bdf, C, wref )

g = zeros(1,7);
weight1 = 3; 
vector = zeros(7,1);
wref = 2*pi*wref;
vref_alpha=325*sin(wref*time);
vref_beta=325*sin(wref*time-3*pi/2);

vref_alpha1=325*sin(wref*time+pi*0.002);
vref_beta1=325*sin(wref*time-3*pi/2+pi*0.002);

vref_alpha2=325*sin(wref*time+pi*0.004);
vref_beta2=325*sin(wref*time-3*pi/2+pi*0.004);


v_ref = vref_alpha + 1j*vref_beta;
v_ref_old = vref_alpha1 + 1j*vref_beta1;
v_ref_old2 = vref_alpha2 + 1j*vref_beta2;


v_ref1= 3*v_ref - 3*v_ref_old +v_ref_old2;

v_meas = vref_alpha + vc_alpha + 1j*(vref_beta+vc_beta);
i_load = (vref_alpha + vc_alpha)/R + 1j*(vref_beta+vc_beta)/R;
i_meas = if_alpha + 1j*if_beta;
x_old = x_opt_old;

for i = 1:7
        
    % delay compensation
    iftd= Adf(1,1)*i_meas+Adf(1,2)*v_meas+Bdf(1,1)*v(x_old)+Bdf(1,2)*i_load;
    vcd=Adf(2,1)*i_meas+Adf(2,2)*v_meas+Bdf(2,1)*v(x_old)+Bdf(2,2)*i_load;    
        
        
    v_o1 = v(i);
    % potential application voltages
    ift1= Adf(1,1)*iftd+Adf(1,2)*vcd+Bdf(1,1)*v_o1+Bdf(1,2)*i_load;
    vc1=Adf(2,1)*iftd+Adf(2,2)*vcd+Bdf(2,1)*v_o1+Bdf(2,2)*i_load;   
    
    %sw=sum(abs(states(x_old,:)-states(i,:))); 
      
    if sqrt(real(ift1)^2 +  imag(ift1)^2)>30
        constraint=inf;
    else
        constraint=0;
           end
       
      %Cost function    
    %g(i) = constraint + (real(v_ref - vc1))^2+(imag(v_ref - vc1))^2;

    g(i) = constraint + (real(v_ref1 - vc1))^2+(imag(v_ref1 - vc1))^2+  weight1*((real(ift1 - i_load)+C*wref*imag(v_ref1))^2+(imag(ift1 - i_load)-C*wref*real(v_ref1))^2);%+weight2*sw^2;
end

[~,x_opt] = min(g);
vector(x_opt,1)= 1;

