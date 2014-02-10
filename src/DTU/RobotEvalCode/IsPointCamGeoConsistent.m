%Computes if a matching pair of features, p1 and p2, is consistent with the
%camera geometry of the two respective cameras, Cams, of our robot dataset. 
%In principle the is the same as determining if it is consistent with the
%associated epipolar geometry. To avoid numerical issues with too
%small baselines, this is computed by estimating the corresponding 3D point
%and evaluating that the back projection error. The threshold is defined by 
%BackProjThresh 
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
%function IsOk=IsPointCamGeoConsistent(p1,p2,Cams,BackProjThresh)
function IsOk=IsPointCamGeoConsistent(p1,p2,Cams,BackProjThresh)

ps=[p1 p2];
Q=Est3DPoint(Cams, ps);
q1=Cams(:,:,1)*Q;    q1=q1/q1(3);
q2=Cams(:,:,2)*Q;       q2=q2/q2(3);
diff=norm(p1-q1)+norm(p2-q2);
IsOk=(diff<BackProjThresh);