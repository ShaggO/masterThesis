clear all; close all;

load paths

dataTrain = load([inriaDataSet '/inriaNegTrainFull']);
dataTest = load([inriaDataSet '/inriaNegTestFull']);
images = [dataTrain.images;dataTest.images];
duplicates = zeros(0,2);
for i = 1:numel(images)
    disp(['Image: ' num2str(i) '/' num2str(numel(images))]);
    for j = 1:i-1
        I1 = images(i).image;
        I2 = images(j).image;
        if all(size(I1) == size(I2)) && sum(I1(:) ~= I2(:)) < 200
            disp(['Duplicates!' num2str(i) ' and ' num2str(j)]);
            duplicates(end+1,:) = [i,j];
        end
    end
end
disp(['Number of duplicates: ' num2str(size(duplicates,1))]);
