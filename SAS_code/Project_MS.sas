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


/* create example data: MS stock price */

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
proc expand data=MS out=WORK.SMA_MS method=none;
id DATE;  convert CLOSE = SMA_short   / transout=(movave 50); convert CLOSE = SMA_long   / transout=(movave 200);
run;



PROC SQL;
CREATE TABLE test as 
SELECT date, close FROM SMA_MS;
QUIT;



PROC SQL;
CREATE TABLE test_a as 
SELECT date, close, SMA_short FROM SMA_MS
WHERE date >"16MAR2010"d;
QUIT;



PROC SQL;
CREATE TABLE test_b as 
SELECT date, close, SMA_long FROM SMA_MS
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



DATA SMA_MSb;
       SET SMA_MS;
	   L1_short=lag1(SMA_short);
	   L1_long=lag1(SMA_long);
	   if date>="18OCT2010"d;
RUN;



PROC SQL;
CREATE TABLE buy_signal_MS AS
SELECT date, close, "buy" AS signal FROM SMA_MSb
WHERE L1_short<L1_long AND SMA_short>=SMA_long;
QUIT;



PROC SQL;
CREATE TABLE sell_signal_MS AS
SELECT date, close, "sell" AS signal FROM SMA_MSb
WHERE L1_short>L1_long AND SMA_short<=SMA_long;
QUIT;



PROC SQL;
CREATE TABLE signal_MS AS
SELECT * FROM buy_signal_MS
UNION
SELECT * FROM sell_signal_MS
ORDER BY date;
QUIT;

  

PROC SQL;
CREATE TABLE return_MSa AS
SELECT date, close, 0 AS return_SMA FROM SMA_MS
WHERE date<"13JAN2011"d;

CREATE TABLE return_MSb AS
SELECT date, close, ((close-28.299999)/28.299999) AS return_SMA FROM SMA_MS
WHERE date>="13JAN2011"d AND date<="13MAY2011"d;

CREATE TABLE return_MSc AS
SELECT date, close, ((24.129999-28.299999)/28.299999) AS return_SMA FROM SMA_MS
WHERE date>"13MAY2011"d AND date<"08MAR2012"d;

CREATE TABLE return_MSd AS
SELECT date, close, ((close-18.18)/18.18+(24.129999-28.299999)/28.299999) AS return_SMA FROM SMA_MS
WHERE date>="08MAR2012"d AND date<="01JUN2012"d;

CREATE TABLE return_MSe AS
SELECT date, close, ((12.73-18.18)/18.18+(24.129999-28.299999)/28.299999) AS return_SMA FROM SMA_MS
WHERE date>"01JUN2012"d AND date<"22OCT2012"d;

CREATE TABLE return_MSf AS
SELECT date, close, ((close-17.450001)/17.450001+(12.73-18.18)/18.18+(24.129999-28.299999)/28.299999) AS return_SMA FROM SMA_MS
WHERE date>="22OCT2012"d AND date<="16SEP2015"d;

CREATE TABLE return_MSg AS
SELECT date, close, ((34.619999-17.450001)/17.450001+(12.73-18.18)/18.18+(24.129999-28.299999)/28.299999) AS return_SMA FROM SMA_MS
WHERE date>"16SEP2015"d AND date<"24AUG2016"d;

CREATE TABLE return_MSh AS
SELECT date, close, ((close-30.91)/30.91+(34.619999-17.450001)/17.450001+(12.73-18.18)/18.18+(24.129999-28.299999)/28.299999) AS return_SMA FROM SMA_MS
WHERE date>="24AUG2016"d AND date<="26JUN2018"d;

CREATE TABLE return_MSi AS
SELECT date, close, ((47.790001-30.91)/30.91+(34.619999-17.450001)/17.450001+(12.73-18.18)/18.18+(24.129999-28.299999)/28.299999) AS return_SMA FROM SMA_MS
WHERE date>"26JUN2018"d;

CREATE TABLE return_MSj AS
SELECT * FROM return_MSa
UNION
SELECT * FROM return_MSb
UNION
SELECT * FROM return_MSc
UNION
SELECT * FROM return_MSd
UNION
SELECT * FROM return_MSe
UNION
SELECT * FROM return_MSf
UNION
SELECT * FROM return_MSg
UNION
SELECT * FROM return_MSh
UNION
SELECT * FROM return_MSi
ORDER BY date;

CREATE TABLE return_MS AS
SELECT *, ((close-30.91)/30.91) AS return_hold FROM return_MSj;
QUIT;


Title1 "Return_SMA v.s. Return_hold of MS";
proc sgplot data=Return_MS cycleattrs;
   series x=Date y= return_SMA / name ='Return_SMA'  legendlabel = 'Return_SMA';
   series x=Date y = return_hold   / name='Return_hold'   legendlabel="Return_hold";
   xaxis display=(nolabel) grid;
   yaxis label="Return Price" grid;
 run;




