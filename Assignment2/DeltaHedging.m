function [replicatingPort,riskFree] = DeltaHedging(stockPrices,blackScholesPrices,deltas,r,h,transCost)
    valcount = length(stockPrices);
    replicatingPort = zeros(valcount,1);
    riskFree = zeros(valcount,1);
    
    replicatingPort(1) = blackScholesPrices(1);
    riskFree(1) = replicatingPort(1) - deltas(1)*stockPrices(1);
    
    for count = 2:length(riskFree)
        replicatingPort(count) = deltas(count-1)*stockPrices(count) + riskFree(count-1)*exp(r*h);
        riskFree(count) = replicatingPort(count) - (deltas(count)*stockPrices(count))- transCost*stockPrices(count)*abs(deltas(count)-deltas(count-1));
    end
end

