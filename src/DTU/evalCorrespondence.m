function match = evalCorrespondence(match)

KeyFrame=25;            %The Key Frame, in all our experiments this is the one used. 
In3DPath='CleanRecon_2009_11_16/';  %(relative) path of the structured light scans.
Rad3D=10;               %Size of search cells in the structured light grid.
StrLBoxPad=3e-3;        %=3mm
BackProjThresh=5;       %pixels

ScaleMargin=2;              %Margin for change in scale, corrected for distance to the secen, in orer for a correspondance to be accepted. A value of 2 corresponds to an octave.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actual Evaluation Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Precomputes the quad tree of projected structured light points, for
% faster computaion later. Loads from file if available.
strLightDir = 'DTU/results/structuredLight';
strLightPath = sprintf('%s/set%.2d.mat',strLightDir,match.setNum)
if ~exist(strLightDir,'dir')
    mkdir(strLightDir)
end
if exist(strLightPath,'file')
    load(strLightPath)
else
    [Grid3D,Pts]=GenStrLightGrid_v2(KeyFrame,In3DPath,1200,1600,Rad3D,match.setNum);
    save(strLightPath,'Grid3D','Pts')
end

%Get the projective camera matrices.
Cams=GetCamPair(KeyFrame,match.imNum);
match.CorrectMatch = zeros(size(match.coord,1),1);
for i=1:size(match.coord,1)
    %Get the coordinates of the matched pair from the match structure.
    p2=match.coord(i,:);
    p1=match.coordKey(match.matchIdx(i,1),:);

    %Determine if the match is consistent.
    [CorrectMatch,IsEst]=IsMatchConsistent(Grid3D,Pts,Rad3D,StrLBoxPad,BackProjThresh,Cams,p1,p2);
    match.CorrectMatch(i)=CorrectMatch;
end

[match.ROC, match.PR] = analyseMatches(match);
match.ROCAUC = ROCarea(match.ROC');
match.PRAUC = 1 - ROCarea(flip(match.PR,2)');

end
