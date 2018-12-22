PROC IMPORT OUT= WORK.MS 
            DATAFILE= "C:\Users\user001\Desktop\Final_Project\Excel_data\MS.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
