LIBNAME mydir "/home/u49610626/Data";

PROC IMPORT OUT = MYDIR.chicrime2 DATAFILE = "/home/u49610626/Data/Crimes_2009_to_Present.csv" DBMS = csv;
	GETNAMES = YES;
RUN;


DATA chicrime(DROP = ID "Case Number"n Block IUCR Location Beat District Ward "Community Area"n "FBI Code"n "Updated On"n "X Coordinate"n "Y Coordinate"n Latitude Longitude);
SET mydir.chicrime2;
Date = datepart(date);
FORMAT Date ddmmyy10.;
RUN;


PROC GCHART DATA = chicrime;
VBAR "Primary Type"n;
RUN;




*Theft, Narcotics, Criminal Dmg, Battery;

*Graph of a type of crime that occurs throughout the whole dataset;
%MACRO freqandplot(type =, outputdata =);

PROC FREQ data = chicrime NOPRINT;
Title "&type per Year";
TABLE Date/OUT = &outputdata;
WHERE "Primary Type"n = &type;
RUN;

PROC MEANS DATA = &outputdata MEAN STD CLM ALPHA = 0.05 MIN MAX;
Title "&type Statisitcs";
VAR COUNT;
RUN;

SYMBOL1 VALUE = circle COLOR = red I = none;

PROC GPLOT DATA = &outputdata;
Title "&type Throughout the Year";
PLOT COUNT*Date;
RUN;

%MEND freqandplot;

%freqandplot(type = "THEFT", outputdata = dummy);
%freqandplot(type = "BATTERY", outputdata = dummy);
%freqandplot(type = "CRIMINAL DAMAGE", outputdata = dummy);
%freqandplot(type = "NARCOTICS", outputdata = dummy);








*Graph of a type of crime that occurs in a given year;
%MACRO freqandplot_byyear(outputdata2 =, type =, year =);

DATA dummy;
SET chicrime;
WHERE YEAR = &year;
RUN;

PROC FREQ data = dummy NOPRINT;
Title "&type Throughout the Year";
TABLE Date/OUT = &outputdata2;
WHERE "Primary Type"n = &type;
RUN;

PROC MEANS DATA = &outputdata2 MEAN STD CLM ALPHA = 0.05 MIN MAX;
Title "&type Statisitcs";
VAR COUNT;
RUN;

SYMBOL1 VALUE = circle COLOR = red I = none;

PROC GPLOT DATA = &outputdata2;
Title "&type Throughout the Year";
PLOT COUNT*Date;
RUN;

%MEND freqandplot_byyear;







*The average number of a crime that occurs in a day in a given year;
%MACRO crime_year_means(crime =, year =, output =);

DATA chicrimeyear;
SET chicrime;
WHERE YEAR = &year;
RUN;

PROC FREQ data = chicrimeyear NOPRINT;
Title "&crime per Year";
TABLE Date/OUT = &output;
WHERE "Primary Type"n = &crime;
RUN;

PROC MEANS DATA = &output MEAN STD CLM ALPHA = 0.05 MIN MAX SUM;
Title "&crime Statisitcs in &Year";
VAR COUNT;
RUN;

%MEND crime_year_means;




%crime_year_means(crime ="THEFT", year = 2009, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2010, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2011, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2012, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2013, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2014, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2015, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2016, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2017, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2018, output = dummytheft);
%crime_year_means(crime ="THEFT", year = 2019, output = dummytheft);

DATA Theft_total;
INPUT Year Total;
DATALINES;
2009 80975.00	
2010 76756.00
2011 75150.00
2012 75462.00
2013 71531.00
2014 61565.00
2015 57344.00
2016 61616.00
2017 64375.00
2018 65264.00
2019 62432.00
;



DATA Theft_per_dayavg;
INPUT Year Average;
DATALINES;
2009 221.8493151	
2010 210.2904110
2011 205.8904110
2012 206.1803279
2013 195.9753425
2014 168.6712329
2015 157.1068493
2016 176.3698630
2017 176.3698630
2018 178.8054795
2019 171.0465753
;


PROC REG DATA = Theft_per_dayavg;
MODEL Average = Year/clb;
RUN;

PROC REG DATA = Theft_total;
MODEL Total = Year/CLB;
RUN;


%crime_year_means(crime ="BATTERY", year = 2009, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2010, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2011, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2012, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2013, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2014, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2015, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2016, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2017, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2018, output = dummy);
%crime_year_means(crime ="BATTERY", year = 2019, output = dummy);

DATA Battery_total;
INPUT Year Total;
DATALINES;
2009 68462.00	
2010 65403.00
2011 60458.00
2012 59137.00
2013 54005.00
2014 49449.00
2015 48917.00
2016 50296.00
2017 49231.00
2018 49813.00
2019 49495.00
;


DATA Battery_per_dayavg;
INPUT Year Average;
DATALINES;
2009 187.5671233	
2010 179.1863014
2011 165.6383562
2012 161.5765027	
2013 147.9589041
2014 135.4767123
2015 134.0191781
2016 137.4207650
2017 134.8794521
2018 136.4739726	
2019 135.6027397
;
RUN;

PROC REG DATA = Battery_per_dayavg;
MODEL Average = Year/clb;
RUN;

PROC REG DATA = Battery_total;
MODEL tOTAL = Year/clb;
RUN;


%crime_year_means(crime ="NARCOTICS", year = 2009, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2010, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2011, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2012, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2013, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2014, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2015, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2016, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2017, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2018, output = dummy);
%crime_year_means(crime ="NARCOTICS", year = 2019, output = dummy);


DATA Narc_total;
INPUT Year Total;
DATALINES;
2009 43542.00	
2010 43393.00
2011 38605.00
2012 35488.00
2013 34127.00
2014 29118.00
2015 23939.00
2016 13333.00
2017 11671.00
2018 13577.00
2019 15050.00
;


DATA Narc_per_dayavg;
INPUT Year Average;
DATALINES;
2009 119.2931507	
2010 118.8849315
2011 105.7671233
2012 96.9617486		
2013 93.4986301
2014 96.9617486	
2015 65.5863014	
2016 36.4289617
2017 31.9753425
2018 37.1972603	
2019 41.2328767
;
RUN;

PROC REG DATA = Narc_per_dayavg;
MODEL Average = Year/clb;
RUN;

PROC REG DATA = Narc_total;
MODEL tOTAL = Year/clb;
RUN;

%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2009, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2010, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2011, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2012, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2013, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2014, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2015, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2016, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2017, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2018, output = dummy);
%crime_year_means(crime ="CRIMINAL DAMAGE", year = 2019, output = dummy);

DATA Dmg_total;
INPUT Year Total;
DATALINES;
2009 47724.00	
2010 40653.00
2011 37332.00
2012 35854.00
2013 30853.00
2014 27798.00
2015 28676.00
2016 31018.00
2017 29044.00
2018 27822.00
2019 26680.00
;


DATA Dmg_per_dayavg;
INPUT Year Average;
DATALINES;
2009 130.7506849		
2010 111.3780822	
2011 102.2794521	
2012 97.9617486		
2013 84.5287671
2014 76.1589041
2015 78.5643836
2016 84.7486339	
2017 79.5726027	
2018 76.2246575	
2019 73.0958904	
;
RUN;

PROC REG DATA = Dmg_per_dayavg;
MODEL Average = Year/clb;
RUN;

PROC REG DATA = Dmg_total;
MODEL tOTAL = Year/clb;
RUN;








	

