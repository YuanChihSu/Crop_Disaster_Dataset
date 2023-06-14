libname damage 'D:\投稿\水稻坪割資料\data\災害資料\for_upload';

%macro csv_data(dir,y);
%let rc=%sysfunc(filename(filrf,&dir));
%let did=%sysfunc(dopen(&filrf));
data d&y.;set _NULL_;run;

%if &did ne 0 %then %do;
%let memcnt=%sysfunc(dnum(&did));
%do i=1 %to &memcnt;
data s;
infile "D:\投稿\水稻坪割資料\data\災害資料\csv\d&y.\d&y._&i..csv"
delimiter = ","
missover 
dsd;

informat VAR1 $30.;
informat VAR2 $30.;
informat VAR3 $30.;
informat VAR4 $30.;
informat VAR5 $30.;
informat FIELD_AREA comma12.;
informat DAMAGED_PERCENTAGE best12.;
informat DAMAGED_AREA comma12.;
informat EST_LOSS_Q comma12.;
informat EST_LOSS_V comma12.;
 
input
VAR1 $
VAR2 $
VAR3 $
VAR4 $
VAR5 $
FIELD_AREA
DAMAGED_PERCENTAGE
DAMAGED_AREA
EST_LOSS_Q
EST_LOSS_V;
run;
data d&y.;set d&y. s;run;
%end;
%end;

data damage.d&y.;retain _VAR2 _VAR3 _VAR4;
length CROP $30 DISASTER $30 MONTH_C $10 MONTH $10;
set d&y.;
if VAR2 in ('次年5月底前填報','次年四月底前填報','次年三月底前填報','"價值',
'估  計  量  值','"被 害 程 度','"換算被害面積') then VAR2=' ';
if not missing(VAR2)
then _VAR2 = VAR2;
else VAR2 = _VAR2;

if VAR3='災害別' then VAR3=' ';
if not missing(VAR3)
then _VAR3 = VAR3;
else VAR3 = _VAR3;

if VAR4 in ('發生日期','中華民國','審核') then VAR4=' ';
if not missing(VAR4)
then _VAR4 = VAR4;
else VAR4 = _VAR4;

MONTH_C=VAR4;
DISASTER=VAR3;

if VAR5=' ' then delete;
if FIELD_AREA=. then delete;

if substr(VAR2,1,4)='高雄' then COUNTY='Kaohsiung';
else if substr(VAR2,1,4) in ('台北','新北','臺北','基隆') then COUNTY='Taipei';
else if substr(VAR2,1,4)='桃園' then COUNTY='Taoyuan';
else if substr(VAR2,1,4)='新竹' then COUNTY='Hsinchu';
else if substr(VAR2,1,4)='苗栗' then COUNTY='Miaoli';
else if substr(VAR2,1,4) in ('台中','臺中') then COUNTY='Taichung';
else if substr(VAR2,1,4)='彰化' then COUNTY='Changhua';
else if substr(VAR2,1,4)='南投' then COUNTY='Nantou';
else if substr(VAR2,1,4)='雲林' then COUNTY='Yunlin';
else if substr(VAR2,1,4)='嘉義' then COUNTY='Chiayi';
else if substr(VAR2,1,4) in ('台南','臺南') then COUNTY='Tainan';
else if substr(VAR2,1,4)='屏東' then COUNTY='Pingtung';
else if substr(VAR2,1,4)='宜蘭' then COUNTY='Yilan';
else if substr(VAR2,1,4)='花蓮' then COUNTY='Hualien';
else if substr(VAR2,1,4) in ('台東','臺東') then COUNTY='Taitung';
else if substr(VAR2,1,4)='澎湖' then COUNTY='Penghu';
else if substr(VAR2,1,4)='金門' then COUNTY='Kinmen';

if VAR4 in ('一月','1月') then MONTH='01';
else if VAR4 in ('二月','2月') then MONTH='02';
else if VAR4 in ('三月','3月') then MONTH='03';
else if VAR4 in ('四月','4月') then MONTH='04';
else if VAR4 in ('五月','5月') then MONTH='05';
else if VAR4 in ('六月','6月') then MONTH='06';
else if VAR4 in ('七月','7月') then MONTH='07';
else if VAR4 in ('八月','8月') then MONTH='08';
else if VAR4 in ('九月','9月') then MONTH='09';
else if VAR4 in ('十月','10月') then MONTH='10';
else if VAR4 in ('十一月','11月') then MONTH='11';
else if VAR4 in ('十二月','12月') then MONTH='12';
else if VAR4 in ('1-2月') then MONTH='01_02';
else if VAR4 in ('1-3月') then MONTH='01_03';
else if VAR4 in ('2~3月') then MONTH='02_03';
else if VAR4 in ('3-4月','3~4月') then MONTH='03_04';
else if VAR4 in ('4-6月') then MONTH='04_06';
else if VAR4 in ('6~7月') then MONTH='06_07';
else if VAR4 in ('7-8月') then MONTH='07_08';

YEAR=&y.+1911;

if VAR5='其他雜糧' then CROP='Other_Coarse_Grains';/*自翻*/
else if VAR5='水稻' then CROP='Rice';
else if VAR5='秧苗' then CROP='Rice_Seedling';/*自翻*/
else if VAR5 in ('硬質玉米','食用玉米','飼料玉米') then CROP='Maize';
else if VAR5='甘藷' then CROP='Sweet_Potato';
else if VAR5='落花生' then CROP='Peanut';
else if VAR5='紅豆' then CROP='Adzuki_Bean';
else if VAR5='茶' then CROP='Tea';
else if VAR5='胡麻' then CROP='Sesame';
else if VAR5='生食甘蔗' then CROP='Sugarcane';
else if VAR5='其他特作' then CROP='Other_Special_Crops';/*自翻*/
else if VAR5='蘆筍' then CROP='Asparagus';
else if VAR5='韭菜' then CROP='Leek';/*自翻*/
else if VAR5='竹筍' then CROP='Bamboo_Shoot';/*自翻*/
else if VAR5='金針菜' then CROP='Day_Lily';/*自翻*/
else if VAR5='洋蔥' then CROP='Onions';
else if VAR5='蘿蔔' then CROP='Radishes';
else if VAR5='胡蘿蔔' then CROP='Carrots';
else if VAR5='茭白筍' then CROP='Water Bamboo';/*自翻*/
else if VAR5='甘藍' then CROP='Cabbage';
else if VAR5='結球白菜' then CROP='Chinese_Cabbage';/*自翻*/
else if VAR5='不結球白菜' then CROP='Chinese_Mustard';/*自翻*/
else if VAR5='番茄' then CROP='Tomato';
else if VAR5='蒜頭' then CROP='Garlic';
else if VAR5='蔥' then CROP='Scallion';/*自翻*/
else if VAR5='芋' then CROP='Taros';
else if VAR5='薑' then CROP='Ginger';
else if VAR5='西瓜' then CROP='Watermelon';
else if VAR5='香瓜' then CROP='Melon';
else if VAR5='草莓' then CROP='Strawberry';
else if VAR5='花椰菜' then CROP='Cauliflower';
else if VAR5='胡瓜' then CROP='Cucumber';
else if VAR5='冬瓜' then CROP='White_Gourd';/*自翻*/
else if VAR5='苦瓜' then CROP='Bitter_Gourd';/*自翻*/
else if VAR5='茄子' then CROP='Eggplant';
else if VAR5='菜豆' then CROP='Kidney_Bean';/*自翻*/
else if VAR5='毛豆' then CROP='Soybean (for vegetable)';/*自翻*/
else if VAR5 in ('豌豆(荷蘭豆)','豌豆(荷蘭豆) Peas') then CROP='Pea';
else if VAR5='番椒' then CROP='Pepper';
else if VAR5='絲瓜' then CROP='Vegetable_sponge';/*自翻*/
else if VAR5='蔬菜' then CROP='Other_Vegetables';
else if VAR5='香蕉' then CROP='Banana';
else if VAR5='鳳梨' then CROP='Pineapple';
else if VAR5='椪柑' then CROP='Ponkan';/*自翻*/
else if VAR5='桶柑' then CROP='Tankan';/*自翻*/
else if VAR5='柳橙' then CROP='Orange';
else if VAR5='文旦柚' then CROP='Wentan_Pomelo';
else if VAR5='柚' then CROP='Pomelo';
else if VAR5='檸檬' then CROP='Lemon';
else if VAR5='其他柑桔' then CROP='Other_Citrus';
else if VAR5='芒果' then CROP='Mango';
else if VAR5='龍眼' then CROP='Longan';/*自翻*/
else if VAR5='檳榔' then CROP='Betel_Nut';
else if VAR5='番石榴' then CROP='Guava';
else if VAR5='李' then CROP='Plum';
else if VAR5='桃' then CROP='Peach';
else if VAR5='柿' then CROP='Persimmon';
else if VAR5='木瓜' then CROP='Papaya';
else if VAR5='蓮霧' then CROP='Wax_Apple';/*自翻*/
else if VAR5='葡萄' then CROP='Grape';
else if VAR5='枇杷' then CROP='Loquat';
else if VAR5='梅' then CROP='Japanese_Apricot';/*自翻*/
else if VAR5='荔枝' then CROP='Litchi';
else if VAR5='楊桃' then CROP='Carambola';/*自翻*/
else if VAR5='梨' then CROP='Oriental_Pear';/*自翻*/
else if VAR5='蘋果' then CROP='Apple';
else if VAR5='棗' then CROP='Jujube';/*自翻*/
else if VAR5='番荔枝' then CROP='Sugar_Apple';/*自翻*/
else if VAR5='百香果' then CROP='Passion_Fruit';/*自翻*/
else if VAR5='可可椰子' then CROP='Coconut';
else if VAR5='其他青果' then CROP='Other_Fruits';
else if VAR5='山藥' then CROP='Yam';
else if VAR5='菊花' then CROP='Chrysanthemum';/*自翻*/
else if VAR5='唐菖蒲' then CROP='Gladiolu';/*自翻*/
else if VAR5='洋桔梗' then CROP='Eustoma';/*自翻*/
else if VAR5='牧草' then CROP='Forage_Crops';
else if VAR5='玫瑰' then CROP='Rose';
else if VAR5='其他花卉' then CROP='Other_Cut_Flowers';
else if VAR5='苗圃' then CROP='Nuseries';
else if VAR5='太空包香菇' then CROP='Bagocultred_Shitake';
else if VAR5='馬鈴薯' then CROP='Potato';
else if VAR5='洋菇' then CROP='Mushroom';
else if VAR5='菸草' then CROP='Tobacco';

