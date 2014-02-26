function [X,D] = getSiftFeatures(I,F,colour,debug)
% Assumes a grayscale image normalized in the [0,255] interval

disp(['Detected ' num2str(size(F,1)) ' features.'])
% assert(size(F,1) > 1000 && size(F,1) < 2000, ...
%     ['Error: ' num2str(size(F,1)) ' features detected but not within bounds (1000 - 2000).'])

switch colour
    case 'gray'
        [X,D] = vl_sift(single(rgb2gray(I)),'frames',F(:,1:4)');
        X = X(1:2,:)';
        D = D';
        %     case 'normal'
        %         J = single(rgb2gray(I));
        %         [X,D] = vl_sift(J,'edgethresh',1.5);
        %         X = X(1:2,:)';
        %         D = D';
    otherwise
        R = single(I(:,:,1));
        G = single(I(:,:,2));
        B = single(I(:,:,3));
        switch colour
            case 'rgb bin'
                [X,DR] = vl_sift(R,'frames',F(:,1:4)');
                [~,DG] = vl_sift(G,'frames',F(:,1:4)');
                [~,DB] = vl_sift(B,'frames',F(:,1:4)');
                X = X(1:2,:)';
                D = (DR' + DG' + DB') / 3;
            case 'rgb'
                [X,DR] = vl_sift(R,'frames',F(:,1:4)');
                [~,DG] = vl_sift(G,'frames',F(:,1:4)');
                [~,DB] = vl_sift(B,'frames',F(:,1:4)');
                X = X(1:2,:)';
                D = [DR' DG' DB'];
            case 'opponent'
                [X,D1] = vl_sift((R-G)/sqrt(2),'frames',F(:,1:4)');
                [~,D2] = vl_sift((R+G-2*B)/sqrt(6),'frames',F(:,1:4)');
                [~,D3] = vl_sift((R+G+B)/sqrt(3),'frames',F(:,1:4)');
                X = X(1:2,:)';
                D = [D1' D2' D3'];
            case 'gaussian opponent'
                [E0,E1,E2] = gaussianOpponent(R,G,B);
                [X,D1] = vl_sift(E0,'frames',F(:,1:4)');
                [~,D2] = vl_sift(E1,'frames',F(:,1:4)');
                [~,D3] = vl_sift(E2,'frames',F(:,1:4)');
                X = X(1:2,:)';
                D = [D1' D2' D3'];
        end
end
% figure
% imshow(I)
% hold on
% vl_plotsiftdescriptor(D,F);
end

function [E0, E1, E2] = gaussianOpponent(R, G, B)
E0 = 0.06 * R + 0.63 * G + 0.27 * B;
E1 = 0.30 * R + 0.04 * G - 0.35 * B;
E2 = 0.34 * R - 0.60 * G + 0.17 * B;
end