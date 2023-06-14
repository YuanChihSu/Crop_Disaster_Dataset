import os
import requests
import pandas as pd
from bs4 import BeautifulSoup

twStationList =["466910","466930"]#list of weather station codes
altitude =["837.6","607.1"]#list of weather station altitude
yearList= ["2022"]#list of search years
monthSearch = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]#list of search months
def cdateList(year):
    yearData=[]
    s=""
    for month in monthSearch:
        s = year + '-' + str(month).zfill(2)
        yearData.append(s)
    return yearData

def crawler(url,station,year,date):
    resp = requests.get(url)
    soup = BeautifulSoup(resp.text, features="html.parser")

    form =[]

    strtitle=["ObsTime","StnPress","SeaPress","StnPressMax","StnPressMaxTime","StnPressMin","StnPressMinTime",
              "Temp","TMax","TMaxTime","TMin","TMinTime","TD","RH","RHMin","RHMinTime","WS","WD","WSG","WDG","WGTime",
              "Precp","PrecpHr","PrecpMxa10","PrecpMxa10Time","PrecpMxa60","PrecpMxa60Time","SunHr","SunRate","Rad",
              "VisbMean","EvapA","UVIMax","UVIMaxTime","Cloud"]

    soup = soup.tbody
    tmps = soup.find_all("tr")
    tmps = tmps[2:]
    for tmp in tmps:
        tmp = tmp.find_all("td")
        parameter = []
        for i in range(len(tmp)):
            strtmp = tmp[i].getText()
            parameter.append(strtmp.strip('\xa0'))
        form.append(parameter)

    form = pd.DataFrame(form, columns=strtitle)
    form.to_csv("./weather/"+station+'/'+year+'/'+date+".csv", encoding ="utf-8")

# station
for station in twStationList:
    for altitude in altitude:
        # create station folder
        dirPath = './weather/'+station
        if os.path.exists(dirPath) == 0:
            os.makedirs(dirPath)

        for year in yearList:
            dateList = cdateList(year)
        # create year folder
            dirPath = './weather/'+station+'/'+year
            if os.path.exists(dirPath) == 0:
                os.makedirs(dirPath)
        # date
            for date in dateList:
                url="http://e-service.cwb.gov.tw/HistoryDataQuery/MonthDataController.do?command=viewMain&station="+station+"&stname=&datepicker="+date+"&altitude="+altitude+"m"

                if os.path.isfile("./test/"+station+'/'+year+'/'+date+".csv")==False:
                    try:
                        print(station+':'+date)
                        crawler(url,station,year,date)
                    except Exception as e:
                        print(station + ':' + date + ' Error!' + ' Code: {c}, Message: {m}'.format(c = type(e).__name__, m = str(e)))
                        with open ("./error.txt",'a') as f:
                            f.write(url+','+station+','+year+','+date+'\n')