/*學名*/
if VAR5='甘藍' then BOTANICAL_NAME='Brassica_oleracea (var. capitata)';
else if VAR5 in ('水稻','秧苗') then BOTANICAL_NAME='Oryza_sativa';
else if VAR5 in ('硬質玉米','食用玉米','飼料玉米') then BOTANICAL_NAME='Zea_mays';
else if VAR5='甘藷' then BOTANICAL_NAME='Lopmoea_batatas';
else if VAR5='落花生' then BOTANICAL_NAME='Arachis_hypogaea';
else if VAR5='紅豆' then BOTANICAL_NAME='Vigna_angularis';
else if VAR5='茶' then BOTANICAL_NAME='Camellia_sinensis';
else if VAR5='胡麻' then BOTANICAL_NAME='Sesamum_indicum';
else if VAR5='生食甘蔗' then BOTANICAL_NAME='Saccharum_officinarum';
else if VAR5='蘆筍' then BOTANICAL_NAME='Asparagus_officinalis';
else if VAR5='韭菜' then BOTANICAL_NAME='Allium_tuberosum';
else if VAR5='竹筍' then BOTANICAL_NAME='Bambusa_spp.';
else if VAR5='金針菜' then BOTANICAL_NAME='Hemerocallis_lilioasphodelus';
else if VAR5='洋蔥' then BOTANICAL_NAME='Allium_cepa';
else if VAR5='蘿蔔' then BOTANICAL_NAME='Raphanus_sativus';
else if VAR5='胡蘿蔔' then BOTANICAL_NAME='Daucus_carota (ssp. sativa)';
else if VAR5='茭白筍' then BOTANICAL_NAME='Zizania_latifolia';
else if VAR5='結球白菜' then BOTANICAL_NAME='Brassica_pekinensis';
else if VAR5='不結球白菜' then BOTANICAL_NAME='Brassica_chinensis';
else if VAR5='番茄' then BOTANICAL_NAME='Lycopersicon_esculentum';
else if VAR5='蒜頭' then BOTANICAL_NAME='Allium_sativum';
else if VAR5='蔥' then BOTANICAL_NAME='Allium_fistulosum';
else if VAR5='芋' then BOTANICAL_NAME='Colocasia_esculenta';
else if VAR5='薑' then BOTANICAL_NAME='Zingiber_officinale';
else if VAR5='西瓜' then BOTANICAL_NAME='Citrullus_lanatus';
else if VAR5='香瓜' then BOTANICAL_NAME='Cucumis_melo';
else if VAR5='草莓' then BOTANICAL_NAME='Fragaria_spp.';
else if VAR5='花椰菜' then BOTANICAL_NAME='Brassica_oleracea (var. botrytis)';
else if VAR5='胡瓜' then BOTANICAL_NAME='Cucumis_sativus';
else if VAR5='冬瓜' then BOTANICAL_NAME='Benincasa_pruriens';
else if VAR5='苦瓜' then BOTANICAL_NAME='Momordica_charantia';
else if VAR5='茄子' then BOTANICAL_NAME='Solanum_melongena';
else if VAR5='菜豆' then BOTANICAL_NAME='Phaseolus_vulgaris';
else if VAR5='毛豆' then BOTANICAL_NAME='Glycine_max';
else if VAR5='豌豆(荷蘭豆)' then BOTANICAL_NAME='Pisum_sativum';
else if VAR5='番椒' then BOTANICAL_NAME='Piper_nigrum';
else if VAR5='絲瓜' then BOTANICAL_NAME='Luffa_cylindrica ';
else if VAR5='香蕉' then BOTANICAL_NAME='Musa_sapientum';
else if VAR5='鳳梨' then BOTANICAL_NAME='Ananas_comosus';
else if VAR5='椪柑' then BOTANICAL_NAME='Citrus_poonensis';
else if VAR5='桶柑' then BOTANICAL_NAME='Citrus_tankan';
else if VAR5='柳橙' then BOTANICAL_NAME='Citrus_sinensis';
else if VAR5='文旦柚' then BOTANICAL_NAME='Citrus_grandis (Osbeck cv.)';
else if VAR5='柚' then BOTANICAL_NAME='Citrus_grandis';
else if VAR5='檸檬' then BOTANICAL_NAME='Citrus_limon';
else if VAR5='芒果' then BOTANICAL_NAME='Mangifera_indica';
else if VAR5='龍眼' then BOTANICAL_NAME='Dimocarpus_longan';
else if VAR5='檳榔' then BOTANICAL_NAME='Areca_catechu';
else if VAR5='番石榴' then BOTANICAL_NAME='Psidium_guajava';
else if VAR5='李' then BOTANICAL_NAME='Prunus_domestica';
else if VAR5='桃' then BOTANICAL_NAME='Prunus_persica';
else if VAR5='柿' then BOTANICAL_NAME='Diospyros_kaki';
else if VAR5='木瓜' then BOTANICAL_NAME='Carica_papaya';
else if VAR5='蓮霧' then BOTANICAL_NAME='Syzygium_samarangense';
else if VAR5='葡萄' then BOTANICAL_NAME='Vitis_vinifera';
else if VAR5='枇杷' then BOTANICAL_NAME='Eriobotrya_japonica';
else if VAR5='梅' then BOTANICAL_NAME='Prunus_mume';
else if VAR5='荔枝' then BOTANICAL_NAME='Litchi_chinensis';
else if VAR5='楊桃' then BOTANICAL_NAME='Averrhoa_carambola';
else if VAR5='梨' then BOTANICAL_NAME='Pyrus_pyrifolia';
else if VAR5='蘋果' then BOTANICAL_NAME='Malus_sylvestris';
else if VAR5='棗' then BOTANICAL_NAME='Ziziphus_mauritiana';
else if VAR5='番荔枝' then BOTANICAL_NAME='Annona_Squamosa';
else if VAR5='百香果' then BOTANICAL_NAME='Passiflora_edulis';
else if VAR5='可可椰子' then BOTANICAL_NAME='Cocos_nucifera';
else if VAR5='山藥' then BOTANICAL_NAME='Dioscorea_spp.';
else if VAR5='菊花' then BOTANICAL_NAME='Dendranthema_morifolium';
else if VAR5='唐菖蒲' then BOTANICAL_NAME='Gladiolus_hybridus';
else if VAR5='洋桔梗' then BOTANICAL_NAME='Eustoma_grandiflorm';
else if VAR5='玫瑰' then BOTANICAL_NAME='Rose_spp.';
else if VAR5='馬鈴薯' then BOTANICAL_NAME='Solamum_tuberosum';
else if VAR5='菸草' then BOTANICAL_NAME='Nicotiana_tabacum';

if VAR5 in ('其他雜糧','水稻','秧苗','硬質玉米','食用玉米','飼料玉米','甘藷',
'落花生','紅豆','胡麻','生食甘蔗','蘆筍','韭菜','金針菜','洋蔥','蘿蔔','胡蘿蔔','茭白筍',
'甘藍','結球白菜','不結球白菜','番茄','蒜頭','蔥','芋','西瓜','香瓜','草莓','花椰菜','胡瓜',
'冬瓜','苦瓜','茄子','菜豆','毛豆','豌豆(荷蘭豆)','豌豆(荷蘭豆) Peas','番椒','絲瓜','蔬菜',
'山藥','馬鈴薯','太空包香菇','洋菇','菸草','洋桔梗','唐菖蒲','菊花','玫瑰','牧草') then CROP_TYPE='Temporary';
else if VAR5 in ('其他特作','其他青果','苗圃') then CROP_TYPE=' ';
else CROP_TYPE='Permanent';


