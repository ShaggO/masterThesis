This folder contains Matlab code for evaluating The DTU Robot Dataset, which is
publically available at:

http://roboimagedata.imm.dtu.dk/

You are welcome to use this code as you want, as long as we do not have to
assume any responsibility in that regard. If you use this data and or the 
code in relation to published work, however, cite (See note on the 
immoptibox below)

@article{Aanaes2011a,
  title={Interesting Interest Points},
  author={Aan{\ae}s, H. and Dahl, A.L. and Steenstrup Pedersen, K.},
  journal={International Journal of Computer Vision},
  pages={1--18},
  year={2011},
  publisher={Springer}
}

An example of using this code is found in RunMe.m. and RunMe_Recall.m. Some 
of the functions in this folder are provided by the courtesy of Hans 
Bruun Nielsen (DTU Informatics), from his Matlab Toolbox immoptibox, specifically
- checkfJ.m
- checkopts.m
- checkx.m
- geth.m
- marquardt.m
If any of these functions are this is used, please cite according to 
http://www2.imm.dtu.dk/~hbn/immoptibox/

The robot image data set contains images taken with known camera parameters
(internal and external), as well as a structured light scan of the object
being photographed. There are 60 scenes (sets) and 119 camera positions for
each set.

The way we evaluate features detectors and descriptor, is by using the above
mentioned data to determine if two points form a credible match or not.
Two (sometimes three) criteria are used:
1. Are the two positions consistent with the camera, i.e. epipolar geometry?
2. Are the two points consistent with the camera geometry and the
structured light scan?

3. Which is used for evaluating repeatability of
features, is if the scales of the two features are comparable? Here the
scales have been corrected for the different distance between surface and
camera. This test is not included in RunMe but in RunMe_Recall.

The data set is designed for two view comparison, where one of the views is
always image 25, denoted the KeyFrame. As mentioned above, two example files 
have been included:
RunMe.m 		Dealing with the evaluation of matches
RunMe_Recall.m  Dealing with computing the recall rate of features.

These examples are outlined in the following, where the description of 
RunMe_Recall.m builds on the description of RunMe.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% RunMe.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

The intended us of the code in RunMe.m for evaluating feature matches, is 
to evaluate the two first criteria mentioned above. This is done as follows:

a. The function GenStrLightGrid_v2 is called to set up a 2D quad tree of
the points of the structured light scan. This quad tree is wrt. the key
frame. The aim is to be able to retrieve the structured light points that
project to the vicinity of the feature point in the KeyFrame. This quad
tree and the 3D points is captured by the two returned data
structures/variables Grid3D and Pts. Note, that part of the argument to this 
function is the image size, i.e. 1200x1600. If the image is resized prior to 
feature extraction this should be changed.

b. The camera matrices for the KeyFrame and the view it is to be compared
to is computed via GetCamPair.

c. Given the pre-computed data structures in step a. and b. each matched
feature pair p1 and p2 are evaluated by IsMatchConsistent. This point pair
is in RunMe.m extracted from the match structure, which will be explained
below. IsMatchConsistent returns two variables,
 - CorrectMatch, denoting if the match is consistent (1) inconsistent(-1)
or not estimated (0) .
 - IsEst, which indicates if CorrectMatch is 0, i.e. if an evaluation has
taken place. CorrectMatch will not be estimated if no points of the
structured light scan projects to the vicinity of the feature point in the
KeyFrame.

d. The CorrectMatch is appended to the match structure. In RunMe.m match is
loaded from har_sift030.mat, and is our internal format for storing
matching results. See below for a description.

e. A combined score for the image/frame pair is computed via
CalcRocCurveFunc_v2. This is done on the match structure with the
CorrectMatch computation appended.

The ROC curves in stage e. are computed over the ratio between the score of
the best and the next best match. This ratio test is for determining a
match proposed by David Lowe. Thus in the match structure, there is a lot
of focus on the best and the next best matches and distances.

