function method = modifyDescriptor(method,varargin)

assert(numel(varargin) >= 2,'No properties to change');
assert(mod(numel(varargin),2) == 0, 'One value for each property must be specified');

parameters = varargin(1:2:end);
values = varargin(2:2:end);

desArgsStruct = struct(method.descriptorArgs{:});

for i = 1:numel(parameters)
    desArgsStruct.(parameters{i}) = values{i};
end

desArgs = {};
for i = fieldnames(desArgsStruct)'
    desArgs = [desArgs i {desArgsStruct.(i{:})}];
end
method.descriptorArgs = desArgs;

end
