function s = nums2str(a)

s = num2str(a(1));
for i = 2:numel(a)
    s = [s ',' num2str(a(i))];
end

end

