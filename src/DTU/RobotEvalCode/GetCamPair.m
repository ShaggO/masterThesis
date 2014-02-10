% Compute the pair of projective camera matrices from the KeyFrame and the
% 'other' frame, cIm, associated with our robot data set. The camera
% matrices are defined in the file  Calib_Results_11, which is the output
% from the camera calibration toolbox for MatLab, cf. 
% http://www.vision.caltech.edu/bouguetj/calib_doc/
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
%function Cams=GetCamPair(KeyFrame,cIm)

function Cams=GetCamPair(KeyFrame,cIm)

KeyCam=GetCam(KeyFrame);
Cam=GetCam(cIm);
Cams=zeros(3,4,2);
Cams(:,:,1)=KeyCam;
Cams(:,:,2)=Cam;