if VAR5 in ('落花生','胡麻','可可椰子','毛豆') then CROP_GROUP='Oilseed_Crops_Oleaginous_Fruits';
else if VAR5 in ('茶','薑','番椒') then CROP_GROUP='Stimulant_Spice_Aromatic_Crops';
else if VAR5 in ('水稻','食用玉米','硬質玉米','飼料玉米','秧苗') then CROP_GROUP='Cereals';
else if VAR5 in ('甘藷','芋','山藥','馬鈴薯') then CROP_GROUP='Root_Tuber_Crops';
else if VAR5 in ('紅豆','菜豆','豌豆(荷蘭豆)','豌豆(荷蘭豆) Peas') then CROP_GROUP='Leguminous_Crops';
else if VAR5 in ('生食甘蔗') then CROP_GROUP='Sugar_Crops';
else if VAR5 in ('蘆筍','韭菜','竹筍','金針菜','洋蔥','蘿蔔','胡蘿蔔',
'茭白筍','甘藍','結球白菜','不結球白菜','番茄','蒜頭','蔥','花椰菜',
'胡瓜','冬瓜','苦瓜','茄子','絲瓜','蔬菜','太空包香菇','洋菇','西瓜','香瓜') then CROP_GROUP='Vegetables_Melons';
else if VAR5 in ('草莓','香蕉','鳳梨','椪柑','桶柑','柳橙',
'文旦柚','柚','檸檬','其他柑桔','芒果','龍眼','番石榴','檳榔',
'李','桃','柿','木瓜','蓮霧','葡萄','枇杷','荔枝','梅','楊桃','梨','蘋果',
'棗','番荔枝','百香果','其他青果') then CROP_GROUP='Fruits_Nuts';
else if VAR5 in ('牧草','菊花','唐菖蒲','洋桔梗','玫瑰','其他花卉','苗圃',
'其他特作','菸草')
then CROP_GROUP='Other_Crops';

if VAR5 in ('金針菜','洋蔥','蘿蔔','胡蘿蔔','茭白筍','蒜頭') then CROP_CLASS='Root_Bulb_Tuberous_Vegetables';
else if VAR5 in ('香蕉','鳳梨','芒果','龍眼','番石榴',
'木瓜','蓮霧','荔枝','楊桃','番荔枝','百香果','柿') then CROP_CLASS='Tropical_Subtropical_Fruits';
else if VAR5 in ('茶') then CROP_CLASS='Stimulant_Crops';
else if VAR5 in ('薑','番椒') then CROP_CLASS='Spice_Aromatic_Crops';
else if VAR5 in ('蔥','蘆筍','韭菜','竹筍','甘藍','結球白菜','不結球白菜','蔥','花椰菜','蔬菜')
then CROP_CLASS='Leafy_Stem_Vegetables';
else if VAR5 in ('胡瓜','冬瓜','苦瓜','茄子','絲瓜','番茄') then CROP_CLASS='Fruit-bearing_Vegetables';
else if VAR5 in ('椪柑','桶柑','柳橙','文旦柚','柚','檸檬','其他柑桔') then CROP_CLASS='Citrus_Fruits';
else if VAR5 in ('葡萄') then CROP_CLASS='Grapes';
else if VAR5 in ('草莓') then CROP_CLASS='Berries';
else if VAR5 in ('李','桃','梅','梨','蘋果','棗','枇杷') then CROP_CLASS='Pome_Stone_Fruits';
else if VAR5 in ('其他青果') then CROP_CLASS='Others_Fruits';
else if VAR5 in ('牧草') then CROP_CLASS='Grasses_Other_Fodder_Crops';
else if VAR5 in ('菊花','唐菖蒲','洋桔梗','玫瑰','其他花卉') then CROP_CLASS='Flower';
else if VAR5 in ('苗圃','其他特作') then CROP_CLASS='Others_Crops';
else if VAR5 in ('太空包香菇','洋菇') then CROP_CLASS='Mushrooms_Truffles';
else if VAR5='菸草' then CROP_CLASS='Tobacco';
else if VAR5='落花生' then CROP_CLASS='Groundnuts';
else if VAR5='胡麻' then CROP_CLASS='Other_Temporary_Oilseed_Crops';
else if VAR5 in ('西瓜','香瓜') then CROP_CLASS='Melons';
else if VAR5 in ('檳榔') then CROP_CLASS='Nuts';
else if VAR5 in ('可可椰子') then CROP_CLASS='Permanent_oilseed_crops';
else if VAR5 in ('毛豆') then CROP_CLASS='Soya_Beans';
else if VAR5 in ('紅豆') then CROP_CLASS='Leguminous_crops';
else if VAR5 in ('菜豆') then CROP_CLASS='Beans';
else if VAR5 in ('食用玉米','硬質玉米','飼料玉米') then CROP_CLASS='Maize';
else if VAR5 in ('豌豆(荷蘭豆)','豌豆(荷蘭豆) Peas') then CROP_CLASS='Peas';
else if VAR5 in ('馬鈴薯') then CROP_CLASS='Potatoes';
else if VAR5 in ('水稻','秧苗') then CROP_CLASS='Rice';
else if VAR5 in ('生食甘蔗') then CROP_CLASS='Sugar_cane';
else if VAR5 in ('甘藷') then CROP_CLASS='Sweet_potatoes';
else if VAR5 in ('山藥') then CROP_CLASS='Yams';
else if VAR5 in ('芋') then CROP_CLASS='Taro';

EST_LOSS_V=EST_LOSS_V*0.033;/*exchange rate 2023/03/22*/

keep YEAR MONTH COUNTY DISASTER CROP_TYPE CROP_GROUP CROP_CLASS CROP
FIELD_AREA DAMAGED_PERCENTAGE DAMAGED_AREA EST_LOSS_Q
EST_LOSS_V BOTANICAL_NAME;

run;
%mend;
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d110,110);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d109,109);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d108,108);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d107,107);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d106,106);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d105,105);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d104,104);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d103,103);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d102,102);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d101,101);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d100,100);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d99,99);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d98,98);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d97,97);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d96,96);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d95,95);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d94,94);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d93,93);
%csv_data(D:\投稿\水稻坪割資料\data\災害資料\csv\d92,92);


data all;set damage.d92-damage.d110;run;
proc sort data=all out=all1 nodupkey;by YEAR DISASTER;run;
data all1;set all1;
by YEAR DISASTER;
format n z3.;
retain n 0;
n=n+1;
if first.YEAR then n=1;
NO=put(n,z3.);
DISASTER_NO=trim(YEAR)||trim(NO);
run;

data alld;
format START mmddyy10. END mmddyy10. EVENT_NAME $20. 
CROP_DISASTER1 $30. CROP_DISASTER2 $30.;
set all1;
/*crop disaster*/
if find(DISASTER,"乾旱")^=0 and find(DISASTER,"高溫")^=0 then CROP_DISASTER1="Drought";
if find(DISASTER,"乾旱")^=0 and find(DISASTER,"高溫")^=0 then CROP_DISASTER2="High_temperature";
if find(DISASTER,"冰雹")^=0 and find(DISASTER,"龍捲風")^=0 then CROP_DISASTER1="Tornado";
if find(DISASTER,"冰雹")^=0 and find(DISASTER,"龍捲風")^=0 then CROP_DISASTER2="Hail";
if find(DISASTER,"強風")^=0 and find(DISASTER,"豪雨")^=0 then CROP_DISASTER1="Strong_wind";
if find(DISASTER,"強風")^=0 and find(DISASTER,"豪雨")^=0 then CROP_DISASTER2="Extremely_heavy_rain";
if find(DISASTER,"強風")^=0 and find(DISASTER,"冰雹")^=0 then CROP_DISASTER1="Strong_wind";
if find(DISASTER,"強風")^=0 and find(DISASTER,"冰雹")^=0 then CROP_DISASTER2="Hail";
if find(DISASTER,"瞬間風")^=0 and find(DISASTER,"高溫")^=0 then CROP_DISASTER1="Gust_wind";
if find(DISASTER,"瞬間風")^=0 and find(DISASTER,"高溫")^=0 then CROP_DISASTER2="High_temperature";
if find(DISASTER,"泰利")^=0 and find(DISASTER,"豪雨")^=0 then CROP_DISASTER1="Typhoon";
if find(DISASTER,"泰利")^=0 and find(DISASTER,"豪雨")^=0 then CROP_DISASTER2="Extremely_heavy_rain";

