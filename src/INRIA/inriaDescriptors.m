function D = inriaDescriptors(images,mFunc)

load('paths')

for i = 1:numel(images)
    disp(['Image ' num2str(i) '/' num2str(numel(images))]);
    I = im2single(images(i).image);
    profile on
    [~,Di] = mFunc(I,inriaResults,num2str(i),false);
    profile off
    if i == 1
        D = zeros(numel(images),numel(Di));
    end
    D(i,:) = reshape(Di',1,[]);
    return
end

end

