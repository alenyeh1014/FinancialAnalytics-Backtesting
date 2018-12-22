PROC IMPORT OUT= WORK.AAPL 
            DATAFILE= "C:\Users\user001\Desktop\Final_Project\Excel_data\AAPL.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
