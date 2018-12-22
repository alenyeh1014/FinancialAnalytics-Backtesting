PROC IMPORT OUT= WORK.GE 
            DATAFILE= "C:\Users\user001\Desktop\Final_Project\Excel_data\GE.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
