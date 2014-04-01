% Computes the camera projective camera matrix for frame nCam in our robot 
% data set. The camera matrices are defined in the file  Calib_Results_11, 
% which is the output from the camera calibration toolbox for MatLab, cf. 
% http://www.vision.caltech.edu/bouguetj/calib_doc/
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
%function [Cam,K,R,T]=GetCam(nCam)
function [Cam,K,R,T]=GetCam(nCam)


% Load paths for the data
load('paths');

load(dtuCalibrationFile);

%eval(sprintf('R=rodrigues(omc_%d);',nCam));    
eval(sprintf('R=Rc_%d;',nCam));
eval(sprintf('T=Tc_%d;',nCam));

K=[fc(1) 0 cc(1);0 fc(2) cc(2);0 0 1 ];


Cam=K*[R T];

