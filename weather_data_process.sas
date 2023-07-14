libname station "D:\永續農業創新發展中心\110年\期末海報\氣象資料";
libname weather "D:\投稿\水稻坪割資料\data\氣象資料\for_upload";

/*import agriculture station weather data CSV files*/
%macro import_ag();
data ag_climate;set _NULL_;run;
%do n=1 %to 60; 
data agstation;set station.all_station;
if c_altitude=' ';
run;
data agstation;set agstation;
if _N_=&n.;
call symput('code',substr(scode,1,6));
run;
%put &code;

proc import
datafile="D:\投稿\水稻坪割資料\data\氣象資料\農業站\&code..csv"
out=data
replace
dbms=CSV;
run;

data data;set data;
if _N_<=1 then delete;
run;

data ag_climate;set ag_climate data;run;

%let n=%eval(&n.);%end;
%mend;
%import_ag();

/*agricultural station weather data pre-process*/
data ag_climate;set ag_climate;
rename var1=scode
            var2=date;
meanT=var3+0;
maxT=var4+0;
minT=var5+0;
rh=var6+0;
meanWS=var7+0;
meanWD=var8+0;
PREC=var9+0;
SSH=var10+0;
RAD=var11+0;
EVAP=var12+0;
drop var3-var13;
run;
data weather.ag_climate;set ag_climate;run;
data agstation;set station.all_station;
if c_altitude=' ';
run;
proc sort data=agstation;by scode;run;
proc sort data=weather.ag_climate;by scode;run;
data weather.ag_climate;merge agstation weather.ag_climate(in=aa);
if aa=1;by scode;
drop c_altitude;
run;
data tp_ag_climate;set weather.ag_climate;
year=input(substr(date,1,4),4.);
month=input(substr(date,6,2),2.);
if meanT=. then miss1=1;else miss1=0;
if maxT=. then miss2=1;else miss2=0;
if minT=. then miss3=1;else miss3=0;
if RH=. then miss4=1;else miss4=0;
if meanWS=. then miss5=1;else miss5=0;
if meanWD=. then miss6=1;else miss6=0;
if PREC=. then miss7=1;else miss7=0;
if SSH=. then miss8=1;else miss8=0;
if RAD=. then miss9=1;else miss9=0;
if EVAP=. then miss10=1;else miss10=0;
run;

/*import non-agriculture station weather data CSV files*/
%macro import_nag();
proc printto log='log-file';run;
data weather.nag_climate;set _NULL_;run;
data nagstation;set station.all_station;
if c_altitude^=' ';
run;
%do n=2 %to 908;

data nags;set nagstation;
if _N_=&n.;
call symput('code',substr(scode,1,6));
run;
%put &code;

%do y=2003 %to 2021;
%do m1=1 %to 9;
proc import
datafile="D:\投稿\水稻坪割資料\data\氣象資料\CWB-Observation-Crawler-master\CWB-Observation-Crawler-master\data\&code.\&y.\&y.-0&m1..csv"
out=S1
replace
dbms=CSV;
run;

data S1;
set S1;
if _=0 then delete;
date=put(mdy(&m1.,ObsTime,&y.),yymmdd10.);
scode="&code.";
meanT=temp+0;
maxT=tmax+0;
minT=tmin+0;
RH1=rh+0;
meanWS=ws+0;
meanWD=wd+0;
SSH=sunhr+0;
RAD1=rad+0;
EVAP=evapa+0;
PRECrain=precp+0;
keep date scode meanT maxT minT RH1 meanWS meanWD PREC SSH RAD1 EVAP;
run;

data weather.nag_climate;set weather.nag_climate S1;run;
%let n=%eval(&n.);
%let y=%eval(&y.);
%let m1=%eval(&m1.);
%end;
%end;

%do y=2003 %to 2021;
%do m2=10 %to 12;
proc import
datafile="D:\投稿\水稻坪割資料\data\氣象資料\CWB-Observation-Crawler-master\CWB-Observation-Crawler-master\data\&code.\&y.\&y.-&m2..csv"
out=S2
replace
dbms=CSV;
run;

data S2;
set S2;
if _=0 then delete;
date=put(mdy(&m2.,ObsTime,&y.),yymmdd10.);
scode="&code.";
meanT=temp+0;
maxT=tmax+0;
minT=tmin+0;
RH1=rh+0;
meanWS=ws+0;
meanWD=wd+0;
SSH=sunhr+0;
RAD1=rad+0;
EVAP=evapa+0;
PRECrain=precp+0;
keep date scode meanT maxT minT RH1 meanWS meanWD PREC SSH RAD1 EVAP;
run;


data weather.nag_climate;set weather.nag_climate S2;run;
%let n=%eval(&n.);
%let y=%eval(&y.);
%let m2=%eval(&m2.);
%end;
%end;
%end;

data nagstation;set station.all_station;
if c_altitude^=' ';
run;
proc sort data=nagstation;by scode;run;
proc sort data=weather.nag_climate;by scode;run;
data weather.nag_climate;merge nagstation weather.nag_climate(in=aa);
if aa=1;by scode;
rename rh1=RH
            rad1=RAD;
