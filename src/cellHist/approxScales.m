function scales = approxScales(sigmaF,base)
%APPROXSCALES Approximate detected scales / clamp to scales defined by the scale base

minLogScale = log(min(sigmaF))/log(base);
maxLogScale = log(max(sigmaF))/log(base);

scales = base .^ (max(round(minLogScale),0) : round(maxLogScale));

end
