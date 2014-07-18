clc, clear

files = {'inriaParametersGo','inriaParametersGo10','inriaParametersGoBeforeLayoutFix','inriaParametersGoChosenBig','inriaParametersGoChosenSmall','inriaParametersGoSi','inriaParametersGoTriangle','inriaParametersSi','inriaParametersSi10','inriaParametersSiBeforeLayoutFix','inriaParametersSiTriangle'};

for i = 1:numel(files)
    path = ['results/optimize/' files{i}];
    params = load(path);
    if iscell(params.method.descriptor)
        for j = 1:numel(params.method.descriptorArgs)
            assert(~ismember('smooth',params.method.descriptorArgs{j}(1:2:end)),'smooth already exists!')
            params.method.descriptorArgs{j} = [params.method.descriptorArgs{j} {'smooth' false}];
        end
    else
        assert(~ismember('smooth',params.method.descriptorArgs(1:2:end)),'smooth already exists!')
        params.method.descriptorArgs = [params.method.descriptorArgs {'smooth' false}];
    end
    save(path,'-struct','params')
end