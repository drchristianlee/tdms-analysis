clc 
clear

[newfolder] = uigetdir;
cd(newfolder)
filePattern1 = fullfile(newfolder);

matfiles = dir(filePattern1);

item1=[];
count = length(matfiles);
num_mice=count-2;
grandZ2= [];
grandZ3=[];
 for num = 3:count
     item = matfiles(num).name;
     load(item, '-mat');
     item1=[item];
     grandZ2 = [grandZ2; per_mouse_avg_below_baseline];
     grandZ3 = [grandZ3; per_mouse_avg_above_baseline];
 end
 
 %temporal conversion below baseline 
 ngrandZ2=[];
 for j = 1:num_mice
     line=[];
     for i = 1:length(grandZ2)
     conv= grandZ2(j,i)/0.1;
     line=[line,conv];
     end
     ngrandZ2=[ngrandZ2;line];
 end
 %temporal conversion above baseline 
 ngrandZ3=[];
 for j = 1:num_mice
     line=[];
     for i = 1:length(grandZ3)
     conv= grandZ3(j,i)/0.1;
     line=[line,conv];
     end
     ngrandZ3=[ngrandZ3;line];
 end
     
 
 std_first_averages_below=[std(ngrandZ2)];
 std_first_averages_above=[std(ngrandZ3)];
 sqrt_N= sqrt(num_mice);
 %computes standard deviation of mean for below baseline
 err_of_mean_below=[];
 for i = 1:length(std_first_averages_below)
     err_of_mean=std_first_averages_below(i)/sqrt_N;
     err_of_mean_below=[err_of_mean_below, err_of_mean];
 end
 
 %computes standard error of mean above baseline 
 err_of_mean_above=[];
 for i = 1:length(std_first_averages_above)
     err_of_mean=std_first_averages_above(i)/sqrt_N;
     err_of_mean_above=[err_of_mean_above, err_of_mean];
 end
     
     
 
 
 
 mean_below= [mean(ngrandZ2,1)];
 mean_above= [mean(ngrandZ3,1)];
 
 
 plot_below = mean_below/num_mice;
%  part2 = part1/0.1;
 
 plot_above=mean_above/num_mice;
%  part1b=part1a/0.1;

% errorbar(plot_below,err_of_mean_below)
 
 
 
 
 
 
 
 
 
 
 
 
 