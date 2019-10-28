%%
Ts=0.00005;

results(1,:) = ["x_old","t","Rload","ifa","ifb","vca","vcb","x_opt","vrefa","vrefb"];
index = 1;
for x_old = 1:1:7
    for t = 0:0.002:0.018
        for Rload = 30:5:60
            for ifa = -16:3:16    
                for ifb = -16:3:16
                    i_f = [ifa, ifb];
                    for vca = -5:1:5
                        for vcb = -5:1:5
                            v_c= [vca, vcb];
                            simresults = sim('Conventional_FSMPC_algorithm_tommy','SimulationMode','normal','AbsTol','1e-5',...
                                             'StopTime', num2str(Ts));
                            index = index+1;
                            results(index,:) = [x_old,t,Rload,ifa,ifb,vca,vcb,simresults.x_opt.Data(1),simresults.vrefab.Data(1,1),simresults.vrefab.Data(1,2)];
                        end
                    end
                end
            end
        end
    end
end

%%
Ts=0.00005;
x_old = 1;
t = 0;
Rload = 30;
i_f = [-16,16];
v_c = [-5,-5];
simresults = sim('Conventional_FSMPC_algorithm_tommy','SimulationMode','normal','AbsTol','1e-5',...
                        'StopTime', num2str(Ts));
                    
simresults.x_opt.Data(1)
simresults.vrefab.Data(1,1)+1j*simresults.vrefab.Data(1,2)