drop c_altitude;
run;
%mend;
%import_nag();

/*non-agricultural station weather data pre-process*/
data tp_nag_climate;set weather.nag_climate;
year=input(substr(date,1,4),4.);
month=input(substr(date,6,2),2.);
if meanT=. then miss1=1;else miss1=0;
if maxT=. then miss2=1;else miss2=0;
if minT=. then miss3=1;else miss3=0;
if RH=. then miss4=1;else miss4=0;
if meanWS=. then miss5=1;else miss5=0;
if meanWD=. then miss6=1;else miss6=0;
if PREC=. then miss7=1;else miss7=0;
if SSH=. then miss8=1;else miss8=0;
if RAD=. then miss9=1;else miss9=0;
if EVAP=. then miss10=1;else miss10=0;
run;

/*combine agricultural and non-agricultural station weather data*/
data climate_all;length county $10; informat county $10.; format county $10. date1 mmddyy10.;
set  tp_ag_climate tp_nag_climate;
if substr(county,1,4) in ('台北','新北','臺北','基隆') then county='Taipei';
else if substr(county,1,4)='桃園' then county='Taoyuan';
else if substr(county,1,4)='新竹' then county='Hsinchu';
else if substr(county,1,4)='苗栗' then county='Miaoli';
else if substr(county,1,4) in ('台中','臺中') then county='Taichung';
else if substr(county,1,4)='彰化' then county='Changhua';
else if substr(county,1,4)='南投' then county='Nantou';
else if substr(county,1,4)='雲林' then county='Yunlin';
else if substr(county,1,4)='嘉義' then county='Chiayi';
else if substr(county,1,4) in ('台南','臺南') then county='Tainan';
else if substr(county,1,4)='高雄' then county='Kaohsiung';
else if substr(county,1,4)='屏東' then county='Pingtung';
else if substr(county,1,4)='宜蘭' then county='Yilan';
else if substr(county,1,4)='花蓮' then county='Hualien';
else if substr(county,1,4) in ('台東','臺東') then county='Taitung';
else if substr(county,1,4)='澎湖' then county='Penghu';
else if substr(county,1,4)='金門' then county='Kinmen';
else if substr(county,1,4)='連江' then county='Lienchiang';

if COUNTY in ('Penghu','Kinmen','Lienchiang') then REGION='Outer_island';
else if COUNTY in ('Taichung','Changhua','Nantou','Yunlin') then REGION='Central';
else if COUNTY in ('Taipei','Taoyuan','Hsinchu','Miaoli','Keelung') then REGION='Northern';
else if COUNTY in ('Chiayi','Tainan' ,'Kaohsiung','Pingtung') then REGION='Southern';
else REGION='Eastern';
date1=mdy(substr(date,6,2),substr(date,9,2),substr(date,1,4));
run; 
proc sort data=climate_all;by scode year month;run;

/*counting missing variables*/
proc sql;
create table missing_count as
select scode, year, month,
sum(miss1) as tmiss1,
sum(miss2) as tmiss2,
sum(miss3) as tmiss3,
sum(miss4) as tmiss4,
sum(miss5) as tmiss5,
sum(miss6) as tmiss6,
sum(miss7) as tmiss7,
sum(miss8) as tmiss8,
sum(miss9) as tmiss9,
sum(miss10) as tmiss10
from climate_all
group by scode, year, month;
quit;

/*remove the empty months*/
data miss_count_c1;set missing_count;
if substr(scode,1,2)='C1' and month=2 and tmiss7>=28 then delete;
if substr(scode,1,2)='C1' and tmiss7>=30 then delete;
if substr(scode,1,2)^='C1' and month=2 and tmiss1>=28 then delete;
if substr(scode,1,2)^='C1' and tmiss1>=30 then delete;
keep scode year month;
run;

data climate_c1;merge climate_all(in=aa) miss_count_c1(in=bb);
by scode year month;if aa=1 and bb=1;
drop year month miss1-miss10 date;
run;

/*check and remove the unusal values*/
data weather.climate_c1;set climate_c1;
if meanT^=. and (meanT<-12 or meanT>=35) then delete;
else if maxT^=. and (maxT<=-8 or maxT>=40.2) then delete;
else if minT^=. and (minT<=-20 or minT>=32) then delete;
else if RH^=. and (RH<0 or RH>100) then delete;
else if meanWS^=. and (meanWS<0) then delete;
else if meanWD^=. and (meanWD<0 or meanWD>360) then delete;
else if PREC^=. and (PREC<0 or PREC>1402) then delete;
else if SSH^=. and (SSH<0 or SSH>=13.3) then delete;
else if RAD^=. and (RAD<0 or RAD>40) then delete;
else if EVAP^=. and EVAP>25 then delete;
rename date1=date;
run;

