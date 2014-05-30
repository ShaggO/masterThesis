function D = inriaDescriptors(images,mFunc)

load('paths')

D = [];
for i = 1:numel(images)
    disp(['Image ' num2str(i) '/' num2str(numel(images))]);
    I = im2single(images(i).image);
    [~,Di] = mFunc(I,inriaResults,num2str(i),false);
    D = [D; Di];
end

end