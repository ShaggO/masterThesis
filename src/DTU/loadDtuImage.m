function I = loadDtuImage(setNum,imNum,liNum)
%LOADDTUIMAGE Load a DTU image and convert it to single precision. Also
%scales diffuse images to make them brighter.

I = loadDtuImage(setNum,imNum,liNum));
I = im2single(I);
if liNum == 0
    I = 1.2*I;
end

end

