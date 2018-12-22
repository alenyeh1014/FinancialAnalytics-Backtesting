* Basic Statistical Analysis for each dataset;

%macro analysis (dsn= &dsn.);
proc univariate data = &dsn.;
	var close;
run;
	
%mend analysis;

%analysis (dsn = AAPL);
%analysis (dsn = GE);
%analysis (dsn = MS);
%analysis (dsn = SP500);


/* create example data: AAPL stock price */

%macro timeseries (dsnn = &dsnn.);
title "10Y &dsnn Close Price";
proc sgplot data =&dsnn.;
	series x = Date y = close ;
	xaxis label = 'Date'
	min = '01JAN2010'd max = '01DEC2018'd;
	run;
%mend timeseries;

%timeseries (dsnn=AAPL);
%timeseries (dsnn=GE);
%timeseries (dsnn=MS);
%timeseries (dsnn=SP500);


 /* create three moving average curves */
proc expand data=AAPL out=WORK.SMA_AAPL method=none;
id DATE;  convert CLOSE = SMA_short   / transout=(movave 50); convert CLOSE = SMA_long   / transout=(movave 200);
run;



PROC SQL;
CREATE TABLE test as 
SELECT date, close FROM SMA_AAPL;
QUIT;



PROC SQL;
CREATE TABLE test_a as 
SELECT date, close, SMA_short FROM SMA_AAPL
WHERE date >"16MAR2010"d;
QUIT;



PROC SQL;
CREATE TABLE test_b as 
SELECT date, close, SMA_long FROM SMA_AAPL
WHERE date >"18OCT2010"d;
QUIT;



PROC SQL;
CREATE TABLE sma_plot AS
SELECT a.*, b.SMA_short FROM test a 
LEFT JOIN test_a b on a.date = b.date 
ORDER BY date;
QUIT;



PROC SQL;
CREATE TABLE sma_plotb AS
SELECT a.*, b.SMA_long FROM sma_plot a 
LEFT JOIN test_b b on a.date = b.date 
ORDER BY date;
QUIT;



Title "SMA_short v.s. SMA_long Closing Price";
proc sgplot data=Sma_plotb cycleattrs;
   series x=Date  y= Close / name ='Closing_Price'  legendlabel = 'Closing_Price';
   series x=Date  y=SMA_short  / name='SMA_short'   legendlabel="SMA_short(50)";
   series x=Date  y=SMA_long   / name='SMA_long'  legendlabel="SMA_long(200)";
   xaxis display=(nolabel) grid;
   yaxis label="Closing Price" grid;
 run;



DATA SMA_AAPLb;
       SET SMA_AAPL;
	   L1_short=lag1(SMA_short);
	   L1_long=lag1(SMA_long);
	   if date>="18OCT2010"d;
RUN;



PROC SQL;
CREATE TABLE buy_signal_AAPL AS
SELECT date, close, "buy" AS signal FROM SMA_AAPLb
WHERE L1_short<L1_long AND SMA_short>=SMA_long;
QUIT;



PROC SQL;
CREATE TABLE sell_signal_AAPL AS
SELECT date, close, "sell" AS signal FROM SMA_AAPLb
WHERE L1_short>L1_long AND SMA_short<=SMA_long;
QUIT;



PROC SQL;
CREATE TABLE signal_AAPL AS
SELECT * FROM buy_signal_AAPL
UNION
SELECT * FROM sell_signal_AAPL
ORDER BY date;
QUIT;

  

PROC SQL;
CREATE TABLE return_AAPLa AS
SELECT date, close, ((close-30.572857)/30.572857) AS return_SMA FROM SMA_AAPL
WHERE date<"07DEC2012"d;

CREATE TABLE return_AAPLb AS
SELECT date, close, ((76.178574-30.572857)/30.572857) AS return_SMA FROM SMA_AAPL
WHERE date>="07DEC2012"d AND date<"12SEP2013"d;

CREATE TABLE return_AAPLc AS
SELECT date, close, ((close-67.527145)/67.527145+(76.178574-30.572857)/30.572857) AS return_SMA FROM SMA_AAPL
WHERE date>="12SEP2013"d AND date<="26AUG2015"d;

CREATE TABLE return_AAPLd AS
SELECT date, close, ((109.690002-67.527145)/67.527145+(76.178574-30.572857)/30.572857) AS return_SMA FROM SMA_AAPL
WHERE date>"26AUG2015"d AND date<"02SEP2016"d;

CREATE TABLE return_AAPLe AS
SELECT date, close, ((close-107.730003)/107.730003+(109.690002-67.527145)/67.527145+(76.178574-30.572857)/30.572857) AS return_SMA FROM SMA_AAPL
WHERE date>="02SEP2016"d;

CREATE TABLE return_AAPLf AS
SELECT * FROM return_AAPLa
UNION
SELECT * FROM return_AAPLb
UNION
SELECT * FROM return_AAPLc
UNION
SELECT * FROM return_AAPLd
UNION
SELECT * FROM return_AAPLe
ORDER BY date;

CREATE TABLE return_AAPL AS
SELECT *, ((close-30.572857)/30.572857) AS return_hold FROM return_AAPLf;
QUIT;


Title1 "Return_SMA v.s. Return_hold of AAPL";
proc sgplot data=Return_AAPL cycleattrs;
   series x=Date y= return_SMA / name ='Return_SMA'  legendlabel = 'Return_SMA';
   series x=Date y = return_hold   / name='Return_hold'   legendlabel="Return_hold";
   xaxis display=(nolabel) grid;
   yaxis label="Return Price" grid;
 run;




