%Assignment 1
%Nitish Ramkumar, Stephan Du Toit, Yvonne Tong Yi, Baihan Chen

%% 1a 
clear
clc
global S0 r sigma T K
S0=100;   %Initial stock price
K=90; %Strike price
r=0.02; %risk-free rate
h=0.25; %length of the period in years
T=4; %# of periods
u=exp((r*h)+0.2*sqrt(h));   %up move 
d=exp((r*h)-0.2*sqrt(h)); %down move 

% Straddle is long call and long put on the same strike.
% The sum of the two values should lead to value of straddle

[~,optionprice1,hedgeportfoliostock1,hedgeportfolioriskfree1]=...
    EuropeanPricing(S0,@CallPayoff,r,h,u,d,T,0,[]);
[~,optionprice2,hedgeportfoliostock2,hedgeportfolioriskfree2]=...
    EuropeanPricing(S0,@PutPayoff,r,h,u,d,T,0,[]);

straddlePrice = optionprice1{T+1,1} + optionprice2{T+1,1};
straddlePrice

%% 1b
S0=100;
K=90;
T = 40;
r=0.02;
h = 0.025;
u=exp((r*h)+0.2*sqrt(h));
d=exp((r*h)-0.2*sqrt(h));

[~,optionprice1,hedgeportfoliostock1,hedgeportfolioriskfree1]=...
    EuropeanPricing(S0,@CallPayoff,r,h,u,d,T,0,[]);
[stockprice2,optionprice2,hedgeportfoliostock2,hedgeportfolioriskfree2]=...
    EuropeanPricing(S0,@PutPayoff,r,h,u,d,T,0,[]);

straddlePrice = optionprice1{T+1,1} + optionprice2{T+1,1}

%% 1c
%Binary Payoff - If above K, option returns is K. If less than K, option
%returns 0s
S0=100;   %Initial stock price
K=90; %Strike price
r=0.02; %risk-free rate
h=0.25; %length of the period in years
T=4; %# of periods
u=exp((r*h)+0.2*sqrt(h));   %up move 
d=exp((r*h)-0.2*sqrt(h)); %down move 

[stockprice1,optionprice1,hedgeportfoliostock1,hedgeportfolioriskfree1]=...
    EuropeanPricing(S0,@BinaryPayoff,r,h,u,d,T,0,[]);

binaryCallPrice = optionprice1{T+1,1}


%% 2a
% American Option

K=10;
r = 0.01;
h = 1/365;
S0 = 10;
T=250; 
u=exp((r*h)+0.15*sqrt(h));
d=exp((r*h)-0.15*sqrt(h));

[~,optionprice,hedgeportfoliostock,hedgeportfolioriskfree,exerciseDate]=...
    AmericanPricing(S0,@CallPayoff,r,h,u,d,T,0,[]);
optionprice{T+1,1}

[~,optionprice1,hedgeportfoliostock1,hedgeportfolioriskfree1,exerciseDate1]=...
    AmericanPricing(S0,@PutPayoff,r,h,u,d,T,0,[]);
optionprice1{T+1,1}

%% 3a
% Discrete Dividends Option

S0=10;   %Initial stock price
K=10; %Strike price
r=0.02; %risk-free rate
h=1/365; %length of the period in years
T=200; %# of periods
u=exp(0.2*sqrt(h));   %up move 
d=exp(-0.2*sqrt(h)); %down move 
delta = 0.05;
DivDate = [50,100,150];

[stockprice,optionprice,hedgeportfoliostock,hedgeportfolioriskfree,exerciseDate]=...
    DiscreteDividendsPricing(S0,@PutPayoff,'American',r,h,u,d,DivDate,delta,T);
optionprice{T+1,1}
[stockprice1,optionprice1,hedgeportfoliostock1,hedgeportfolioriskfree1,exerciseDate1]=...
    DiscreteDividendsPricing(S0,@CallPayoff,'American',r,h,u,d,DivDate,delta,T);
optionprice1{T+1,1}
stockprice1{1,T+1}

%% 3b

S0=10;   %Initial stock price
K=10; %Strike price
r=0.02; %risk-free rate
h=1/365; %length of the period in years
T=200; %# of periods
u=exp(0.2*sqrt(h));   %up move 
d=exp(-0.2*sqrt(h)); %down move 
delta = 0.05;
DivDate = [50,100,150];

[stockprice1,optionprice,hedgeportfoliostock,hedgeportfolioriskfree,exerciseDate]=...
    DiscreteDividendsPricing(S0,@StraddlePayoff,'American',r,h,u,d,DivDate,delta,T);
optionprice{T+1,1}
%% 4
% Asian Options

S0=200;   %Initial stock price
K=220; %Strike price
r=0.02; %risk-free rate
sigma = 0.2; %standard deviation
h=1/365; %length of the period in years
T=1; %# of periods
NoOfPaths = 100000;

randn('seed',0);
pathPayoffs = zeros(NoOfPaths,1);

for path = 1:NoOfPaths
    %stockPrices = GenerateStockPath(S0,u,d,r,T,h);
    stockPrices = GenerateStockPath(S0,r,T,h,sigma);
    pathPayoffs(path) = max(mean(stockPrices)-K,0);
end
montecarloprice = mean(pathPayoffs) * exp(-r * T)


pd = fitdist(pathPayoffs * exp(-r * T),'Normal');
paramci(pd)

%% 5a
% American Option LMC

S0=200;   %Initial stock price
K=220; %Strike price
r=0.1; %risk-free rate
sigma = 0.3; %standard deviation
N=250; %length of the period in years
T=1; %# of periods
NoOfPaths = 100000;

randn('seed',0);
price = LSLeastSquares(N,NoOfPaths)

%% 5b

S0=200;   %Initial stock price
K=220; %Strike price
r=0.1; %risk-free rate
sigma = 0.3; %standard deviation
N=250; %length of the period in years
T=1; %# of periods

NoOfPaths = [10 100 1000 10000 100000];
priceResult = zeros(5,2);
priceResult(:,1) = NoOfPaths;
for pathCount = 1:length(priceResult)
    priceResult(pathCount,2) = LSLeastSquares(N,priceResult(pathCount,1));
end
bar(priceResult(:,2))
set(gca,'xticklabel',NoOfPaths)

%% 5c
%% 5b

S0=200;   %Initial stock price
K=220; %Strike price
r=0.1; %risk-free rate
sigma = 0.3; %standard deviation
NoOfPaths=100000; %length of the period in years
T=1; %# of periods

N = [3 10 100 250 1000];
priceResult = zeros(5,2);
priceResult(:,1) = N;
for pathCount = 1:length(priceResult)
    priceResult(pathCount,2) = LSLeastSquares(priceResult(pathCount,1),NoOfPaths);
end
bar(priceResult(:,2))
set(gca,'xticklabel',N)