if CROP_DISASTER1=" " and find(DISASTER,"豪雨")^=0 then CROP_DISASTER1="Extremely_heavy_rain";
else if CROP_DISASTER1=" " and find(DISASTER,"颱風")^=0 then CROP_DISASTER1="Typhoon";
else if CROP_DISASTER1=" " and find(DISASTER,"寒流")^=0 then CROP_DISASTER1="Cold_wave";
else if CROP_DISASTER1=" " and find(DISASTER,"地震")^=0 then CROP_DISASTER1="Earthquake";
else if CROP_DISASTER1=" " and find(DISASTER,"強風")^=0 then CROP_DISASTER1="Strong_wind";
else if CROP_DISASTER1=" " and find(DISASTER,"豪雨")^=0 then CROP_DISASTER1="Extremely_heavy_rain";
else if CROP_DISASTER1=" " and find(DISASTER,"雷雨")^=0 then CROP_DISASTER1="Thunderstorm";
else if CROP_DISASTER1=" " and find(DISASTER,"低溫")^=0 then CROP_DISASTER1="Low_temperature";
else if CROP_DISASTER1=" " and find(DISASTER,"冰雹")^=0 then CROP_DISASTER1="Hail";
else if CROP_DISASTER1=" " and find(DISASTER,"龍捲風")^=0 then CROP_DISASTER1="Tornado";
else if CROP_DISASTER1=" " and find(DISASTER,"熱帶低壓")^=0 then CROP_DISASTER1="Tropical_depression";
else if CROP_DISASTER1=" " and find(DISASTER,"西南氣流")^=0 then CROP_DISASTER1="Southwesterly_flow";
else if CROP_DISASTER1=" " and find(DISASTER,"乾旱")^=0 then CROP_DISASTER1="Drought";
else if CROP_DISASTER1=" " and find(DISASTER,"旱災")^=0 then CROP_DISASTER1="Drought";
else if CROP_DISASTER1=" " and find(DISASTER,"高溫")^=0 then CROP_DISASTER1="High_temperature";
else if CROP_DISASTER1=" " and find(DISASTER,"雨害")^=0 then CROP_DISASTER1="Rain_damage";
else if CROP_DISASTER1=" " and find(DISASTER,"霪雨")^=0 then CROP_DISASTER1="Continuous_rain";
else if CROP_DISASTER1=" " and find(DISASTER,"鋒面")^=0 then CROP_DISASTER1="Front";
else if CROP_DISASTER1=" " and find(DISASTER,"氣候異常")^=0 then CROP_DISASTER1="Unusual_climate";
else if CROP_DISASTER1=" " and find(DISASTER,"大雨")^=0 then CROP_DISASTER1="Heavy_rain";
else if CROP_DISASTER1=" " and find(DISASTER,"焚風")^=0 then CROP_DISASTER1="Foehn";
else if CROP_DISASTER1=" " and find(DISASTER,"霜害")^=0 then CROP_DISASTER1="Frost";
else if CROP_DISASTER1=" " and find(DISASTER,"怪風")^=0 then CROP_DISASTER1="Unusual_wind";
else if CROP_DISASTER1=" " and find(DISASTER,"瞬間風")^=0 then CROP_DISASTER1="Gust_wind";
else if CROP_DISASTER1=" " and find(DISASTER,"高接梨穗嫁接")^=0 then CROP_DISASTER1="Grafting_pear_damage";
else if CROP_DISASTER1=" " and find(DISASTER,"病蟲害")^=0 then CROP_DISASTER1="Pest";
else if CROP_DISASTER1=" " and find(DISASTER,"震災")^=0 then CROP_DISASTER1="Earthquake";

/*disaster group*/
DISASTER_GROUP='Natural_disaster';

/*disaster sub-group*/
if CROP_DISASTER1 in ('Drought') then DISASTER_SUB_GROUP1='Climatological';
else if CROP_DISASTER1 in ('Earthquake') then DISASTER_SUB_GROUP1='Geophysical';
else if CROP_DISASTER1 in ('Pest') then DISASTER_SUB_GROUP1='Biological';
else if CROP_DISASTER1 not in (' ','Grafting_pear_damage','Foehn','Unusual_climate') 
then DISASTER_SUB_GROUP1='Meteorological';

if CROP_DISASTER2 in ('Drought') then DISASTER_SUB_GROUP2='Climatological';
else if CROP_DISASTER2 in ('Earthquake') then DISASTER_SUB_GROUP2='Geophysical';
else if CROP_DISASTER2 in ('Pest') then DISASTER_SUB_GROUP2='Biological';
else if CROP_DISASTER2 not in (' ','Grafting_pear_damage','Foehn','Unusual_climate') 
then DISASTER_SUB_GROUP2='Meteorological';

/*disaster main type*/
if CROP_DISASTER1 in ('Cold_wave','Front','Frost','High_temperature','Low_temperature')
then DISASTER_MAIN_TYPE1='Extreme_temperature';
else if CROP_DISASTER1 in ('Earthquake') then DISASTER_MAIN_TYPE1='Earthquake';
else if CROP_DISASTER1 in ('Drought') then DISASTER_MAIN_TYPE1='Drought';
else if CROP_DISASTER1 not in (' ','Grafting_pear_damage','Foehn','Unusual_climate','Pest') 
then DISASTER_MAIN_TYPE1='Storm';

if CROP_DISASTER2 in ('Cold_wave','Front','Frost','High_temperature','Low_temperature')
then DISASTER_MAIN_TYPE2='Extreme_temperature';
else if CROP_DISASTER2 in ('Earthquake') then DISASTER_MAIN_TYPE2='Earthquake';
else if CROP_DISASTER2 in ('Drought') then DISASTER_MAIN_TYPE2='Drought';
else if CROP_DISASTER2 not in (' ','Grafting_pear_damage','Foehn','Unusual_climate','Pest') 
then DISASTER_MAIN_TYPE2='Storm';

/*disaster sub-type*/
if CROP_DISASTER1 in ('Frost') then DISASTER_SUB_TYPE1='Severe_winter_conditions';
else if CROP_DISASTER1 in ('Earthquake') then DISASTER_SUB_TYPE1='Ground_movement';
else if CROP_DISASTER1 in ('Cold_wave','Front','Low_temperature') then DISASTER_SUB_TYPE1='Cold_wave';
else if CROP_DISASTER1 in ('High_temperature') then DISASTER_SUB_TYPE1='Heat_wave';
else if CROP_DISASTER1 in ('Tropical_depression','Typhoon') then DISASTER_SUB_TYPE1='Tropical_storm';
else if CROP_DISASTER1 not in (' ','Grafting_pear_damage','Foehn','Unusual_climate','Pest','Drought')
then DISASTER_SUB_TYPE1='Convective_storm';

if CROP_DISASTER2 in ('Frost') then DISASTER_SUB_TYPE2='Severe_winter_conditions';
else if CROP_DISASTER2 in ('Earthquake') then DISASTER_SUB_TYPE2='Ground_movement';
else if CROP_DISASTER2 in ('Cold_wave','Front','Low_temperature') then DISASTER_SUB_TYPE2='Cold_wave';
else if CROP_DISASTER2 in ('High_temperature') then DISASTER_SUB_TYPE2='Heat_wave';
else if CROP_DISASTER2 in ('Tropical_depression','Typhoon') then DISASTER_SUB_TYPE2='Tropical_storm';
else if CROP_DISASTER2 not in (' ','Grafting_pear_damage','Foehn','Unusual_climate','Pest','Drought')
then DISASTER_SUB_TYPE2='Convective_storm';

/*disaster sub-sub-type*/
if CROP_DISASTER1 in ('Thunderstorm') then DISASTER_SUB_SUB_TYPE1='Thunderstorm';
else if CROP_DISASTER1 in ('Tornado') then DISASTER_SUB_SUB_TYPE1='Tornado';
else if CROP_DISASTER1 in ('Frost') then DISASTER_SUB_SUB_TYPE1='Frost';
else if CROP_DISASTER1 in ('Hail') then DISASTER_SUB_SUB_TYPE1='Hail';
else if CROP_DISASTER1 in ('Gust_wind','Strong_wind','Unusual_wind') then DISASTER_SUB_SUB_TYPE1='Wind';
else if CROP_DISASTER1 not in (' ','Grafting_pear_damage','Foehn','Unusual_climate','Pest','Drought',
'Cold_wave','Low_temperature','Earthquake','Front','High_temperature','Tropical_depression','Typhoon')
then DISASTER_SUB_SUB_TYPE1='Rain';

if CROP_DISASTER2 in ('Thunderstorm') then DISASTER_SUB_SUB_TYPE2='Thunderstorm';
else if CROP_DISASTER2 in ('Tornado') then DISASTER_SUB_SUB_TYPE2='Tornado';
else if CROP_DISASTER2 in ('Frost') then DISASTER_SUB_SUB_TYPE2='Frost';
else if CROP_DISASTER2 in ('Hail') then DISASTER_SUB_SUB_TYPE2='Hail';
else if CROP_DISASTER2 in ('Gust_wind','Strong_wind','Unusual_wind') then DISASTER_SUB_SUB_TYPE2='Wind';
else if CROP_DISASTER2 not in (' ','Grafting_pear_damage','Foehn','Unusual_climate','Pest','Drought',
'Cold_wave','Low_temperature','Earthquake','Front','High_temperature','Tropical_depression','Typhoon')
then DISASTER_SUB_SUB_TYPE2='Rain';

