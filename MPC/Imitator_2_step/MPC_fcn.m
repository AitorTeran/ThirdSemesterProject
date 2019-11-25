function [vector, vref_alpha, vref_beta] = MPC_fcn(time, vc_alpha, vc_beta,if_alpha, if_beta, R, x_opt_old, v, states, Adf, Bdf, C, wref )

g = zeros(1,7);
weight1 = 3; 
vector = zeros(7,1);
vref_alpha=325*sin(2*pi*50*time);
vref_beta=325*sin(2*pi*50*time-3*pi/2);

vref_alpha1=325*sin(2*pi*50*time+pi*0.002);
vref_beta1=325*sin(2*pi*50*time-3*pi/2+pi*0.002);

vref_alpha2=325*sin(2*pi*50*time+pi*0.004);
vref_beta2=325*sin(2*pi*50*time-3*pi/2+pi*0.004);


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
        constraint1=inf;
    else
        constraint1=0;
    end

   for j= 1:7
         % N= 2 horizon
         v_o2 = v(j);
         ift2= Adf(1,1)*ift1+Adf(1,2)*vc1+Bdf(1,1)*v_o2 +Bdf(1,2)*i_load;
         vc2=Adf(2,1)*ift1+Adf(2,2)*vc1+Bdf(2,1)*v_o2 + Bdf(2,2)*i_load;   
           
          
        if sqrt(real(ift2)^2+imag(ift2)^2)>40
        constraint2=inf;
        else
        constraint2=0;
        end  
        
        %Cost function     
        g(i,j) = (real(v_ref - vc1))^2+(imag(v_ref - vc1))^2 + (real(v_ref1 - vc2))^2+(imag(v_ref1 - vc2))^2 + constraint1 + constraint2 +weight1*((real(ift1 - i_load)+C*wref*imag(v_ref))^2+(imag(ift1 - i_load)-C*wref*real(v_ref))^2) + weight1*((real(ift2 - i_load)+C*wref*imag(v_ref1))^2+(imag(ift2 - i_load)-C*wref*real(v_ref1))^2);  
        
  end 
end

[~,I] = min(g(:));
[x_opt, ~] = ind2sub(size(g),I);
vector(x_opt,1)= 1;

