% Create a variable named test_keeper and copy/paste values to compare into
% it. Then run this script.



test_keeper(test_keeper == 0) = NaN;


barkeeper(1,1) = nanmean(test_keeper(:,1));
barkeeper(1,2) = nanmean(test_keeper(:, 2));
nanfinder = isnan(test_keeper);
nanvals = sum(nanfinder, 1);
denominator1 = sqrt((size(test_keeper(:, 1), 1)) - nanvals(1, 1));
denominator2 = sqrt((size(test_keeper(:, 2), 1)) - nanvals(1, 2));
barkeeper(2,1) = nanstd(test_keeper(:,1))/denominator1;
barkeeper(2,2) = nanstd(test_keeper(:,2))/denominator2;

figure
bar(barkeeper(1,:), 'b');
hold on;
errorbar(barkeeper(1,:), barkeeper(2,:), '.', 'color', 'k', 'marker', 'none');
hold on;

for points = 1:size(test_keeper, 1);
    plot(test_keeper(points, 1:2) , '-o', 'color' , 'green', 'MarkerFaceColor', 'green')
    hold on
end

 axis([0 3 0 15])
 set(gca,'TickDir','out')
 set(gca, 'box', 'off')
 set(gcf,'position',[680 558 160 210])
 set(gca, 'TickLength', [0.025 0.025]);
 set(gca,'FontSize',9);
 
 [h p ci stats] = ttest(test_keeper(:, 1), test_keeper(:, 2))