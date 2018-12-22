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


/* create example data: GE stock price */

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
proc expand data=GE out=WORK.SMA_ge method=none;
id DATE;  convert CLOSE = SMA_short   / transout=(movave 50); convert CLOSE = SMA_long   / transout=(movave 200);
run;



PROC SQL;
CREATE TABLE test as 
SELECT date, close FROM SMA_ge;
QUIT;



PROC SQL;
CREATE TABLE test_a as 
SELECT date, close, SMA_short FROM SMA_ge
WHERE date >"16MAR2010"d;
QUIT;



PROC SQL;
CREATE TABLE test_b as 
SELECT date, close, SMA_long FROM SMA_ge
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



DATA SMA_geb;
       SET SMA_ge;
	   L1_short=lag1(SMA_short);
	   L1_long=lag1(SMA_long);
	   if date>="18OCT2010"d;
RUN;



PROC SQL;
CREATE TABLE buy_signal_GE AS
SELECT date, close, "buy" AS signal FROM SMA_geb
WHERE L1_short<L1_long AND SMA_short>=SMA_long;
QUIT;



PROC SQL;
CREATE TABLE sell_signal_GE AS
SELECT date, close, "sell" AS signal FROM SMA_geb
WHERE L1_short>L1_long AND SMA_short<=SMA_long;
QUIT;



PROC SQL;
CREATE TABLE signal_GE AS
SELECT * FROM buy_signal_GE
UNION
SELECT * FROM sell_signal_GE
ORDER BY date;
QUIT;

  

PROC SQL;
CREATE TABLE return_GEa AS
SELECT date, close, 0 AS return_SMA FROM SMA_GE
WHERE date<"23DEC2010"d;

CREATE TABLE return_GEb AS
SELECT date, close, ((close -  18.040001) /  18.040001) AS return_SMA FROM SMA_GE
WHERE date>="23DEC2010"d AND date<"28JUL2011"d;

CREATE TABLE return_GEc AS
SELECT date, close, ((18.110001-18.040001)/18.040001) AS return_SMA FROM SMA_GE
WHERE date>="28JUL2011"d AND date<"02FEB2012"d;

CREATE TABLE return_GEd AS
SELECT date, close, ((close-18.75)/18.75+(18.110001-18.040001)/18.040001) AS return_SMA FROM SMA_GE
WHERE date>="02FEB2012"d AND date <="14AUG2014"d;

CREATE TABLE return_GEe AS
SELECT date, close, ((25.879999-18.75)/18.75+(18.110001-18.040001)/18.040001) AS return_SMA FROM SMA_GE
WHERE date>"14AUG2014"d AND date<"20APR2015"d;

CREATE TABLE return_GEf AS
SELECT date, close, ((close-27.02)/27.02+(18.110001-18.040001)/18.040001+(25.879999-18.75)/18.75) AS return_SMA FROM SMA_GE
WHERE date>="20APR2015"d AND date<="03SEP2015"d;

CREATE TABLE return_GEg AS
SELECT date, close, ((24.51-27.02)/27.02+(18.110001-18.040001)/18.040001+(25.879999-18.75)/18.75) AS return_SMA FROM SMA_GE
WHERE date>"03SEP2015"d AND date<"28OCT2015"d;

CREATE TABLE return_GEh AS
SELECT date, close, ((close-29.389999)/29.389999+(24.51-27.02)/27.02+(18.110001-18.040001)/18.040001+(25.879999-18.75)/18.75) AS return_SMA FROM SMA_GE
WHERE date>="28OCT2015"d AND date<="18OCT2016"d;

CREATE TABLE return_GEi AS
SELECT date, close, ((28.98-29.389999)/29.389999+(24.51-27.02)/27.02+(18.110001-18.040001)/18.040001+(25.879999-18.75)/18.75) AS return_SMA FROM SMA_GE
WHERE date>"18OCT2016"d AND date<"03JAN2017"d;

CREATE TABLE return_GEj AS
SELECT date, close, ((close-31.690001)/31.690001+(28.98-29.389999)/29.389999+(24.51-27.02)/27.02+(18.110001-18.040001)/18.040001+(25.879999-18.75)/18.75) AS return_SMA FROM SMA_GE
WHERE date>="03JAN2017"d AND date<="07MAR2017"d;

CREATE TABLE return_GEk AS
SELECT date, close, ((29.860001-31.690001)/31.690001+(28.98-29.389999)/29.389999+(24.51-27.02)/27.02+(18.110001-18.040001)/18.040001+(25.879999-18.75)/18.75) AS return_SMA FROM SMA_GE
WHERE date>"07MAR2017"d;

CREATE TABLE return_GEl AS
SELECT * FROM return_GEa
UNION
SELECT * FROM return_GEb
UNION
SELECT * FROM return_GEc
UNION
SELECT * FROM return_GEd
UNION
SELECT * FROM return_GEe
UNION
SELECT * FROM return_GEf
UNION
SELECT * FROM return_GEg
UNION
SELECT * FROM return_GEh
UNION
SELECT * FROM return_GEi
UNION
SELECT * FROM return_GEj
UNION
SELECT * FROM return_GEk
ORDER BY date;

CREATE TABLE return_GE AS
SELECT *, ((close-15.45)/15.45) AS return_hold FROM return_GEl;
QUIT;


Title1 "Return_SMA v.s. Return_hold of GE";
proc sgplot data=Return_GE cycleattrs;
   series x=Date y= return_SMA / name ='Return_SMA'  legendlabel = 'Return_SMA';
   series x=Date y = return_hold   / name='Return_hold'   legendlabel="Return_hold";
   xaxis display=(nolabel) grid;
   yaxis label="Return Price" grid;
 run;




