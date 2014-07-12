function match = evalCorrespondence(match)

% Load paths for the data
load('paths');

KeyFrame=25;            %The Key Frame, in all our experiments this is the one used.
In3DPath=[dtuDataReconstructions '/'];  %(relative) path of the structured light scans.
Rad3D=10;               %Size of search cells in the structured light grid.
StrLBoxPad=3e-3;        %=3mm
BackProjThresh=5;       %pixels

ScaleMargin=2;              %Margin for change in scale, corrected for distance to the secen, in orer for a correspondance to be accepted. A value of 2 corresponds to an octave.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actual Evaluation Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get the projective camera matrices.
Cams=GetCamPair(KeyFrame,match.imNum);
match.CorrectMatch = zeros(size(match.coord,1),1);
P2 = match.coord;
P1 = match.coordKey(match.matchIdx(:,1),:);

correctDir = [dtuResults '/correctMatches'];
correctPath = sprintf('%s/correct%.2d_%.3d-%.3d.mat',correctDir, ...
    match.setNum,KeyFrame,match.imNum);
[loaded,file] = loadIfExist(correctPath,'file');
if loaded && all(ismember({'pair','correct'},fieldnames(file)))
    try
        [cached,idx] = ismember([P1 P2],file.pair,'rows');
        match.CorrectMatch(cached) = file.correct(idx(cached));
        unknownIdx = find(~cached)';
    catch Exception
        save('debugCorrectMatch');
        assert(false);
    end
else
    unknownIdx = 1:size(match.coord,1);
end

if numel(unknownIdx) > 0
    % Precomputes the quad tree of projected structured light points, for
    % faster computaion later. Loads from file if available.
    strLightDir = [dtuResults '/structuredLight'];
    strLightPath = sprintf('%s/set%.2d.mat',strLightDir,match.setNum);
    if ~exist(strLightDir,'dir')
        mkdir(strLightDir)
    end
    
    [loaded,strL] = loadIfExist(strLightPath,'file');
    if loaded && all(ismember({'Grid3D','Pts'},fieldnames(strL)))
        Grid3D = strL.Grid3D;
        Pts = strL.Pts;
    else
        [Grid3D,Pts]=GenStrLightGrid_v2(KeyFrame,In3DPath,match.imSize(1),match.imSize(2),Rad3D,match.setNum);
        save(strLightPath,'Grid3D','Pts')
    end
end

% check unknown potential matches
for i = unknownIdx
    %Get the coordinates of the matched pair from the match structure.
    p2=P2(i,:);
    p1=P1(i,:);
    
    %Determine if the match is consistent.
    CorrectMatch=IsMatchConsistent(Grid3D,Pts,Rad3D,StrLBoxPad,BackProjThresh,Cams,p1,p2);
    match.CorrectMatch(i)=CorrectMatch;
end

if ~exist(correctDir,'dir')
    mkdir(correctDir)
end
pair = [P1 P2];
correct = match.CorrectMatch;
save(correctPath,'pair','correct')

[match.ROC, match.PR] = analyseMatches(match);
match.ROCAUC = ROCarea(match.ROC','roc');
match.PRAUC = ROCarea(match.PR','pr');

end
