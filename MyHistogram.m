function [counts, grayLevels] = MyHistogram(ImageRef)
[rows, columns] = size(ImageRef);
counts = zeros(1,4096);
for col = 1 : columns
	for row = 1 : rows
		% Get the gray level.
		grayLevel = ImageRef(row, col);
        grayLevel=round(grayLevel);
		% Add 1 because graylevel zero goes into index 1 and so on.
		counts(grayLevel+ 1) = counts(grayLevel+1) + 1;
	end
end
% Plot the histogram.
grayLevels = 0 : 4095;
bar(grayLevels, counts, 'BarWidth', 1, 'FaceColor', 'b');
xlabel('Gray Level', 'FontSize', 20);
ylabel('Pixel Count', 'FontSize', 20);
title('Histogram', 'FontSize', 20);
xlim([1000 4100]);
ylim([0 200]);
grid on;
end