The match variable is a Matlab struct, which we use as our representation
of a matching result. It has the following variables/records:

matchIdx(i,1):
Index of the feature in KeyFrame that matches best to feature i in the
other frame.

matchIdx(i,2):
Index of the feature in KeyFrame that matches second best to feature i in the
other frame.

dist(i,1):
Distance (match score) between image feature i and its best match in the
KeyFrame. That is feature matchIdx(i,1) in the KeyFrame.

dist(i,2):
Distance (match score) between image feature i and its second best match in
the KeyFrame. That is feature matchIdx(i,1) in the KeyFrame.

distRatio:
distRatio=dist(:,1)./dist(.,2)

coord(i,:):
Image coordinate of feature i in the other frame.

coordKey(j,:) :
Image coordinate of feature j in the KeyFrame.

area(i,:) :
Three parameters in the elliptic approximation of the patch associated with 
feature I in the other frame. Given that a = area(i,1); b = area(i,2); 
c = area(i,3); u = coord(i,1); v = coord(i,2);
e ellipse fulfills: a*(u-x)^2 + b*(u-x)*(v-y) + c*(v-y)^2 = 1;

areaKey(j,:) :
Three parameters in the elliptic approximation of the patch associated with
feature I in the KeyFrame.

imNum:
The number of the other image/frame/view.

setNum:
The set number.

CorrectMatch: (Only after it is computed by RunMe or equivalent)
Indicates if this match is
    1: consistent,
    -1:Inconsistent
    0:Not estimateable

As an example from RunMe.m:

match =

     matchIdx: [3125x2 double]
         dist: [3125x2 double]
    distRatio: [3125x1 double]
        coord: [3125x2 double]
     coordKey: [3253x2 double]
         area: [3125x3 double]
      areaKey: [3253x3 double]
        imNum: 30
       setNum: 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% RunMe_Recall.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

The intended us of the code in RunMe_Recall.m for evaluating feature recall 
rate, is to evaluate all three criteria mentioned above. The two first steps 
in doing this are equal to the first two steps (a. and b.) in RunMe.m. These 
two steps set up the pre-computed data structures. Contrary to the input data 
in RunMe.m the input data is here given by two sets of points with computed 
area. The sets are denoted, KeyPoints (from the key frame) and Points(for 
the feature set/image to be compared to). This input data is loaded from 
RecallRateSample.mat. 

The structure of Points and KeyPoints are the same. They have a row per 
feature, where the two first values are the feature coordinate. The third 
value is the scale of the feature. If an ellipsoid for a patch is available, 
described by:
	[x y]*[A C;C B]*[x;y]=constant 	

The scale can be computed as (note only relative scale matters):
             1/sqrt(A*B-C*C);
             
Following the two first steps from RunMe.m, RunMe_Recall.m proceeds by

c. Computing the features in Points which are consistent with each of the 
features in Key Points, via a call to GetConsistentCorrespondences.m. This 
function returns two variables:
- idx	The indices, if any, of consistent features in Points
- IsEst	Indicates if an evaluation has taken place, which will not 	happen 
if the point KeyPoint(cP,1:2) does not project to the 	structured light scan.      

d. A histogram, nCorrHist, of the size of idx (for each feature cP) is made 
for the entire image. Here a non-empty idx indicates that a match is possible.

e. The recall rate is computed via:
	RecallRate=sum(nCorrHist(2:end))/sum(nCorrHist)

Where sum(nCorrHist) is the amount of features evaluated, 
and sum(nCorrHist(2:end)) is the amount of features evaluated to having at 
least one possible correspondence. The RecallRate is the evaluation metric 
reported for the image pair.

The reason a histogram is computed is to give an indication of whether the 
evaluation thresholds are OK. This is opposed to just recording if isempty(idx).


Authors:
Anders Dahl, abd@imm.dtu.dk
Henrik Aanaes, haa@imm.dtu.dk
DTU Informatics
Technical University of Denmark

December 2011
Updated Februar 2012.
