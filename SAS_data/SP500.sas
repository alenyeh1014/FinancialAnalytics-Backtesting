PROC IMPORT OUT= WORK.SP500 
            DATAFILE= "C:\Users\user001\Desktop\Final_Project\Excel_data\SP500.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
