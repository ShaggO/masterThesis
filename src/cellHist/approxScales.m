function scales = approxScales(sigmaF,base,offset)
%APPROXSCALES Approximate detected scales / clamp to scales defined by the scale base

minLogScale = log(min(sigmaF(:)))/log(base);
maxLogScale = log(max(sigmaF(:)))/log(base);

minLogScaleR = offset + max(round(minLogScale - offset - 10^-6),-1);
maxLogScaleR = offset + max(round(maxLogScale - offset + 10^-6),-1);

scales = base .^ (minLogScaleR : maxLogScaleR);

end