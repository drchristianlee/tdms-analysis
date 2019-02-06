clear
clc
close all
[path] = uigetdir;
cd(path);
load('decision_log_v4.mat')

LED_On = (str2num(cell2mat(inputdlg('LED on trial, set to 0 if no LED')))); %set this value to zero if there are no LED on trials.
%otherwise set this value to the first trial where there was stimulation.
LED_Off = size(decision_log, 1) - 1; %set this value to the last trial where LED stimulation was present.

ind = 1;
ind_on = 1;

if LED_On == 0;
    
    total_trials = (str2double(decision_log{end, 1})) - (sum(str2num(cell2mat(decision_log(2:end, 12))))); %removes auto rewards
    perc_Gos = (size(Gos, 2)/total_trials)*100;
    perc_nogo = (size(NoGos, 2)/total_trials)*100;
    perc_miss = (size(Misses, 2)/total_trials)*100;
    perc_FAs = (size(FAs, 2)/total_trials)*100;
    combined_rt = [FAtimes GoTimes];
    mean_rt = mean(combined_rt);
    mean_gort = mean(GoTimes);
    mean_fart = mean(FAtimes);
    
else
led_off_go_time = [];
led_off_fa_time = [];
for i = 2:LED_On;
    if decision_log{i,7} == '1'
        LED_off_respTimes(ind) = str2double(decision_log{i,6});
        off_go_res = str2double(decision_log{i, 6});
        led_off_go_time = [led_off_go_time off_go_res];
        ind = ind + 1;
    elseif decision_log{i, 10} == '1'
        LED_off_respTimes(ind) = str2double(decision_log{i, 11});
        ind = ind + 1;
        off_fa_res = str2double(decision_log{i, 11});
        led_off_fa_time = [led_off_fa_time off_fa_res];
    end
end

mean_led_off_gort = mean(led_off_go_time);
mean_led_off_fart = mean(led_off_fa_time);
%Avg_LedOff = mean(LED_off_respTimes)

led_on_go_time = [];
led_on_fa_time = [];
for j = LED_On + 1:LED_Off + 1;
    if decision_log{j,7} == '1'
        LED_on_respTimes(ind_on) = str2double(decision_log{j,6});
        on_go_res = str2double(decision_log{j, 6});
        led_on_go_time = [led_on_go_time on_go_res];
        ind_on = ind_on + 1;
    elseif decision_log{j, 10} == '1'
        LED_on_respTimes(ind_on) = str2double(decision_log{j, 11});
        on_fa_res = str2double(decision_log{j, 11});
        led_on_fa_time = [led_on_fa_time on_fa_res];
        ind_on = ind_on + 1;
    end
end

mean_led_on_gort = mean(led_on_go_time);
mean_led_on_fart = mean(led_on_fa_time);
%Avg_LedOn = mean(LED_on_respTimes)

LED_Off_Gos = (sum(str2num(cell2mat(decision_log(2:LED_On, 7)))));
LED_Off_NoGos = (sum(str2num(cell2mat(decision_log(2:LED_On, 8)))));
LED_Off_Miss = (sum(str2num(cell2mat(decision_log(2:LED_On, 9)))));
LED_Off_FAs = (sum(str2num(cell2mat(decision_log(2:LED_On, 10)))));
LED_Off_Auto = (sum(str2num(cell2mat(decision_log(2:LED_On, 12)))));
off_trials = LED_Off_Gos + LED_Off_NoGos + LED_Off_Miss + LED_Off_FAs; %does not include autorewards

nLED_Go_proportion = ((LED_Off_Gos)/off_trials) * 100;
nLED_NoGo_proportion = ((LED_Off_NoGos)/off_trials) * 100;
nLED_Miss_proportion = ((LED_Off_Miss)/off_trials) * 100;
nLED_FA_proportion = ((LED_Off_FAs)/off_trials) * 100;

LED_ON_Gos = (sum(str2num(cell2mat(decision_log(LED_On + 1:LED_Off + 1, 7)))));
LED_ON_NoGos = (sum(str2num(cell2mat(decision_log(LED_On + 1:LED_Off + 1, 8)))));
LED_ON_Miss = (sum(str2num(cell2mat(decision_log(LED_On + 1:LED_Off + 1, 9)))));
LED_ON_FAs = (sum(str2num(cell2mat(decision_log(LED_On + 1:LED_Off + 1, 10)))));
LED_ON_Auto = (sum(str2num(cell2mat(decision_log(LED_On + 1:LED_Off + 1, 12)))));
on_trials = LED_ON_Gos + LED_ON_NoGos + LED_ON_Miss + LED_ON_FAs; %does not include autorewards

LED_Go_proportion = ((LED_ON_Gos)/on_trials) * 100;
LED_NoGo_proportion = ((LED_ON_NoGos)/on_trials) * 100;
LED_Miss_proportion = ((LED_ON_Miss)/on_trials) * 100;
LED_FA_proportion = ((LED_ON_FAs)/on_trials) * 100;

end

if LED_On == 0;
    
    result(1, 1) = perc_Gos;
    result(2, 1) = perc_nogo;
    result(3, 1) = perc_miss; 
    result(4, 1) = perc_FAs;
    result(5, 1) = mean_gort;
    result(6, 1) = mean_fart; 
    openvar('result')
    save('result_v1.mat' , 'result')
    
else
    result(1, :) = [nLED_Go_proportion LED_Go_proportion];
    result(2, :) = [nLED_NoGo_proportion LED_NoGo_proportion];
    result(3, :) = [nLED_Miss_proportion LED_Miss_proportion];
    result(4, :) = [nLED_FA_proportion LED_FA_proportion];
    result(5, :) = [mean_led_off_gort mean_led_on_gort];
    result(6, :) = [mean_led_off_fart mean_led_on_fart];
    openvar('result')
    save('result_v1_led.mat' , 'result')
end