/*event start date from original data*/
if substr(DISASTER,1,16)='5月下旬至6月上旬' then START=mdy(05,21,YEAR);
else if substr(DISASTER,1,7)='9月30日' then START=mdy(substr(DISASTER,1,1),substr(DISASTER,4,2),YEAR);
else if substr(DISASTER,1,23)='109年1230及110年1月上旬' then START=mdy(12,30,2020);
else if substr(DISASTER,1,7)='11~12月' then START=mdy(11,01,YEAR);
else if substr(DISASTER,1,5)='1-2月' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,5)='1~2月' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,5)='1~3月' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,6)='1～2月' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,5)='2~3月' then START=mdy(02,01,YEAR);
else if substr(DISASTER,1,5)='3~4月' then START=mdy(03,01,YEAR);
else if substr(DISASTER,1,5)='3~5月' then START=mdy(03,01,YEAR);
else if substr(DISASTER,1,6)='3、4月' then START=mdy(03,01,YEAR);
else if substr(DISASTER,1,8)='3月至4月' then START=mdy(03,01,YEAR);
else if substr(DISASTER,1,5)='4~5月' then START=mdy(04,01,YEAR);
else if substr(DISASTER,1,5)='4~6月' then START=mdy(04,01,YEAR);
else if substr(DISASTER,1,6)='4月418' then START=mdy(04,18,YEAR);
else if substr(DISASTER,1,5)='6~7月' then START=mdy(06,01,YEAR);
else if substr(DISASTER,1,5)='6~8月' then START=mdy(06,01,YEAR);
else if substr(DISASTER,1,5)='7~8月' then START=mdy(07,01,YEAR);
else if substr(DISASTER,1,5)='8~9月' then START=mdy(08,01,YEAR);
else if substr(DISASTER,5,5)='1-3月' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,6)='9~10月' then START=mdy(09,01,YEAR);
else if substr(DISASTER,1,10)='三月至四月' then START=mdy(03,01,YEAR);
else if substr(DISASTER,5,8)='３至４月' then START=mdy(03,01,YEAR);