/*data clean*/
/*remove outliers*/
proc means data=weather.climate_c1;
var meanT maxT minT RH SSH RAD EVAP;
output out=iqr q1= q3=/autoname;
run;
data bound;set iqr;
meanT1=meanT_q1-1.5*(meanT_q3-meanT_q1);
meanT2=meanT_q3+1.5*(meanT_q3-meanT_q1);
maxT1=maxT_q1-1.5*(maxT_q3-maxT_q1);
maxT2=maxT_q3+1.5*(maxT_q3-maxT_q1);
minT1=minT_q1-1.5*(minT_q3-minT_q1);
minT2=minT_q3+1.5*(minT_q3-minT_q1);
RH1=RH_q1-1.5*(RH_q3-RH_q1);
RH2=RH_q3+1.5*(RH_q3-RH_q1);
SSH1=SSH_q1-1.5*(SSH_q3-SSH_q1);
SSH2=SSH_q3+1.5*(SSH_q3-SSH_q1);
RAD1=RAD_q1-1.5*(RAD_q3-RAD_q1);
RAD2=RAD_q3+1.5*(RAD_q3-RAD_q1);
EVAP1=EVAP_q1-1.5*(EVAP_q3-EVAP_q1);
EVAP2=EVAP_q3+1.5*(EVAP_q3-EVAP_q1);
keep meanT1 meanT2 maxT1 maxT2 minT1 minT2 RH1 RH2 SSH1 SSH2 RAD1 RAD2 EVAP1 EVAP2;
run;

data bound;set bound;
do i=1 to 3361685;
output;
end;run;
data climate_c2;merge weather.climate_c1 bound;
if meanT^=. and (meanT<meanT1 or meanT>meanT2) then delete;
else if maxT^=. and (maxT<maxT1 or maxT>maxT2) then delete;
else if minT^=. and (minT<minT1 or minT>minT2) then delete;
else if RH^=. and (RH<RH1 or RH>RH2) then delete;
else if SSH^=. and (SSH<SSH1 or SSH>SSH2) then delete;
else if RAD^=. and (RAD<RAD1 or RAD>RAD2) then delete;
else if EVAP^=. and (EVAP<EVAP1 or EVAP>EVAP2) then delete;
run;
data climate_c2;set climate_c2;
drop i meanT1 meanT2 maxT1 maxT2 minT1 minT2 RH1 RH2 SSH1 SSH2 RAD1 RAD2 EVAP1 EVAP2;run;

/*remove outer island stations*/
data climate_c2;set climate_c2;
if region="Outer_island" then delete;
run;

/*remove stations higher than 1200 m*/
data climate_c2;set climate_c2;
year=year(date);
month=month(date);
if altitude>1200 then delete;
run;

/*remove the months with more than 10 days missing values*/
data miss_clean;set climate_c2;
if meanT=. then miss1=1;else miss1=0;
if maxT=. then miss2=1;else miss2=0;
if minT=. then miss3=1;else miss3=0;
if RH=. then miss4=1;else miss4=0;
if meanWS=. then miss5=1;else miss5=0;
if meanWD=. then miss6=1;else miss6=0;
if PREC=. then miss7=1;else miss7=0;
if SSH=. then miss8=1;else miss8=0;
if RAD=. then miss9=1;else miss9=0;
if EVAP=. then miss10=1;else miss10=0;
run;

proc sql;
create table missing_count as
select scode, year, month,
sum(miss1) as tmiss1,
sum(miss2) as tmiss2,
sum(miss3) as tmiss3,
sum(miss4) as tmiss4,
sum(miss5) as tmiss5,
sum(miss6) as tmiss6,
sum(miss7) as tmiss7,
sum(miss8) as tmiss8,
sum(miss9) as tmiss9,
sum(miss10) as tmiss10
from miss_clean
group by scode, year, month;
quit;

data missing_count_clean;set missing_count;
if substr(scode,1,2)="C1" and tmiss7>10 then delete;
if substr(scode,1,2)^="C1" and (tmiss1>10 or tmiss2>10 or tmiss3>10 or tmiss5>10 or tmiss6>10 or tmiss7>10)
then delete;
keep scode year month;
run;

proc sort data=missing_count_clean;by scode year month;run;
proc sort data=climate_c2;by scode year month;run;

data climate_clean;merge climate_c2(in=aa) missing_count_clean(in=bb);
by scode year month;
if aa=1 and bb=1;
run;

data weather.climate_c2;set climate_clean;
drop month year;run;

data weather_c1;
retain COUNTY REGION SCode Altitude Longitude Latitude Date meanT maxT minT RH
meanWS meanWD PREC RAD SSH EVAP;
set weather.climate_c1;
rename County=COUNTY;
drop rh1 rad1;
run;

data weather_c2;
retain COUNTY REGION SCode Altitude Longitude Latitude Date meanT maxT minT RH
meanWS meanWD PREC RAD SSH EVAP;
set weather.climate_c2;
rename County=COUNTY
            rh=RH
            date=Date;
run;

/*export sas dataset to CSV file*/
proc export data=weather_c2
     outfile="D:\投稿\水稻坪割資料\data\氣象資料\for_upload\weather_cleaned.csv"
     dbms=csv 
     replace;
run;

proc export data=weather_c1
     outfile="D:\投稿\水稻坪割資料\data\氣象資料\for_upload\weather_raw.csv"
     dbms=csv 
     replace;
run;


