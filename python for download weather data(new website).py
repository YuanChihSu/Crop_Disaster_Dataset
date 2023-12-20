import os
import json
import pandas as pd
import requests
from bs4 import BeautifulSoup
import calendar

def month_weather(station, year, month):
    strtitle=["ObsTime","StnPress","SeaPress","StnPressMax","StnPressMaxTime","StnPressMin","StnPressMinTime",
              "Temp","TMax","TMaxTime","TMin","TMinTime","TD","RH","RHMin","RHMinTime","WS","WD","WSG","WDG","WGTime",
              "Precp","PrecpHr","PrecpMxa10","PrecpMxa10Time","PrecpMxa60","PrecpMxa60Time","SunHr","SunRate","Rad",
              "VisbMean","EvapA","UVIMax","UVIMaxTime","Cloud"]

    y = int(year)

    m_end = str(calendar.monthrange(y, month)[1])
    #find end of the month

    m2 = str(month).zfill(2)
    #fill zero when month are 1-9

    if station[0:2] == 'C0':
        type = 'auto_C0'
    elif station[0:2] == 'C1':
        type = 'auto_C1'
    else:
        type = 'cwb'

    payload={
        'date' : year+"-"+m2+"-01T00:00:00.000+08:00",
        'type' : "report_month",
        'stn_ID' : station,
        'stn_type' : type,
        'more' : " ",
        'start' : year+"-"+m2+"-01T00:00:00",
        'end' : year+"-"+m2+"-"+m_end+"T00:00:00",
        'item' : " "
        }
    r = requests.post("https://codis.cwa.gov.tw/api/station?",payload)
    json_content = r.content.decode('utf-8')
    json_dict = json.loads(json_content)

    form = []

    if json_dict['metadata']['count'] != 0:
        for i in range(len(json_dict['data'][0]['dts'])):

            date = json_dict['data'][0]['dts'][i]['DataDate']

            if 'StationPressure' in json_dict['data'][0]['dts'][i]:
                meanstnpress = json_dict['data'][0]['dts'][i]['StationPressure']['Mean']
                maxstnpress = json_dict['data'][0]['dts'][i]['StationPressure']['Maximum']
                maxstnpresst = json_dict['data'][0]['dts'][i]['StationPressure']['MaximumTime']
                minstnpress = json_dict['data'][0]['dts'][i]['StationPressure']['Minimum']
                minstnpresst = json_dict['data'][0]['dts'][i]['StationPressure']['MinimumTime']
            else:
                meanstnpress = -99
                maxstnpress = -99
                maxstnpresst = -99
                minstnpress = -99
                minstnpresst = -99
            if 'SeaLevelPressure' in json_dict['data'][0]['dts'][i]:
                seapress = json_dict['data'][0]['dts'][i]['SeaLevelPressure']['Mean']
            else:
                seapress = -99
            if 'AirTemperature' in json_dict['data'][0]['dts'][i]:
                meanT = json_dict['data'][0]['dts'][i]['AirTemperature']['Mean']
                maxT = json_dict['data'][0]['dts'][i]['AirTemperature']['Maximum']
                maxTt = json_dict['data'][0]['dts'][i]['AirTemperature']['MaximumTime']
                minT = json_dict['data'][0]['dts'][i]['AirTemperature']['Minimum']
                minTt = json_dict['data'][0]['dts'][i]['AirTemperature']['MinimumTime']
            else:
                meanT = -99
                maxT = -99
                maxTt = -99
                minT = -99
                minTt = -99
            if 'DewPointTemperature' in json_dict['data'][0]['dts'][i]:
                dwT = json_dict['data'][0]['dts'][i]['DewPointTemperature']['Mean']
            else:
                dwT = -99
            if 'RelativeHumidity' in json_dict['data'][0]['dts'][i]:
                rh = json_dict['data'][0]['dts'][i]['RelativeHumidity']['Mean']
                minrh = json_dict['data'][0]['dts'][i]['RelativeHumidity']['Minimum']
                minrht = json_dict['data'][0]['dts'][i]['RelativeHumidity']['MinimumTime']
            else:
                rh = -99
                minrh = -99
                minrht = -99
            if 'WindSpeed' in json_dict['data'][0]['dts'][i]:
                ws = json_dict['data'][0]['dts'][i]['WindSpeed']['Mean']
            else:
                ws = -99
            if 'WindDirection' in json_dict['data'][0]['dts'][i]:
                wd = json_dict['data'][0]['dts'][i]['WindDirection']['Prevailing']
            else:
                wd = -99
            if 'PeakGust' in json_dict['data'][0]['dts'][i]:
                wsg = json_dict['data'][0]['dts'][i]['PeakGust']['Maximum']
                wdg = json_dict['data'][0]['dts'][i]['PeakGust']['Direction']
                wsgt = json_dict['data'][0]['dts'][i]['PeakGust']['MaximumTime']
            else:
                wsg = -99
                wdg = -99
                wsgt = -99
            if 'Precipitation' in json_dict['data'][0]['dts'][i]:
                prec = json_dict['data'][0]['dts'][i]['Precipitation']['Accumulation']
                if 'TenMinutelyMaximum' in json_dict['data'][0]['dts'][i]['Precipitation']:
                    prec10 = json_dict['data'][0]['dts'][i]['Precipitation']['TenMinutelyMaximum']
                else:
                    prec10 = -99
                if 'TenMinutelyMaximumTime' in json_dict['data'][0]['dts'][i]['Precipitation']:
                    prec10t = json_dict['data'][0]['dts'][i]['Precipitation']['TenMinutelyMaximumTime']
                else:
                    prec10t = -99
                if 'SixtyMinutelyMaximum' in json_dict['data'][0]['dts'][i]['Precipitation']:
                    prec60 = json_dict['data'][0]['dts'][i]['Precipitation']['SixtyMinutelyMaximum']
                else:
                    prec60 = -99
                if 'SixtyMinutelyMaximumTime' in json_dict['data'][0]['dts'][i]['Precipitation']:
                    prec60t = json_dict['data'][0]['dts'][i]['Precipitation']['SixtyMinutelyMaximumTime']
                else:
                    prec60t = -99
            else:
                prec = -99
            if 'PrecipitationDuration' in json_dict['data'][0]['dts'][i]:
                prechr = json_dict['data'][0]['dts'][i]['PrecipitationDuration']['Total']
            else:
                prechr = -99
            if 'SunshineDuration' in json_dict['data'][0]['dts'][i]:
                sh = json_dict['data'][0]['dts'][i]['SunshineDuration']['Total']
                if 'Rate' in json_dict['data'][0]['dts'][i]['SunshineDuration']:
                    sr = json_dict['data'][0]['dts'][i]['SunshineDuration']['Rate']
                else:
                    sr = -99
            else:
                sh = -99
            if 'GlobalSolarRadiation' in json_dict['data'][0]['dts'][i]:
                rad = json_dict['data'][0]['dts'][i]['GlobalSolarRadiation']['Accumulation']
            else:
                rad = -99
            if 'EvaporationClassAPan' in json_dict['data'][0]['dts'][i]:
                evapa = json_dict['data'][0]['dts'][i]['EvaporationClassAPan']['Accumulation']
            else:
                evapa = -99
            if 'Visibility' in json_dict['data'][0]['dts'][i]:
                visb = json_dict['data'][0]['dts'][i]['Visibility']['Mean']
            else:
                visb = -99
            if 'UVIndex' in json_dict['data'][0]['dts'][i]:
                uvimax = json_dict['data'][0]['dts'][i]['UVIndex']['Maximum']
                uvimaxt = json_dict['data'][0]['dts'][i]['UVIndex']['MaximumTime']
            else:
                uvimax = -99
                uvimaxt = -99
            if 'TotalCloudAmount' in json_dict['data'][0]['dts'][i]:
                cloud = json_dict['data'][0]['dts'][i]['TotalCloudAmount']['Mean']
            else:
                cloud = -99
            parameter = [date, meanstnpress, seapress, maxstnpress, maxstnpresst, minstnpress, minstnpresst, meanT, maxT,
                        maxTt, minT, minTt, dwT, rh, minrh, minrht, ws, wd, wsg, wdg, wsgt, prec, prechr, prec10, prec10t,
                        prec60, prec60t, sh, sr, rad, visb, evapa, uvimax, uvimaxt, cloud]
            form.append(parameter)
    else:
        for j in range(int(m_end)):
            day = str(j+1).zfill(2)
            date = year + '-' + m2 + '-' + day + 'T00:00:00'
            meanstnpress = -99
            seapress = -99
            maxstnpress = -99
            maxstnpresst = -99
            minstnpress = -99
            minstnpresst = -99
            meanT = -99
            maxT = -99
            maxTt = -99
            minT = -99
            minTt = -99
            dwT = -99
            rh = -99
            minrh = -99
            minrht = -99
            ws = -99
            wd = -99
            wsg = -99
            wdg = -99
            wsgt = -99
            prec = -99
            prechr = -99
            prec10 = -99
            prec10t = -99
            prec60 = -99
            prec60t = -99
            sh = -99
            sr = -99
            rad = -99
            visb = -99
            evapa = -99
            uvimax = -99
            uvimaxt = -99
            cloud = -99
            parameter = [date, meanstnpress, seapress, maxstnpress, maxstnpresst, minstnpress, minstnpresst, meanT,
                         maxT, maxTt, minT, minTt, dwT, rh, minrh, minrht, ws, wd, wsg, wdg, wsgt, prec, prechr, prec10,
                         prec10t, prec60, prec60t, sh, sr, rad, visb, evapa, uvimax, uvimaxt, cloud]
            form.append(parameter)

    form = pd.DataFrame(form, columns=strtitle)
    form = form.sort_values(by=['ObsTime'])
    form.to_csv("./weather_new/" + station + '/' + year + '/' + year + '-' + m2 + ".csv", encoding="utf-8")

yearList= ["2022"]#list of search years

monthSearch = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]#list of search months

twStationList =["466920", "466910", "C0A9C0","C1A750"]
#list of weather station codes

#stations
for station in twStationList:
    # create station folder
    dirPath = './weather_new/' + station
    if os.path.exists(dirPath) == 0:
        os.makedirs(dirPath)

    for year in yearList:
    # create year folder
        dirPath = './weather_new/' + station + '/' + year
        if os.path.exists(dirPath) == 0:
            os.makedirs(dirPath)
    #month
        for month in monthSearch:
            m = str(month).zfill(2)
            if os.path.isfile("./weather_new/" + station + '/' + year + '/' + m + ".csv") == False:
                try:
                    print(station + ':' + m)
                    month_weather(station, year, month)
                except Exception as e:
                    print(station + ':' + m + ' Error!' + ' Code: {c}, Message: {m}'.format(c=type(e).__name__,
                                                                                               m=str(e)))
                    with open("./error_new/error.txt", 'a') as f:
                        f.write(station + ',' + year + ',' + m + '\n')