else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('一月') then START=mdy('01','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('1月') then START=mdy('01','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('二月') then START=mdy('02','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('2月') then START=mdy('02','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('三月') then START=mdy('03','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('3月') then START=mdy('03','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('四月') then START=mdy('04','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('4月') then START=mdy('04','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('五月') then START=mdy('05','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('5月') then START=mdy('05','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('六月') then START=mdy('06','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('6月') then START=mdy('06','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('七月') then START=mdy('07','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('7月') then START=mdy('07','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('八月') then START=mdy('08','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('8月') then START=mdy('08','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('九月') then START=mdy('09','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('9月') then START=mdy('09','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('十月','10月') then START=mdy('10','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,6) in ('十一月') then START=mdy('11','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('11月') then START=mdy('11','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,6) in ('十二月') then START=mdy('12','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('12月') then START=mdy('12','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年1月') then START=mdy('01','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,6) in ('年12月') then START=mdy('12','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年2月') then START=mdy('02','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年7月') then START=mdy('07','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年8月') then START=mdy('08','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年3月') then START=mdy('03','01',YEAR);
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,6) in ('年４月') then START=mdy('04','01',YEAR);

else if find(DISASTER,"上旬")^=0 and find(DISASTER,"1月")^=0 then START=mdy(01,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"1月")^=0 then START=mdy(01,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"1月")^=0 then START=mdy(01,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"一月")^=0 then START=mdy(01,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"一月")^=0 then START=mdy(01,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"一月")^=0 then START=mdy(01,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"2月")^=0 then START=mdy(01,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"2月")^=0 then START=mdy(01,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"2月")^=0 then START=mdy(01,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"二月")^=0 then START=mdy(02,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"二月")^=0 then START=mdy(02,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"二月")^=0 then START=mdy(02,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"3月")^=0 then START=mdy(03,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"3月")^=0 then START=mdy(03,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"3月")^=0 then START=mdy(03,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"三月")^=0 then START=mdy(03,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"三月")^=0 then START=mdy(03,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"三月")^=0 then START=mdy(03,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"4月")^=0 then START=mdy(04,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"4月")^=0 then START=mdy(04,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"4月")^=0 then START=mdy(04,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"四月")^=0 then START=mdy(04,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"四月")^=0 then START=mdy(04,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"四月")^=0 then START=mdy(04,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"5月")^=0 then START=mdy(05,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"5月")^=0 then START=mdy(05,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"5月")^=0 then START=mdy(05,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"五月")^=0 then START=mdy(05,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"五月")^=0 then START=mdy(05,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"五月")^=0 then START=mdy(05,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"6月")^=0 then START=mdy(06,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"6月")^=0 then START=mdy(06,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"6月")^=0 then START=mdy(06,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"六月")^=0 then START=mdy(06,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"六月")^=0 then START=mdy(06,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"六月")^=0 then START=mdy(06,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"7月")^=0 then START=mdy(07,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"7月")^=0 then START=mdy(07,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"7月")^=0 then START=mdy(07,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"七月")^=0 then START=mdy(07,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"七月")^=0 then START=mdy(07,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"七月")^=0 then START=mdy(07,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"8月")^=0 then START=mdy(08,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"8月")^=0 then START=mdy(08,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"8月")^=0 then START=mdy(08,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"八月")^=0 then START=mdy(08,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"八月")^=0 then START=mdy(08,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"八月")^=0 then START=mdy(08,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"9月")^=0 then START=mdy(09,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"9月")^=0 then START=mdy(09,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"9月")^=0 then START=mdy(09,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"九月")^=0 then START=mdy(09,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"九月")^=0 then START=mdy(09,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"九月")^=0 then START=mdy(09,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"10月")^=0 then START=mdy(10,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"10月")^=0 then START=mdy(10,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"10月")^=0 then START=mdy(10,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"十月")^=0 then START=mdy(10,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"十月")^=0 then START=mdy(10,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"十月")^=0 then START=mdy(10,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"11月")^=0 then START=mdy(11,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"11月")^=0 then START=mdy(11,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"11月")^=0 then START=mdy(11,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"十一月")^=0 then START=mdy(11,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"十一月")^=0 then START=mdy(11,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"十一月")^=0 then START=mdy(11,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"12月")^=0 then START=mdy(12,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"12月")^=0 then START=mdy(12,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"12月")^=0 then START=mdy(12,21,YEAR);
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"十二月")^=0 then START=mdy(12,01,YEAR);
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"十二月")^=0 then START=mdy(12,11,YEAR);
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"十二月")^=0 then START=mdy(12,21,YEAR);


else if substr(DISASTER,1,4)='0112' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0129' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0206' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0213' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0217' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0331' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0406' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0413' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0417' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0423' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0424' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0426' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0427' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0502' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,3)='516' then START=mdy(substr(DISASTER,1,1),substr(DISASTER,2,2),YEAR);
else if substr(DISASTER,1,4)='0517' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0524' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0529' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0601' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0603' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0608' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0611' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0613' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0701' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0702' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0715' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0718' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0719' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0720' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0812' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0813' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0823' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0826' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='0915' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='1011' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if substr(DISASTER,1,4)='1230' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);

/*event start date from NCDR*/
if DISASTER='0517豪雨' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0601豪雨' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0611豪雨' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0613豪雨' and YEAR=2017 then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0613豪雨' and YEAR=2018 then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0812豪雨' then START=mdy(substr(DISASTER,1,2),10,YEAR);
else if DISASTER='0823熱帶低壓水災' then START=mdy(substr(DISASTER,1,2),24,YEAR);
else if DISASTER='0826西南氣流豪雨' then START=mdy(substr(DISASTER,1,2),25,YEAR);
else if DISASTER='1011豪雨' then START=mdy(substr(DISASTER,1,2),11,YEAR);
else if DISASTER='10月豪雨' and YEAR=2011 then START=mdy(substr(DISASTER,1,2),01,YEAR);
else if DISASTER='4月豪雨' and YEAR=2006 then START=mdy(04,10,YEAR);
else if DISASTER='5月中旬豪雨' and YEAR=2012 then START=mdy(05,20,YEAR);
else if DISASTER='6月豪雨及泰利颱風' then START=mdy(06,10,YEAR);
else if DISASTER='9月豪雨' and YEAR=2004 then START=mdy(09,07,YEAR);
else if DISASTER='9月下旬豪雨' and YEAR=2010 then START=mdy(09,24,YEAR);
else if DISASTER='五月豪雨' and YEAR=2020 then START=mdy(05,21,YEAR);
else if DISASTER='10月柯羅莎颱風' then START=mdy(10,04,YEAR);
else if DISASTER='11月米塔颱風' then START=mdy(11,26,YEAR);
else if DISASTER='7月昌鴻颱風' then START=mdy(07,09,YEAR);
else if DISASTER='8月帕布及梧提颱風' then START=mdy(08,07,YEAR);
else if DISASTER='8月聖帕颱風' then START=mdy(08,16,YEAR);
else if DISASTER='95年凱米颱風' then START=mdy(07,23,YEAR);
else if DISASTER='95年碧利斯颱風' then START=mdy(07,12,YEAR);
else if DISASTER='95年寶發颱風' then START=mdy(08,07,YEAR);
else if DISASTER='97年卡玫基颱風' then START=mdy(07,16,YEAR);
else if DISASTER='97年辛樂克颱風' then START=mdy(09,11,YEAR);
else if DISASTER='97年哈格比焚風' then START=mdy(09,21,YEAR);
else if DISASTER='97年鳳凰颱風' then START=mdy(07,26,YEAR);
else if DISASTER='97年薔蜜颱風' then START=mdy(09,27,YEAR);
else if DISASTER='98年芭瑪颱風' then START=mdy(10,03,YEAR);
else if DISASTER='98年莫拉克颱風' then START=mdy(08,05,YEAR);
else if DISASTER='98年蓮花颱風' then START=mdy(06,19,YEAR);
else if DISASTER='9月韋帕颱風' then START=mdy(09,17,YEAR);
else if DISASTER='九月杜鵑颱風' then START=mdy(08,31,YEAR);
else if DISASTER='八月莫拉克颱風' then START=mdy(08,02,YEAR);
else if DISASTER='十一月米勒颱風' then START=mdy(11,02,YEAR);
else if DISASTER='凡那比颱風' then START=mdy(09,18,YEAR);
else if DISASTER='山竹颱風' then START=mdy(09,14,YEAR);
else if DISASTER='丹娜絲颱風' then START=mdy(07,17,YEAR);
else if DISASTER='天兔颱風' then START=mdy(09,20,YEAR);
else if DISASTER='天秤颱風' then START=mdy(08,21,YEAR);
else if DISASTER='天鴿颱風' then START=mdy(08,21,YEAR);
else if DISASTER='尼伯特颱風' then START=mdy(07,06,YEAR);
else if DISASTER='尼莎暨海棠颱風' then START=mdy(07,28,YEAR);
else if DISASTER='白鹿颱風' then START=mdy(08,23,YEAR);
else if DISASTER='米克拉颱風' then START=mdy(08,10,YEAR);
else if DISASTER='米塔颱風' then START=mdy(09,29,YEAR);
else if DISASTER='米雷颱風外圍環流' then START=mdy(06,24,YEAR);
else if DISASTER='艾利颱風' then START=mdy(08,23,YEAR);
else if DISASTER='利奇馬颱風' then START=mdy(08,07,YEAR);
else if DISASTER='杜鵑颱風' then START=mdy(09,27,YEAR);
else if DISASTER='南修及萊羅克颱風' then START=mdy(08,30,YEAR);
else if DISASTER='南瑪都颱風' and YEAR=2004 then START=mdy(12,03,YEAR);
else if DISASTER='南瑪都颱風' and YEAR=2011 then START=mdy(08,27,YEAR);
else if DISASTER='哈吉貝颱風外圍環流' then START=mdy(06,15,YEAR);
else if DISASTER='哈格比颱風' then START=mdy(08,02,YEAR);
else if DISASTER='珍珠颱風' then START=mdy(05,16,YEAR);
else if DISASTER='桑達颱風' then START=mdy(05,27,YEAR);
else if DISASTER='泰利颱風' then START=mdy(08,30,YEAR);
else if DISASTER='海馬颱風' then START=mdy(09,12,YEAR);
else if DISASTER='海棠颱風' then START=mdy(07,16,YEAR);
else if DISASTER='納坦颱風' then START=mdy(10,23,YEAR);
else if DISASTER='閃電颱風' then START=mdy(11,05,YEAR);
else if DISASTER='馬勒卡颱風' then START=mdy(09,16,YEAR);
else if DISASTER='馬莎颱風' then START=mdy(08,03,YEAR);
else if DISASTER='康森颱風' then START=mdy(06,07,YEAR);
else if DISASTER='敏督利颱風' then START=mdy(06,28,YEAR);
else if DISASTER='梅姬颱風' and YEAR=2010 then START=mdy(10,21,YEAR);
else if DISASTER='梅姬颱風' and YEAR=2016 then START=mdy(09,26,YEAR);
else if DISASTER='莫蘭蒂颱風' and YEAR=2010 then START=mdy(09,09,YEAR);
else if DISASTER='莫蘭蒂颱風' and YEAR=2016 then START=mdy(09,13,YEAR);
else if DISASTER='麥德姆颱風' then START=mdy(07,21,YEAR);
else if DISASTER='圓規颱風' then START=mdy(10,10,YEAR);
else if DISASTER='瑪莉亞颱風' then START=mdy(07,09,YEAR);
else if DISASTER='鳳凰颱風' then START=mdy(09,19,YEAR);
else if DISASTER='潭美及康芮颱風' then START=mdy(08,20,YEAR);
else if DISASTER='龍王颱風' then START=mdy(09,30,YEAR);
else if DISASTER='璨樹颱風' then START=mdy(09,10,YEAR);
else if DISASTER='蘇力颱風' then START=mdy(07,11,YEAR);
else if DISASTER='蘇拉颱風' then START=mdy(07,30,YEAR);
else if DISASTER='蘇迪勒颱風' then START=mdy(08,06,YEAR);
else if substr(DISASTER,3,6)='花颱風' then START=mdy(07,30,YEAR);


/*event end date*/
if substr(DISASTER,1,7)='9月30日' then END=START;
else if substr(DISASTER,1,16)='5月下旬至6月上旬' then END=mdy(06,10,YEAR);
else if substr(DISASTER,1,23)='109年1230及110年1月上旬' then END=mdy(01,10,2021);
else if substr(DISASTER,1,7)='11~12月' then END=mdy(12,31,YEAR);
else if substr(DISASTER,1,5)='1-2月' then END=intnx('month',mdy(02,01,YEAR),0,'E');
else if substr(DISASTER,1,5)='1~2月' then END=intnx('month',mdy(02,01,YEAR),0,'E');
else if substr(DISASTER,1,5)='1~3月' then END=mdy(03,01,YEAR);
else if substr(DISASTER,1,6)='1～2月' then END=intnx('month',mdy(02,01,YEAR),0,'E');
else if substr(DISASTER,1,5)='2~3月' then END=mdy(03,31,YEAR);
else if substr(DISASTER,1,5)='3~4月' then END=mdy(04,30,YEAR);
else if substr(DISASTER,1,5)='3~5月' then END=mdy(05,31,YEAR);
else if substr(DISASTER,1,6)='3、4月' then END=mdy(04,30,YEAR);
else if substr(DISASTER,1,8)='3月至4月' then END=mdy(04,30,YEAR);
else if substr(DISASTER,1,5)='4~5月' then END=mdy(05,31,YEAR);
else if substr(DISASTER,1,5)='4~6月' then END=mdy(06,30,YEAR);
else if substr(DISASTER,1,6)='4月418' then END=mdy(04,18,YEAR);
else if substr(DISASTER,1,5)='6~7月' then END=mdy(07,31,YEAR);
else if substr(DISASTER,1,5)='6~8月' then END=mdy(08,31,YEAR);
else if substr(DISASTER,1,5)='7~8月' then END=mdy(08,31,YEAR);
else if substr(DISASTER,1,5)='8~9月' then END=mdy(09,30,YEAR);
else if substr(DISASTER,5,5)='1-3月' then END=mdy(03,31,YEAR);
else if substr(DISASTER,1,6)='9~10月' then END=mdy(10,31,YEAR);
else if substr(DISASTER,1,10)='三月至四月' then END=mdy(04,30,YEAR);
else if substr(DISASTER,5,8)='３至４月' then END=mdy(04,30,YEAR);

else if substr(DISASTER,1,4)='0112' then END=START;
else if substr(DISASTER,1,4)='0129' then END=START;
else if substr(DISASTER,1,4)='0206' then END=START;
else if substr(DISASTER,1,4)='0213' then END=START;
else if substr(DISASTER,1,4)='0217' then END=START;
else if substr(DISASTER,1,4)='0331' then END=START;
else if substr(DISASTER,1,4)='0406' then END=START;
else if substr(DISASTER,1,4)='0413' then END=START;
else if substr(DISASTER,1,4)='0417' then END=START;
else if substr(DISASTER,1,4)='0423' then END=START;
else if substr(DISASTER,1,4)='0424' then END=START;
else if substr(DISASTER,1,4)='0426' then END=START;
else if substr(DISASTER,1,4)='0427' then END=START;
else if substr(DISASTER,1,4)='0502' then END=START;
else if substr(DISASTER,1,4)='0517' then END=START;
else if substr(DISASTER,1,3)='516' then END=START;
else if substr(DISASTER,1,4)='0524' then END=START;
else if substr(DISASTER,1,4)='0529' then END=START;
else if substr(DISASTER,1,4)='0601' then END=START;
else if substr(DISASTER,1,4)='0603' then END=START;
else if substr(DISASTER,1,4)='0608' then END=START;
else if substr(DISASTER,1,4)='0611' then END=START;
else if substr(DISASTER,1,4)='0613' then END=START;
else if substr(DISASTER,1,4)='0701' then END=START;
else if substr(DISASTER,1,4)='0702' then END=START;
else if substr(DISASTER,1,4)='0715' then END=START;
else if substr(DISASTER,1,4)='0718' then END=START;
else if substr(DISASTER,1,4)='0719' then END=START;
else if substr(DISASTER,1,4)='0720' then END=START;
else if substr(DISASTER,1,4)='0812' then END=START;
else if substr(DISASTER,1,4)='0813' then END=START;
else if substr(DISASTER,1,4)='0823' then END=START;
else if substr(DISASTER,1,4)='0826' then END=START;
else if substr(DISASTER,1,4)='0915' then END=START;
else if substr(DISASTER,1,4)='1011' then END=START;
else if substr(DISASTER,1,4)='1230' then END=START;

else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('一月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('1月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('二月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('2月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('三月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('3月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('四月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('4月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('五月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('5月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('六月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('6月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('七月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('7月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('八月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('8月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('九月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('9月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('十月','10月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,6) in ('十一月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('11月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,6) in ('十二月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('12月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年1月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,6) in ('年12月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年2月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年7月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年8月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('年3月') then END=intnx('month',START,0,'E');
else if find(DISASTER,"旬")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,6) in ('年４月') then END=intnx('month',START,0,'E');

else if find(DISASTER,"上旬")^=0 and find(DISASTER,"1月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"1月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"1月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"一月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"一月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"一月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"2月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"2月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"2月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"二月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"二月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"二月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"3月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"3月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"3月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"三月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"三月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"三月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"4月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"4月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"4月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"四月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"四月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"四月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"5月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"5月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"5月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"五月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"五月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"五月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"6月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"6月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"6月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"六月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"六月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"六月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"7月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"7月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"7月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"七月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"七月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"七月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"8月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"8月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"8月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"八月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"八月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"八月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"9月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"9月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"9月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"九月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"九月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"九月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"10月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"10月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"10月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"十月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"十月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"十月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"11月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"11月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"11月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"十一月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"十一月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"十一月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"12月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"12月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"12月")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"上旬")^=0 and find(DISASTER,"十二月")^=0 then END=START+9;
else if find(DISASTER,"中旬")^=0 and find(DISASTER,"十二月")^=0 then END=START+9;
else if find(DISASTER,"下旬")^=0 and find(DISASTER,"十二月")^=0 then END=intnx('month',START,0,'E');

/*event end date from NCDR*/
if DISASTER='0517豪雨' then END=mdy(05,20,YEAR);
else if DISASTER='0601豪雨' then END=mdy(06,04,YEAR);
else if DISASTER='0611豪雨' then END=mdy(06,13,YEAR);
else if DISASTER='0613豪雨' and YEAR=2017 then END=mdy(06,18,YEAR);
else if DISASTER='0613豪雨' and YEAR=2018 then END=mdy(06,15,YEAR);
else if DISASTER='0812豪雨' then END=mdy(08,17,YEAR);
else if DISASTER='0823熱帶低壓水災' then END=mdy(08,30,YEAR);
else if DISASTER='0826西南氣流豪雨' then END=mdy(08,26,YEAR);
else if DISASTER='1011豪雨' then END=mdy(10,15,YEAR);
else if DISASTER='10月豪雨' and YEAR=2011 then END=mdy(10,01,YEAR);
else if DISASTER='4月豪雨' and YEAR=2006 then END=mdy(04,11,YEAR);
else if DISASTER='5月中旬豪雨' and YEAR=2012 then END=mdy(05,20,YEAR);
else if DISASTER='6月豪雨及泰利颱風' then END=mdy(06,21,YEAR);
else if DISASTER='9月豪雨' and YEAR=2004 then END=mdy(09,07,YEAR);
else if DISASTER='9月下旬豪雨' and YEAR=2010 then END=mdy(09,24,YEAR);
else if DISASTER='五月豪雨' and YEAR=2020 then END=mdy(05,28,YEAR);
else if DISASTER='10月柯羅莎颱風' then END=mdy(10,07,YEAR);
else if DISASTER='11月米塔颱風' then END=mdy(11,27,YEAR);
else if DISASTER='7月昌鴻颱風' then END=mdy(07,11,YEAR);
else if DISASTER='8月帕布及梧提颱風' then END=mdy(08,09,YEAR);
else if DISASTER='8月聖帕颱風' then END=mdy(08,19,YEAR);
else if DISASTER='95年凱米颱風' then END=mdy(07,26,YEAR);
else if DISASTER='95年碧利斯颱風' then END=mdy(07,15,YEAR);
else if DISASTER='95年寶發颱風' then END=mdy(08,09,YEAR);
else if DISASTER='97年卡玫基颱風' then END=mdy(07,18,YEAR);
else if DISASTER='97年辛樂克颱風' then END=mdy(09,16,YEAR);
else if DISASTER='97年哈格比焚風' then END=mdy(09,23,YEAR);
else if DISASTER='97年鳳凰颱風' then END=mdy(07,29,YEAR);
else if DISASTER='97年薔蜜颱風' then END=mdy(09,29,YEAR);
else if DISASTER='98年芭瑪颱風' then END=mdy(10,06,YEAR);
else if DISASTER='98年莫拉克颱風' then END=mdy(08,10,YEAR);
else if DISASTER='98年蓮花颱風' then END=mdy(06,22,YEAR);
else if DISASTER='9月韋帕颱風' then END=mdy(09,19,YEAR);
else if DISASTER='九月杜鵑颱風' then END=mdy(09,02,YEAR);
else if DISASTER='八月莫拉克颱風' then END=mdy(08,04,YEAR);
else if DISASTER='十一月米勒颱風' then END=mdy(11,03,YEAR);
else if DISASTER='凡那比颱風' then END=mdy(09,20,YEAR);
else if DISASTER='山竹颱風' then END=mdy(09,15,YEAR);
else if DISASTER='丹娜絲颱風' then END=mdy(07,18,YEAR);
else if DISASTER='天兔颱風' then END=mdy(09,22,YEAR);
else if DISASTER='天秤颱風' then END=mdy(08,28,YEAR);
else if DISASTER='天鴿颱風' then END=mdy(08,22,YEAR);
else if DISASTER='尼伯特颱風' then END=mdy(07,09,YEAR);
else if DISASTER='尼莎暨海棠颱風' then END=mdy(07,31,YEAR);
else if DISASTER='白鹿颱風' then END=mdy(08,25,YEAR);
else if DISASTER='米克拉颱風' then END=mdy(08,11,YEAR);
else if DISASTER='米塔颱風' then END=mdy(10,01,YEAR);
else if DISASTER='米雷颱風外圍環流' then END=mdy(06,25,YEAR);
else if DISASTER='艾利颱風' then END=mdy(08,26,YEAR);
else if DISASTER='利奇馬颱風' then END=mdy(08,10,YEAR);
else if DISASTER='杜鵑颱風' then END=mdy(09,29,YEAR);
else if DISASTER='南修及萊羅克颱風' then END=mdy(09,02,YEAR);
else if DISASTER='南瑪都颱風' and YEAR=2004 then END=mdy(12,04,YEAR);
else if DISASTER='南瑪都颱風' and YEAR=2011 then END=mdy(08,31,YEAR);
else if DISASTER='哈吉貝颱風外圍環流' then END=mdy(06,15,YEAR);
else if DISASTER='哈格比颱風' then END=mdy(08,04,YEAR);
else if DISASTER='珍珠颱風' then END=mdy(05,18,YEAR);
else if DISASTER='桑達颱風' then END=mdy(05,28,YEAR);
else if DISASTER='泰利颱風' then END=mdy(09,01,YEAR);
else if DISASTER='海馬颱風' then END=mdy(09,13,YEAR);
else if DISASTER='海棠颱風' then END=mdy(07,20,YEAR);
else if DISASTER='納坦颱風' then END=mdy(10,26,YEAR);
else if DISASTER='閃電颱風' then END=mdy(11,07,YEAR);
else if DISASTER='馬勒卡颱風' then END=mdy(09,18,YEAR);
else if DISASTER='馬莎颱風' then END=mdy(08,06,YEAR);
else if DISASTER='康森颱風' then END=mdy(06,10,YEAR);
else if DISASTER='敏督利颱風' then END=mdy(07,03,YEAR);
else if DISASTER='梅姬颱風' and YEAR=2010 then END=mdy(10,24,YEAR);
else if DISASTER='梅姬颱風' and YEAR=2016 then END=mdy(09,28,YEAR);
else if DISASTER='莫蘭蒂颱風' and YEAR=2010 then END=mdy(09,10,YEAR);
else if DISASTER='莫蘭蒂颱風' and YEAR=2016 then END=mdy(09,15,YEAR);
else if DISASTER='麥德姆颱風' then END=mdy(07,23,YEAR);
else if DISASTER='圓規颱風' then END=mdy(10,14,YEAR);
else if DISASTER='瑪莉亞颱風' then END=mdy(07,11,YEAR);
else if DISASTER='鳳凰颱風' then END=mdy(09,22,YEAR);
else if DISASTER='潭美及康芮颱風' then END=mdy(08,29,YEAR);
else if DISASTER='龍王颱風' then END=mdy(10,03,YEAR);
else if DISASTER='璨樹颱風' then END=mdy(09,13,YEAR);
else if DISASTER='蘇力颱風' then END=mdy(07,13,YEAR);
else if DISASTER='蘇拉颱風' then END=mdy(08,03,YEAR);
else if DISASTER='蘇迪勒颱風' then END=mdy(08,09,YEAR);
else if substr(DISASTER,3,6)='花颱風' then END=mdy(08,03,YEAR);

if find(DISASTER,'潭美及康芮')^=0 then EVENT_NAME='Trami_Kong-Rey';
else if find(DISASTER,'尼莎暨海棠')^=0 then EVENT_NAME='Nesat_Haitang';
else if find(DISASTER,'帕布及梧提')^=0 then EVENT_NAME='Pabuk_Wutip';
else if find(DISASTER,'南修及萊羅克')^=0 then EVENT_NAME='Namtheun_Lionrock';
else if find(DISASTER,'凡那比')^=0 then EVENT_NAME='Fanapi';
else if find(DISASTER,'丹娜絲')^=0 then EVENT_NAME='Danas';
else if find(DISASTER,'天兔')^=0 then EVENT_NAME='Usagi';
else if find(DISASTER,'天秤')^=0 then EVENT_NAME='Tembin';
else if find(DISASTER,'卡玫基')^=0 then EVENT_NAME='Kalmaegi';
else if find(DISASTER,'尼伯特')^=0 then EVENT_NAME='Nepartak';
else if find(DISASTER,'白鹿')^=0 then EVENT_NAME='Bailu';
else if find(DISASTER,'米勒')^=0 then EVENT_NAME='Melor';
else if find(DISASTER,'米塔')^=0 then EVENT_NAME='Mitag';
else if find(DISASTER,'米雷')^=0 then EVENT_NAME='Meari';
else if find(DISASTER,'艾利')^=0 then EVENT_NAME='Aere';
else if find(DISASTER,'杜鵑')^=0 then EVENT_NAME='Dujuan';
else if find(DISASTER,'辛樂克')^=0 then EVENT_NAME='Sinlaku';
else if find(DISASTER,'昌鴻')^=0 then EVENT_NAME='Chan-hom';
else if find(DISASTER,'芭瑪')^=0 then EVENT_NAME='Parma';
else if find(DISASTER,'南瑪都')^=0 then EVENT_NAME='Nanmadol';
else if find(DISASTER,'哈吉貝')^=0 then EVENT_NAME='Hagibis';
else if find(DISASTER,'柯羅莎')^=0 then EVENT_NAME='Krosa';
else if find(DISASTER,'珍珠')^=0 then EVENT_NAME='Chanchu';
else if find(DISASTER,'泰利')^=0 then EVENT_NAME='Talim';
else if find(DISASTER,'海馬')^=0 then EVENT_NAME='Haima';
else if find(DISASTER,'海棠')^=0 then EVENT_NAME='Haitang';
else if find(DISASTER,'納坦')^=0 then EVENT_NAME='Nock-ten';
else if find(DISASTER,'閃電')^=0 then EVENT_NAME='Atsani';
else if find(DISASTER,'馬莎')^=0 then EVENT_NAME='Matsa';
else if find(DISASTER,'敏督利')^=0 then EVENT_NAME='Mindulle';
else if find(DISASTER,'梅姬')^=0 then EVENT_NAME='Megi';
else if find(DISASTER,'莫拉克')^=0 then EVENT_NAME='Morakot';
else if find(DISASTER,'莫蘭蒂')^=0 then EVENT_NAME='Meranti';
else if find(DISASTER,'麥德姆')^=0 then EVENT_NAME='Matmo';
else if find(DISASTER,'圓規')^=0 then EVENT_NAME='Kompasu';
else if find(DISASTER,'聖帕')^=0 then EVENT_NAME='Sepat';
else if find(DISASTER,'瑪莉亞')^=0 then EVENT_NAME='Maria';
else if find(DISASTER,'碧利斯')^=0 then EVENT_NAME='Bilis';
else if find(DISASTER,'鳳凰')^=0 then EVENT_NAME='Fung-wong';
else if find(DISASTER,'蓮花')^=0 then EVENT_NAME='Linfa';
else if find(DISASTER,'龍王')^=0 then EVENT_NAME='Longwang';
else if find(DISASTER,'薔蜜')^=0 then EVENT_NAME='Jangmi';
else if find(DISASTER,'蘇力')^=0 then EVENT_NAME='Soulik';
else if find(DISASTER,'蘇拉')^=0 then EVENT_NAME='Saola';
else if find(DISASTER,'蘇迪勒')^=0 then EVENT_NAME='Soudelor';
else if find(DISASTER,'凱米')^=0 then EVENT_NAME='Kaemi';
else if find(DISASTER,'寶發')^=0 then EVENT_NAME='Bopha';
else if find(DISASTER,'韋帕')^=0 then EVENT_NAME='Wipha';
else if find(DISASTER,'山竹')^=0 then EVENT_NAME='Mangkhut';
else if find(DISASTER,'天鴿')^=0 then EVENT_NAME='Hato';
else if find(DISASTER,'米克拉')^=0 then EVENT_NAME='Mekkhala';
else if find(DISASTER,'利奇馬')^=0 then EVENT_NAME='Lekima';
else if find(DISASTER,'哈格比')^=0 then EVENT_NAME='Hagupit';
else if find(DISASTER,'桑達')^=0 then EVENT_NAME='Songda';
else if find(DISASTER,'馬勒卡')^=0 then EVENT_NAME='Malakas';
else if find(DISASTER,'康森')^=0 then EVENT_NAME='Conson';
else if find(DISASTER,'璨樹')^=0 then EVENT_NAME='Chanthu';
else if substr(DISASTER,3,6)='花颱風' then EVENT_NAME='In-Fa';

keep DISASTER CROP_DISASTER1 CROP_DISASTER2 YEAR DISASTER_GROUP DISASTER_SUB_GROUP1 DISASTER_SUB_GROUP2
DISASTER_MAIN_TYPE1 DISASTER_MAIN_TYPE2
DISASTER_SUB_TYPE1 DISASTER_SUB_TYPE2
DISASTER_SUB_SUB_TYPE1 DISASTER_SUB_SUB_TYPE2
START END EVENT_NAME DISASTER_NO;
run;

proc sort data=all;by DISASTER YEAR;run;
proc sort data=alld;by DISASTER YEAR;run;
data all_disaster;merge all(in=a) alld;
by DISASTER YEAR;if a=1;
if YEAR=2003 then EST_LOSS_Q=EST_LOSS_Q/1000;
keep 
YEAR COUNTY CROP_TYPE CROP_GROUP CROP_CLASS CROP
FIELD_AREA DAMAGED_PERCENTAGE DAMAGED_AREA
EST_LOSS_Q EST_LOSS_V CROP_DISASTER1 CROP_DISASTER2
DISASTER_GROUP DISASTER_SUB_GROUP1 DISASTER_SUB_GROUP2
DISASTER_MAIN_TYPE1 DISASTER_MAIN_TYPE2
DISASTER_SUB_TYPE1 DISASTER_SUB_TYPE2
DISASTER_SUB_SUB_TYPE1 DISASTER_SUB_SUB_TYPE2
START END EVENT_NAME BOTANICAL_NAME DISASTER_NO;
run;

data damage.all_disaster;
retain DISASTER_NO CROP_DISASTER1 CROP_DISASTER2
DISASTER_GROUP DISASTER_SUB_GROUP1 DISASTER_SUB_GROUP2
DISASTER_MAIN_TYPE1 DISASTER_MAIN_TYPE2
DISASTER_SUB_TYPE1 DISASTER_SUB_TYPE2
DISASTER_SUB_SUB_TYPE1 DISASTER_SUB_SUB_TYPE2 EVENT_NAME
YEAR START END COUNTY REGION CROP_TYPE CROP_GROUP CROP_CLASS CROP BOTANICAL_NAME
FIELD_AREA DAMAGED_PERCENTAGE DAMAGED_AREA
EST_LOSS_Q EST_LOSS_V ;
set all_disaster;
if COUNTY in ('Penghu','Kinmen') then REGION='Outer_island';
else if COUNTY in ('Taichung','Changhua','Nantou','Yunlin') then REGION='Central';
else if COUNTY in ('Taipei','Taoyuan','Hsinchu','Miaoli','Keelung') then REGION='Northern';
else if COUNTY in ('Chiayi','Tainan' ,'Kaohsiung','Pingtung') then REGION='Southern';
else REGION='Eastern';
run;


/*data clean*/
proc sort data=damage.all_disaster out=disaster1 nodupkey;
by disaster_no;run;/*257*/
/*災害種類次數*/
proc freq data=disaster1;
table crop_disaster1;
run;

data disaster_cleaned;set damage.all_disaster;
if region="Outer_island" then delete;
if field_area>=5;
if damaged_percentage=0 or damaged_area=0 then delete;
if CROP_DISASTER1 in ('Pest','Earthquake','Unusual_wind','Unusual_climate','Grafting_pear_damage','Foehn',
'High_temperature','Tornado','Hail','Frost') then delete;
if CROP in ('Other_Coarse_Grains','Other_Special_Crops','Other_Citrus','Other_Fruits','Other_Vegetables'
'Other_Cut_Flowers', 'Nuseries','Forage_Crops') then delete;
run;
data damage.disaster_cleaned;set disaster_cleaned;run;

