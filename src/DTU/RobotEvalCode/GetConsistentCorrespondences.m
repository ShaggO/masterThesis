function [idx,IsEst]=GetConsistentCorrespondences(Grid3D,Pts,Rad3D,StrLBoxPad,BackProjThresh,Cams,ScaleMargin,KeyP,KeyScale,Points)

p1=KeyP;
[Mean,Var,IsEst]=Get3DGridEst(Grid3D,Pts,Rad3D,p1(1),p1(2));
if(IsEst)
    Var=Var+StrLBoxPad;
    Q=Mean*ones(1,8)+[Var(1)*[-1 1 -1 1 -1 1 -1 1];Var(2)*[-1 -1 1 1 -1 -1 1 1];Var(3)*[-1 -1 -1 -1 1 1 1 1]];
    q=Cams(:,:,2)*[Q;ones(1,8)];
    depth=mean(q(3,:));
    q(1,:)=q(1,:)./q(3,:);
    q(2,:)=q(2,:)./q(3,:);
    q(3,:)=q(3,:)./q(3,:);
    
    kq=Cams(:,:,1)*[Q;ones(1,8)];
    kDepth=mean(kq(3,:));
    Scale=KeyScale*kDepth/depth;
    
    %Find points within bound and with in scale bounds
    idx=find(Points(:,1)>min(q(1,:)) & Points(:,1)<max(q(1,:)) & ...
        Points(:,2)>min(q(2,:)) & Points(:,2)<max(q(2,:)) & ...
        Points(:,3)>Scale/ScaleMargin & Points(:,3)<Scale*ScaleMargin );
    
    if(~isempty(idx))
        idx2=[];
        for i=1:length(idx),
            if(IsPointCamGeoConsistent([p1 1]',[Points(idx(i),1:2) 1]',Cams,BackProjThresh))
                idx2=[idx2 idx(i)];
            end
        end
        idx=idx2;
    end
else
    idx=[];
end

