function D = inriaDescriptors(images,mFunc)

load('paths')

for i = 1:numel(images)
    disp(['Image ' num2str(i) '/' num2str(numel(images))]);
    I = im2single(images(i).image);
    [~,Di] = mFunc(I,inriaResults,num2str(i),false);
    if i == 1
        D = zeros(numel(images),numel(Di));
    end
    D(i,:) = reshape(Di',1,[]);
end

end

