function [ peaks_and_vallies_above_and_below_noise,Lick_log ] = peaks_in_lick_data( lick_data )
b=lick_data;
[m,n]=size(lick_data);
peaks_and_vallies_above_and_below_noise=[];
z=peaks_and_vallies_above_and_below_noise;
Lick_log=[];
for i=1:m 
    Times_per_trial=[];
    for j=1:n
        if b(i,j)>2.61   %slightly above the noise reading... meant to weed out background noise when finding the peaks and other stuff.
            time=j.*0.01-3.15422;
            Times_per_trial=[Times_per_trial;time];
            z=[z;i,time,lick_data(i,j)]; %1 indicates peak
        elseif b(i,j)<2.5
            time=j.*0.01-3.15422; 
            Times_per_trial=[Times_per_trial;time];
            z=[z;i,time,lick_data(i,j)]; %0 indicates vally
            
        end
    end
        if j>=2
            for k=2:2:j
                if Times_per_trial(k)-Times_per_trial(k-1)<=12000%120
                    z=vertcat(z,1);%[z;1];1 if <=120 miliseconds
                else
                    z=vertcat(z,0);%[z;0];0 if not^
                end
            end
        end
        [g,v]=size(z);
        for l=1:g
            for e=length(transpose(v)):length(transpose(v))
                if z(l,e)==1 && z(l-1,e)==0
                    Lick_log=[Lick_log;l,z(l,2)];
                end
            end
        end
    end
end


            
        
        
        
    




