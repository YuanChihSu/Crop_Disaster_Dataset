libname damage 'D:\��Z\���_�W�θ��\data\�a�`���\for_upload';

%macro csv_data(dir,y);
%let rc=%sysfunc(filename(filrf,&dir));
%let did=%sysfunc(dopen(&filrf));
data d&y.;set _NULL_;run;

%if &did ne 0 %then %do;
%let memcnt=%sysfunc(dnum(&did));
%do i=1 %to &memcnt;
data s;
infile "D:\��Z\���_�W�θ��\data\�a�`���\csv\d&y.\d&y._&i..csv"
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
if VAR2 in ('���~5�멳�e���','���~�|�멳�e���','���~�T�멳�e���','"����',
'��  �p  �q  ��','"�Q �` �{ ��','"����Q�`���n') then VAR2=' ';
if not missing(VAR2)
then _VAR2 = VAR2;
else VAR2 = _VAR2;

if VAR3='�a�`�O' then VAR3=' ';
if not missing(VAR3)
then _VAR3 = VAR3;
else VAR3 = _VAR3;

if VAR4 in ('�o�ͤ��','���إ���','�f��') then VAR4=' ';
if not missing(VAR4)
then _VAR4 = VAR4;
else VAR4 = _VAR4;

MONTH_C=VAR4;
DISASTER=VAR3;

if VAR5=' ' then delete;
if FIELD_AREA=. then delete;

if substr(VAR2,1,4)='����' then COUNTY='Kaohsiung';
else if substr(VAR2,1,4) in ('�x�_','�s�_','�O�_','��') then COUNTY='Taipei';
else if substr(VAR2,1,4)='���' then COUNTY='Taoyuan';
else if substr(VAR2,1,4)='�s��' then COUNTY='Hsinchu';
else if substr(VAR2,1,4)='�]��' then COUNTY='Miaoli';
else if substr(VAR2,1,4) in ('�x��','�O��') then COUNTY='Taichung';
else if substr(VAR2,1,4)='����' then COUNTY='Changhua';
else if substr(VAR2,1,4)='�n��' then COUNTY='Nantou';
else if substr(VAR2,1,4)='���L' then COUNTY='Yunlin';
else if substr(VAR2,1,4)='�Ÿq' then COUNTY='Chiayi';
else if substr(VAR2,1,4) in ('�x�n','�O�n') then COUNTY='Tainan';
else if substr(VAR2,1,4)='�̪F' then COUNTY='Pingtung';
else if substr(VAR2,1,4)='�y��' then COUNTY='Yilan';
else if substr(VAR2,1,4)='�Ὤ' then COUNTY='Hualien';
else if substr(VAR2,1,4) in ('�x�F','�O�F') then COUNTY='Taitung';
else if substr(VAR2,1,4)='���' then COUNTY='Penghu';
else if substr(VAR2,1,4)='����' then COUNTY='Kinmen';

if VAR4 in ('�@��','1��') then MONTH='01';
else if VAR4 in ('�G��','2��') then MONTH='02';
else if VAR4 in ('�T��','3��') then MONTH='03';
else if VAR4 in ('�|��','4��') then MONTH='04';
else if VAR4 in ('����','5��') then MONTH='05';
else if VAR4 in ('����','6��') then MONTH='06';
else if VAR4 in ('�C��','7��') then MONTH='07';
else if VAR4 in ('�K��','8��') then MONTH='08';
else if VAR4 in ('�E��','9��') then MONTH='09';
else if VAR4 in ('�Q��','10��') then MONTH='10';
else if VAR4 in ('�Q�@��','11��') then MONTH='11';
else if VAR4 in ('�Q�G��','12��') then MONTH='12';
else if VAR4 in ('1-2��') then MONTH='01_02';
else if VAR4 in ('1-3��') then MONTH='01_03';
else if VAR4 in ('2~3��') then MONTH='02_03';
else if VAR4 in ('3-4��','3~4��') then MONTH='03_04';
else if VAR4 in ('4-6��') then MONTH='04_06';
else if VAR4 in ('6~7��') then MONTH='06_07';
else if VAR4 in ('7-8��') then MONTH='07_08';

YEAR=&y.+1911;

if VAR5='��L��³' then CROP='Other_Coarse_Grains';/*��½*/
else if VAR5='���_' then CROP='Rice';
else if VAR5='���]' then CROP='Rice_Seedling';/*��½*/
else if VAR5 in ('�w��ɦ�','���Υɦ�','�}�ƥɦ�') then CROP='Maize';
else if VAR5='����' then CROP='Sweet_Potato';
else if VAR5='�����' then CROP='Peanut';
else if VAR5='����' then CROP='Adzuki_Bean';
else if VAR5='��' then CROP='Tea';
else if VAR5='�J��' then CROP='Sesame';
else if VAR5='�ͭ��̽�' then CROP='Sugarcane';
else if VAR5='��L�S�@' then CROP='Other_Special_Crops';/*��½*/
else if VAR5='Ī��' then CROP='Asparagus';
else if VAR5='����' then CROP='Leek';/*��½*/
else if VAR5='�˵�' then CROP='Bamboo_Shoot';/*��½*/
else if VAR5='���w��' then CROP='Day_Lily';/*��½*/
else if VAR5='�v��' then CROP='Onions';
else if VAR5='�ڽ�' then CROP='Radishes';
else if VAR5='�J�ڽ�' then CROP='Carrots';
else if VAR5='�t�յ�' then CROP='Water Bamboo';/*��½*/
else if VAR5='����' then CROP='Cabbage';
else if VAR5='���y�յ�' then CROP='Chinese_Cabbage';/*��½*/
else if VAR5='�����y�յ�' then CROP='Chinese_Mustard';/*��½*/
else if VAR5='�f�X' then CROP='Tomato';
else if VAR5='�[�Y' then CROP='Garlic';
else if VAR5='��' then CROP='Scallion';/*��½*/
else if VAR5='��' then CROP='Taros';
else if VAR5='��' then CROP='Ginger';
else if VAR5='���' then CROP='Watermelon';
else if VAR5='����' then CROP='Melon';
else if VAR5='���' then CROP='Strawberry';
else if VAR5='�ᷦ��' then CROP='Cauliflower';
else if VAR5='�J��' then CROP='Cucumber';
else if VAR5='�V��' then CROP='White_Gourd';/*��½*/
else if VAR5='�W��' then CROP='Bitter_Gourd';/*��½*/
else if VAR5='�X�l' then CROP='Eggplant';
else if VAR5='�樧' then CROP='Kidney_Bean';/*��½*/
else if VAR5='��' then CROP='Soybean (for vegetable)';/*��½*/
else if VAR5 in ('�ܨ�(������)','�ܨ�(������) Peas') then CROP='Pea';
else if VAR5='�f��' then CROP='Pepper';
else if VAR5='����' then CROP='Vegetable_sponge';/*��½*/
else if VAR5='����' then CROP='Other_Vegetables';
else if VAR5='����' then CROP='Banana';
else if VAR5='���' then CROP='Pineapple';
else if VAR5='ٮ�a' then CROP='Ponkan';/*��½*/
else if VAR5='��a' then CROP='Tankan';/*��½*/
else if VAR5='�h��' then CROP='Orange';
else if VAR5='�她�c' then CROP='Wentan_Pomelo';
else if VAR5='�c' then CROP='Pomelo';
else if VAR5='�f�c' then CROP='Lemon';
else if VAR5='��L�a��' then CROP='Other_Citrus';
else if VAR5='�~�G' then CROP='Mango';
else if VAR5='�s��' then CROP='Longan';/*��½*/
else if VAR5='�b�}' then CROP='Betel_Nut';
else if VAR5='�f�ۺh' then CROP='Guava';
else if VAR5='��' then CROP='Plum';
else if VAR5='��' then CROP='Peach';
else if VAR5='�U' then CROP='Persimmon';
else if VAR5='���' then CROP='Papaya';
else if VAR5='����' then CROP='Wax_Apple';/*��½*/
else if VAR5='����' then CROP='Grape';
else if VAR5='�J�I' then CROP='Loquat';
else if VAR5='��' then CROP='Japanese_Apricot';/*��½*/
else if VAR5='��K' then CROP='Litchi';
else if VAR5='����' then CROP='Carambola';/*��½*/
else if VAR5='��' then CROP='Oriental_Pear';/*��½*/
else if VAR5='ī�G' then CROP='Apple';
else if VAR5='��' then CROP='Jujube';/*��½*/
else if VAR5='�f��K' then CROP='Sugar_Apple';/*��½*/
else if VAR5='�ʭ��G' then CROP='Passion_Fruit';/*��½*/
else if VAR5='�i�i���l' then CROP='Coconut';
else if VAR5='��L�C�G' then CROP='Other_Fruits';
else if VAR5='�s��' then CROP='Yam';
else if VAR5='���' then CROP='Chrysanthemum';/*��½*/
else if VAR5='���u�Z' then CROP='Gladiolu';/*��½*/
else if VAR5='�v�ܱ�' then CROP='Eustoma';/*��½*/
else if VAR5='����' then CROP='Forage_Crops';
else if VAR5='����' then CROP='Rose';
else if VAR5='��L��c' then CROP='Other_Cut_Flowers';
else if VAR5='�]�E' then CROP='Nuseries';
else if VAR5='�Ӫť]��ۣ' then CROP='Bagocultred_Shitake';
else if VAR5='���a��' then CROP='Potato';
else if VAR5='�vۣ' then CROP='Mushroom';
else if VAR5='�ү�' then CROP='Tobacco';

/*�ǦW*/
if VAR5='����' then BOTANICAL_NAME='Brassica_oleracea (var. capitata)';
else if VAR5 in ('���_','���]') then BOTANICAL_NAME='Oryza_sativa';
else if VAR5 in ('�w��ɦ�','���Υɦ�','�}�ƥɦ�') then BOTANICAL_NAME='Zea_mays';
else if VAR5='����' then BOTANICAL_NAME='Lopmoea_batatas';
else if VAR5='�����' then BOTANICAL_NAME='Arachis_hypogaea';
else if VAR5='����' then BOTANICAL_NAME='Vigna_angularis';
else if VAR5='��' then BOTANICAL_NAME='Camellia_sinensis';
else if VAR5='�J��' then BOTANICAL_NAME='Sesamum_indicum';
else if VAR5='�ͭ��̽�' then BOTANICAL_NAME='Saccharum_officinarum';
else if VAR5='Ī��' then BOTANICAL_NAME='Asparagus_officinalis';
else if VAR5='����' then BOTANICAL_NAME='Allium_tuberosum';
else if VAR5='�˵�' then BOTANICAL_NAME='Bambusa_spp.';
else if VAR5='���w��' then BOTANICAL_NAME='Hemerocallis_lilioasphodelus';
else if VAR5='�v��' then BOTANICAL_NAME='Allium_cepa';
else if VAR5='�ڽ�' then BOTANICAL_NAME='Raphanus_sativus';
else if VAR5='�J�ڽ�' then BOTANICAL_NAME='Daucus_carota (ssp. sativa)';
else if VAR5='�t�յ�' then BOTANICAL_NAME='Zizania_latifolia';
else if VAR5='���y�յ�' then BOTANICAL_NAME='Brassica_pekinensis';
else if VAR5='�����y�յ�' then BOTANICAL_NAME='Brassica_chinensis';
else if VAR5='�f�X' then BOTANICAL_NAME='Lycopersicon_esculentum';
else if VAR5='�[�Y' then BOTANICAL_NAME='Allium_sativum';
else if VAR5='��' then BOTANICAL_NAME='Allium_fistulosum';
else if VAR5='��' then BOTANICAL_NAME='Colocasia_esculenta';
else if VAR5='��' then BOTANICAL_NAME='Zingiber_officinale';
else if VAR5='���' then BOTANICAL_NAME='Citrullus_lanatus';
else if VAR5='����' then BOTANICAL_NAME='Cucumis_melo';
else if VAR5='���' then BOTANICAL_NAME='Fragaria_spp.';
else if VAR5='�ᷦ��' then BOTANICAL_NAME='Brassica_oleracea (var. botrytis)';
else if VAR5='�J��' then BOTANICAL_NAME='Cucumis_sativus';
else if VAR5='�V��' then BOTANICAL_NAME='Benincasa_pruriens';
else if VAR5='�W��' then BOTANICAL_NAME='Momordica_charantia';
else if VAR5='�X�l' then BOTANICAL_NAME='Solanum_melongena';
else if VAR5='�樧' then BOTANICAL_NAME='Phaseolus_vulgaris';
else if VAR5='��' then BOTANICAL_NAME='Glycine_max';
else if VAR5='�ܨ�(������)' then BOTANICAL_NAME='Pisum_sativum';
else if VAR5='�f��' then BOTANICAL_NAME='Piper_nigrum';
else if VAR5='����' then BOTANICAL_NAME='Luffa_cylindrica ';
else if VAR5='����' then BOTANICAL_NAME='Musa_sapientum';
else if VAR5='���' then BOTANICAL_NAME='Ananas_comosus';
else if VAR5='ٮ�a' then BOTANICAL_NAME='Citrus_poonensis';
else if VAR5='��a' then BOTANICAL_NAME='Citrus_tankan';
else if VAR5='�h��' then BOTANICAL_NAME='Citrus_sinensis';
else if VAR5='�她�c' then BOTANICAL_NAME='Citrus_grandis (Osbeck cv.)';
else if VAR5='�c' then BOTANICAL_NAME='Citrus_grandis';
else if VAR5='�f�c' then BOTANICAL_NAME='Citrus_limon';
else if VAR5='�~�G' then BOTANICAL_NAME='Mangifera_indica';
else if VAR5='�s��' then BOTANICAL_NAME='Dimocarpus_longan';
else if VAR5='�b�}' then BOTANICAL_NAME='Areca_catechu';
else if VAR5='�f�ۺh' then BOTANICAL_NAME='Psidium_guajava';
else if VAR5='��' then BOTANICAL_NAME='Prunus_domestica';
else if VAR5='��' then BOTANICAL_NAME='Prunus_persica';
else if VAR5='�U' then BOTANICAL_NAME='Diospyros_kaki';
else if VAR5='���' then BOTANICAL_NAME='Carica_papaya';
else if VAR5='����' then BOTANICAL_NAME='Syzygium_samarangense';
else if VAR5='����' then BOTANICAL_NAME='Vitis_vinifera';
else if VAR5='�J�I' then BOTANICAL_NAME='Eriobotrya_japonica';
else if VAR5='��' then BOTANICAL_NAME='Prunus_mume';
else if VAR5='��K' then BOTANICAL_NAME='Litchi_chinensis';
else if VAR5='����' then BOTANICAL_NAME='Averrhoa_carambola';
else if VAR5='��' then BOTANICAL_NAME='Pyrus_pyrifolia';
else if VAR5='ī�G' then BOTANICAL_NAME='Malus_sylvestris';
else if VAR5='��' then BOTANICAL_NAME='Ziziphus_mauritiana';
else if VAR5='�f��K' then BOTANICAL_NAME='Annona_Squamosa';
else if VAR5='�ʭ��G' then BOTANICAL_NAME='Passiflora_edulis';
else if VAR5='�i�i���l' then BOTANICAL_NAME='Cocos_nucifera';
else if VAR5='�s��' then BOTANICAL_NAME='Dioscorea_spp.';
else if VAR5='���' then BOTANICAL_NAME='Dendranthema_morifolium';
else if VAR5='���u�Z' then BOTANICAL_NAME='Gladiolus_hybridus';
else if VAR5='�v�ܱ�' then BOTANICAL_NAME='Eustoma_grandiflorm';
else if VAR5='����' then BOTANICAL_NAME='Rose_spp.';
else if VAR5='���a��' then BOTANICAL_NAME='Solamum_tuberosum';
else if VAR5='�ү�' then BOTANICAL_NAME='Nicotiana_tabacum';

if VAR5 in ('��L��³','���_','���]','�w��ɦ�','���Υɦ�','�}�ƥɦ�','����',
'�����','����','�J��','�ͭ��̽�','Ī��','����','���w��','�v��','�ڽ�','�J�ڽ�','�t�յ�',
'����','���y�յ�','�����y�յ�','�f�X','�[�Y','��','��','���','����','���','�ᷦ��','�J��',
'�V��','�W��','�X�l','�樧','��','�ܨ�(������)','�ܨ�(������) Peas','�f��','����','����',
'�s��','���a��','�Ӫť]��ۣ','�vۣ','�ү�','�v�ܱ�','���u�Z','���','����','����') then CROP_TYPE='Temporary';
else if VAR5 in ('��L�S�@','��L�C�G','�]�E') then CROP_TYPE=' ';
else CROP_TYPE='Permanent';


if VAR5 in ('�����','�J��','�i�i���l','��') then CROP_GROUP='Oilseed_Crops_Oleaginous_Fruits';
else if VAR5 in ('��','��','�f��') then CROP_GROUP='Stimulant_Spice_Aromatic_Crops';
else if VAR5 in ('���_','���Υɦ�','�w��ɦ�','�}�ƥɦ�','���]') then CROP_GROUP='Cereals';
else if VAR5 in ('����','��','�s��','���a��') then CROP_GROUP='Root_Tuber_Crops';
else if VAR5 in ('����','�樧','�ܨ�(������)','�ܨ�(������) Peas') then CROP_GROUP='Leguminous_Crops';
else if VAR5 in ('�ͭ��̽�') then CROP_GROUP='Sugar_Crops';
else if VAR5 in ('Ī��','����','�˵�','���w��','�v��','�ڽ�','�J�ڽ�',
'�t�յ�','����','���y�յ�','�����y�յ�','�f�X','�[�Y','��','�ᷦ��',
'�J��','�V��','�W��','�X�l','����','����','�Ӫť]��ۣ','�vۣ','���','����') then CROP_GROUP='Vegetables_Melons';
else if VAR5 in ('���','����','���','ٮ�a','��a','�h��',
'�她�c','�c','�f�c','��L�a��','�~�G','�s��','�f�ۺh','�b�}',
'��','��','�U','���','����','����','�J�I','��K','��','����','��','ī�G',
'��','�f��K','�ʭ��G','��L�C�G') then CROP_GROUP='Fruits_Nuts';
else if VAR5 in ('����','���','���u�Z','�v�ܱ�','����','��L��c','�]�E',
'��L�S�@','�ү�')
then CROP_GROUP='Other_Crops';

if VAR5 in ('���w��','�v��','�ڽ�','�J�ڽ�','�t�յ�','�[�Y') then CROP_CLASS='Root_Bulb_Tuberous_Vegetables';
else if VAR5 in ('����','���','�~�G','�s��','�f�ۺh',
'���','����','��K','����','�f��K','�ʭ��G','�U') then CROP_CLASS='Tropical_Subtropical_Fruits';
else if VAR5 in ('��') then CROP_CLASS='Stimulant_Crops';
else if VAR5 in ('��','�f��') then CROP_CLASS='Spice_Aromatic_Crops';
else if VAR5 in ('��','Ī��','����','�˵�','����','���y�յ�','�����y�յ�','��','�ᷦ��','����')
then CROP_CLASS='Leafy_Stem_Vegetables';
else if VAR5 in ('�J��','�V��','�W��','�X�l','����','�f�X') then CROP_CLASS='Fruit-bearing_Vegetables';
else if VAR5 in ('ٮ�a','��a','�h��','�她�c','�c','�f�c','��L�a��') then CROP_CLASS='Citrus_Fruits';
else if VAR5 in ('����') then CROP_CLASS='Grapes';
else if VAR5 in ('���') then CROP_CLASS='Berries';
else if VAR5 in ('��','��','��','��','ī�G','��','�J�I') then CROP_CLASS='Pome_Stone_Fruits';
else if VAR5 in ('��L�C�G') then CROP_CLASS='Others_Fruits';
else if VAR5 in ('����') then CROP_CLASS='Grasses_Other_Fodder_Crops';
else if VAR5 in ('���','���u�Z','�v�ܱ�','����','��L��c') then CROP_CLASS='Flower';
else if VAR5 in ('�]�E','��L�S�@') then CROP_CLASS='Others_Crops';
else if VAR5 in ('�Ӫť]��ۣ','�vۣ') then CROP_CLASS='Mushrooms_Truffles';
else if VAR5='�ү�' then CROP_CLASS='Tobacco';
else if VAR5='�����' then CROP_CLASS='Groundnuts';
else if VAR5='�J��' then CROP_CLASS='Other_Temporary_Oilseed_Crops';
else if VAR5 in ('���','����') then CROP_CLASS='Melons';
else if VAR5 in ('�b�}') then CROP_CLASS='Nuts';
else if VAR5 in ('�i�i���l') then CROP_CLASS='Permanent_oilseed_crops';
else if VAR5 in ('��') then CROP_CLASS='Soya_Beans';
else if VAR5 in ('����') then CROP_CLASS='Leguminous_crops';
else if VAR5 in ('�樧') then CROP_CLASS='Beans';
else if VAR5 in ('���Υɦ�','�w��ɦ�','�}�ƥɦ�') then CROP_CLASS='Maize';
else if VAR5 in ('�ܨ�(������)','�ܨ�(������) Peas') then CROP_CLASS='Peas';
else if VAR5 in ('���a��') then CROP_CLASS='Potatoes';
else if VAR5 in ('���_','���]') then CROP_CLASS='Rice';
else if VAR5 in ('�ͭ��̽�') then CROP_CLASS='Sugar_cane';
else if VAR5 in ('����') then CROP_CLASS='Sweet_potatoes';
else if VAR5 in ('�s��') then CROP_CLASS='Yams';
else if VAR5 in ('��') then CROP_CLASS='Taro';

EST_LOSS_V=EST_LOSS_V*0.033;/*exchange rate 2023/03/22*/

keep YEAR MONTH COUNTY DISASTER CROP_TYPE CROP_GROUP CROP_CLASS CROP
FIELD_AREA DAMAGED_PERCENTAGE DAMAGED_AREA EST_LOSS_Q
EST_LOSS_V BOTANICAL_NAME;

run;
%mend;
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d110,110);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d109,109);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d108,108);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d107,107);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d106,106);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d105,105);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d104,104);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d103,103);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d102,102);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d101,101);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d100,100);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d99,99);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d98,98);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d97,97);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d96,96);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d95,95);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d94,94);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d93,93);
%csv_data(D:\��Z\���_�W�θ��\data\�a�`���\csv\d92,92);


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
if find(DISASTER,"����")^=0 and find(DISASTER,"����")^=0 then CROP_DISASTER1="Drought";
if find(DISASTER,"����")^=0 and find(DISASTER,"����")^=0 then CROP_DISASTER2="High_temperature";
if find(DISASTER,"�B�r")^=0 and find(DISASTER,"�s����")^=0 then CROP_DISASTER1="Tornado";
if find(DISASTER,"�B�r")^=0 and find(DISASTER,"�s����")^=0 then CROP_DISASTER2="Hail";
if find(DISASTER,"�j��")^=0 and find(DISASTER,"���B")^=0 then CROP_DISASTER1="Strong_wind";
if find(DISASTER,"�j��")^=0 and find(DISASTER,"���B")^=0 then CROP_DISASTER2="Extremely_heavy_rain";
if find(DISASTER,"�j��")^=0 and find(DISASTER,"�B�r")^=0 then CROP_DISASTER1="Strong_wind";
if find(DISASTER,"�j��")^=0 and find(DISASTER,"�B�r")^=0 then CROP_DISASTER2="Hail";
if find(DISASTER,"������")^=0 and find(DISASTER,"����")^=0 then CROP_DISASTER1="Gust_wind";
if find(DISASTER,"������")^=0 and find(DISASTER,"����")^=0 then CROP_DISASTER2="High_temperature";
if find(DISASTER,"���Q")^=0 and find(DISASTER,"���B")^=0 then CROP_DISASTER1="Typhoon";
if find(DISASTER,"���Q")^=0 and find(DISASTER,"���B")^=0 then CROP_DISASTER2="Extremely_heavy_rain";

if CROP_DISASTER1=" " and find(DISASTER,"���B")^=0 then CROP_DISASTER1="Extremely_heavy_rain";
else if CROP_DISASTER1=" " and find(DISASTER,"�䭷")^=0 then CROP_DISASTER1="Typhoon";
else if CROP_DISASTER1=" " and find(DISASTER,"�H�y")^=0 then CROP_DISASTER1="Cold_wave";
else if CROP_DISASTER1=" " and find(DISASTER,"�a�_")^=0 then CROP_DISASTER1="Earthquake";
else if CROP_DISASTER1=" " and find(DISASTER,"�j��")^=0 then CROP_DISASTER1="Strong_wind";
else if CROP_DISASTER1=" " and find(DISASTER,"���B")^=0 then CROP_DISASTER1="Extremely_heavy_rain";
else if CROP_DISASTER1=" " and find(DISASTER,"�p�B")^=0 then CROP_DISASTER1="Thunderstorm";
else if CROP_DISASTER1=" " and find(DISASTER,"�C��")^=0 then CROP_DISASTER1="Low_temperature";
else if CROP_DISASTER1=" " and find(DISASTER,"�B�r")^=0 then CROP_DISASTER1="Hail";
else if CROP_DISASTER1=" " and find(DISASTER,"�s����")^=0 then CROP_DISASTER1="Tornado";
else if CROP_DISASTER1=" " and find(DISASTER,"���a�C��")^=0 then CROP_DISASTER1="Tropical_depression";
else if CROP_DISASTER1=" " and find(DISASTER,"��n��y")^=0 then CROP_DISASTER1="Southwesterly_flow";
else if CROP_DISASTER1=" " and find(DISASTER,"����")^=0 then CROP_DISASTER1="Drought";
else if CROP_DISASTER1=" " and find(DISASTER,"��a")^=0 then CROP_DISASTER1="Drought";
else if CROP_DISASTER1=" " and find(DISASTER,"����")^=0 then CROP_DISASTER1="High_temperature";
else if CROP_DISASTER1=" " and find(DISASTER,"�B�`")^=0 then CROP_DISASTER1="Rain_damage";
else if CROP_DISASTER1=" " and find(DISASTER,"���B")^=0 then CROP_DISASTER1="Continuous_rain";
else if CROP_DISASTER1=" " and find(DISASTER,"�W��")^=0 then CROP_DISASTER1="Front";
else if CROP_DISASTER1=" " and find(DISASTER,"��Բ��`")^=0 then CROP_DISASTER1="Unusual_climate";
else if CROP_DISASTER1=" " and find(DISASTER,"�j�B")^=0 then CROP_DISASTER1="Heavy_rain";
else if CROP_DISASTER1=" " and find(DISASTER,"�I��")^=0 then CROP_DISASTER1="Foehn";
else if CROP_DISASTER1=" " and find(DISASTER,"���`")^=0 then CROP_DISASTER1="Frost";
else if CROP_DISASTER1=" " and find(DISASTER,"�ǭ�")^=0 then CROP_DISASTER1="Unusual_wind";
else if CROP_DISASTER1=" " and find(DISASTER,"������")^=0 then CROP_DISASTER1="Gust_wind";
else if CROP_DISASTER1=" " and find(DISASTER,"�������J����")^=0 then CROP_DISASTER1="Grafting_pear_damage";
else if CROP_DISASTER1=" " and find(DISASTER,"�f�ή`")^=0 then CROP_DISASTER1="Pest";
else if CROP_DISASTER1=" " and find(DISASTER,"�_�a")^=0 then CROP_DISASTER1="Earthquake";

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
if substr(DISASTER,1,16)='5��U����6��W��' then START=mdy(05,21,YEAR);
else if substr(DISASTER,1,7)='9��30��' then START=mdy(substr(DISASTER,1,1),substr(DISASTER,4,2),YEAR);
else if substr(DISASTER,1,23)='109�~1230��110�~1��W��' then START=mdy(12,30,2020);
else if substr(DISASTER,1,7)='11~12��' then START=mdy(11,01,YEAR);
else if substr(DISASTER,1,5)='1-2��' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,5)='1~2��' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,5)='1~3��' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,6)='1��2��' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,5)='2~3��' then START=mdy(02,01,YEAR);
else if substr(DISASTER,1,5)='3~4��' then START=mdy(03,01,YEAR);
else if substr(DISASTER,1,5)='3~5��' then START=mdy(03,01,YEAR);
else if substr(DISASTER,1,6)='3�B4��' then START=mdy(03,01,YEAR);
else if substr(DISASTER,1,8)='3���4��' then START=mdy(03,01,YEAR);
else if substr(DISASTER,1,5)='4~5��' then START=mdy(04,01,YEAR);
else if substr(DISASTER,1,5)='4~6��' then START=mdy(04,01,YEAR);
else if substr(DISASTER,1,6)='4��418' then START=mdy(04,18,YEAR);
else if substr(DISASTER,1,5)='6~7��' then START=mdy(06,01,YEAR);
else if substr(DISASTER,1,5)='6~8��' then START=mdy(06,01,YEAR);
else if substr(DISASTER,1,5)='7~8��' then START=mdy(07,01,YEAR);
else if substr(DISASTER,1,5)='8~9��' then START=mdy(08,01,YEAR);
else if substr(DISASTER,5,5)='1-3��' then START=mdy(01,01,YEAR);
else if substr(DISASTER,1,6)='9~10��' then START=mdy(09,01,YEAR);
else if substr(DISASTER,1,10)='�T��ܥ|��' then START=mdy(03,01,YEAR);
else if substr(DISASTER,5,8)='���ܢ���' then START=mdy(03,01,YEAR);

else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�@��') then START=mdy('01','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('1��') then START=mdy('01','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�G��') then START=mdy('02','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('2��') then START=mdy('02','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�T��') then START=mdy('03','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('3��') then START=mdy('03','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�|��') then START=mdy('04','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('4��') then START=mdy('04','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('����') then START=mdy('05','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('5��') then START=mdy('05','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('����') then START=mdy('06','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('6��') then START=mdy('06','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�C��') then START=mdy('07','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('7��') then START=mdy('07','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�K��') then START=mdy('08','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('8��') then START=mdy('08','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�E��') then START=mdy('09','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('9��') then START=mdy('09','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�Q��','10��') then START=mdy('10','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,6) in ('�Q�@��') then START=mdy('11','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('11��') then START=mdy('11','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,6) in ('�Q�G��') then START=mdy('12','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('12��') then START=mdy('12','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~1��') then START=mdy('01','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,6) in ('�~12��') then START=mdy('12','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~2��') then START=mdy('02','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~7��') then START=mdy('07','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~8��') then START=mdy('08','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~3��') then START=mdy('03','01',YEAR);
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,6) in ('�~����') then START=mdy('04','01',YEAR);

else if find(DISASTER,"�W��")^=0 and find(DISASTER,"1��")^=0 then START=mdy(01,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"1��")^=0 then START=mdy(01,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"1��")^=0 then START=mdy(01,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�@��")^=0 then START=mdy(01,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�@��")^=0 then START=mdy(01,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�@��")^=0 then START=mdy(01,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"2��")^=0 then START=mdy(01,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"2��")^=0 then START=mdy(01,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"2��")^=0 then START=mdy(01,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�G��")^=0 then START=mdy(02,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�G��")^=0 then START=mdy(02,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�G��")^=0 then START=mdy(02,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"3��")^=0 then START=mdy(03,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"3��")^=0 then START=mdy(03,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"3��")^=0 then START=mdy(03,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�T��")^=0 then START=mdy(03,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�T��")^=0 then START=mdy(03,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�T��")^=0 then START=mdy(03,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"4��")^=0 then START=mdy(04,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"4��")^=0 then START=mdy(04,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"4��")^=0 then START=mdy(04,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�|��")^=0 then START=mdy(04,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�|��")^=0 then START=mdy(04,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�|��")^=0 then START=mdy(04,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"5��")^=0 then START=mdy(05,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"5��")^=0 then START=mdy(05,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"5��")^=0 then START=mdy(05,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"����")^=0 then START=mdy(05,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"����")^=0 then START=mdy(05,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"����")^=0 then START=mdy(05,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"6��")^=0 then START=mdy(06,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"6��")^=0 then START=mdy(06,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"6��")^=0 then START=mdy(06,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"����")^=0 then START=mdy(06,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"����")^=0 then START=mdy(06,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"����")^=0 then START=mdy(06,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"7��")^=0 then START=mdy(07,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"7��")^=0 then START=mdy(07,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"7��")^=0 then START=mdy(07,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�C��")^=0 then START=mdy(07,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�C��")^=0 then START=mdy(07,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�C��")^=0 then START=mdy(07,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"8��")^=0 then START=mdy(08,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"8��")^=0 then START=mdy(08,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"8��")^=0 then START=mdy(08,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�K��")^=0 then START=mdy(08,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�K��")^=0 then START=mdy(08,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�K��")^=0 then START=mdy(08,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"9��")^=0 then START=mdy(09,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"9��")^=0 then START=mdy(09,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"9��")^=0 then START=mdy(09,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�E��")^=0 then START=mdy(09,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�E��")^=0 then START=mdy(09,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�E��")^=0 then START=mdy(09,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"10��")^=0 then START=mdy(10,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"10��")^=0 then START=mdy(10,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"10��")^=0 then START=mdy(10,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�Q��")^=0 then START=mdy(10,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�Q��")^=0 then START=mdy(10,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�Q��")^=0 then START=mdy(10,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"11��")^=0 then START=mdy(11,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"11��")^=0 then START=mdy(11,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"11��")^=0 then START=mdy(11,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�Q�@��")^=0 then START=mdy(11,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�Q�@��")^=0 then START=mdy(11,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�Q�@��")^=0 then START=mdy(11,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"12��")^=0 then START=mdy(12,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"12��")^=0 then START=mdy(12,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"12��")^=0 then START=mdy(12,21,YEAR);
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�Q�G��")^=0 then START=mdy(12,01,YEAR);
else if find(DISASTER,"����")^=0 and find(DISASTER,"�Q�G��")^=0 then START=mdy(12,11,YEAR);
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�Q�G��")^=0 then START=mdy(12,21,YEAR);


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
if DISASTER='0517���B' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0601���B' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0611���B' then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0613���B' and YEAR=2017 then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0613���B' and YEAR=2018 then START=mdy(substr(DISASTER,1,2),substr(DISASTER,3,2),YEAR);
else if DISASTER='0812���B' then START=mdy(substr(DISASTER,1,2),10,YEAR);
else if DISASTER='0823���a�C�����a' then START=mdy(substr(DISASTER,1,2),24,YEAR);
else if DISASTER='0826��n��y���B' then START=mdy(substr(DISASTER,1,2),25,YEAR);
else if DISASTER='1011���B' then START=mdy(substr(DISASTER,1,2),11,YEAR);
else if DISASTER='10�뻨�B' and YEAR=2011 then START=mdy(substr(DISASTER,1,2),01,YEAR);
else if DISASTER='4�뻨�B' and YEAR=2006 then START=mdy(04,10,YEAR);
else if DISASTER='5�뤤�����B' and YEAR=2012 then START=mdy(05,20,YEAR);
else if DISASTER='6�뻨�B�ή��Q�䭷' then START=mdy(06,10,YEAR);
else if DISASTER='9�뻨�B' and YEAR=2004 then START=mdy(09,07,YEAR);
else if DISASTER='9��U�����B' and YEAR=2010 then START=mdy(09,24,YEAR);
else if DISASTER='���뻨�B' and YEAR=2020 then START=mdy(05,21,YEAR);
else if DISASTER='10��_ù��䭷' then START=mdy(10,04,YEAR);
else if DISASTER='11��̶�䭷' then START=mdy(11,26,YEAR);
else if DISASTER='7����E�䭷' then START=mdy(07,09,YEAR);
else if DISASTER='8�멬���αﴣ�䭷' then START=mdy(08,07,YEAR);
else if DISASTER='8��t���䭷' then START=mdy(08,16,YEAR);
else if DISASTER='95�~�̻ͦ䭷' then START=mdy(07,23,YEAR);
else if DISASTER='95�~�ѧQ���䭷' then START=mdy(07,12,YEAR);
else if DISASTER='95�~�_�o�䭷' then START=mdy(08,07,YEAR);
else if DISASTER='97�~�d����䭷' then START=mdy(07,16,YEAR);
else if DISASTER='97�~���֧J�䭷' then START=mdy(09,11,YEAR);
else if DISASTER='97�~�����I��' then START=mdy(09,21,YEAR);
else if DISASTER='97�~��Ļ䭷' then START=mdy(07,26,YEAR);
else if DISASTER='97�~���e�䭷' then START=mdy(09,27,YEAR);
else if DISASTER='98�~�ݺ��䭷' then START=mdy(10,03,YEAR);
else if DISASTER='98�~���ԧJ�䭷' then START=mdy(08,05,YEAR);
else if DISASTER='98�~����䭷' then START=mdy(06,19,YEAR);
else if DISASTER='9�뭳���䭷' then START=mdy(09,17,YEAR);
else if DISASTER='�E����Y�䭷' then START=mdy(08,31,YEAR);
else if DISASTER='�K����ԧJ�䭷' then START=mdy(08,02,YEAR);
else if DISASTER='�Q�@��̰ǻ䭷' then START=mdy(11,02,YEAR);
else if DISASTER='�Z����䭷' then START=mdy(09,18,YEAR);
else if DISASTER='�s�˻䭷' then START=mdy(09,14,YEAR);
else if DISASTER='���R���䭷' then START=mdy(07,17,YEAR);
else if DISASTER='�Ѩ߻䭷' then START=mdy(09,20,YEAR);
else if DISASTER='�ѯ��䭷' then START=mdy(08,21,YEAR);
else if DISASTER='���F�䭷' then START=mdy(08,21,YEAR);
else if DISASTER='���B�S�䭷' then START=mdy(07,06,YEAR);
else if DISASTER='����[���Ż䭷' then START=mdy(07,28,YEAR);
else if DISASTER='�ճ��䭷' then START=mdy(08,23,YEAR);
else if DISASTER='�̧J�Ի䭷' then START=mdy(08,10,YEAR);
else if DISASTER='�̶�䭷' then START=mdy(09,29,YEAR);
else if DISASTER='�̹p�䭷�~�����y' then START=mdy(06,24,YEAR);
else if DISASTER='��Q�䭷' then START=mdy(08,23,YEAR);
else if DISASTER='�Q�_���䭷' then START=mdy(08,07,YEAR);
else if DISASTER='���Y�䭷' then START=mdy(09,27,YEAR);
else if DISASTER='�n�פε�ù�J�䭷' then START=mdy(08,30,YEAR);
else if DISASTER='�n�����䭷' and YEAR=2004 then START=mdy(12,03,YEAR);
else if DISASTER='�n�����䭷' and YEAR=2011 then START=mdy(08,27,YEAR);
else if DISASTER='���N���䭷�~�����y' then START=mdy(06,15,YEAR);
else if DISASTER='�����䭷' then START=mdy(08,02,YEAR);
else if DISASTER='�ï]�䭷' then START=mdy(05,16,YEAR);
else if DISASTER='��F�䭷' then START=mdy(05,27,YEAR);
else if DISASTER='���Q�䭷' then START=mdy(08,30,YEAR);
else if DISASTER='�����䭷' then START=mdy(09,12,YEAR);
else if DISASTER='���Ż䭷' then START=mdy(07,16,YEAR);
else if DISASTER='�ǩZ�䭷' then START=mdy(10,23,YEAR);
else if DISASTER='�{�q�䭷' then START=mdy(11,05,YEAR);
else if DISASTER='���ǥd�䭷' then START=mdy(09,16,YEAR);
else if DISASTER='����䭷' then START=mdy(08,03,YEAR);
else if DISASTER='�d�˻䭷' then START=mdy(06,07,YEAR);
else if DISASTER='�ӷ��Q�䭷' then START=mdy(06,28,YEAR);
else if DISASTER='���V�䭷' and YEAR=2010 then START=mdy(10,21,YEAR);
else if DISASTER='���V�䭷' and YEAR=2016 then START=mdy(09,26,YEAR);
else if DISASTER='�������䭷' and YEAR=2010 then START=mdy(09,09,YEAR);
else if DISASTER='�������䭷' and YEAR=2016 then START=mdy(09,13,YEAR);
else if DISASTER='���w�i�䭷' then START=mdy(07,21,YEAR);
else if DISASTER='��W�䭷' then START=mdy(10,10,YEAR);
else if DISASTER='�����Ȼ䭷' then START=mdy(07,09,YEAR);
else if DISASTER='��Ļ䭷' then START=mdy(09,19,YEAR);
else if DISASTER='����αdͺ�䭷' then START=mdy(08,20,YEAR);
else if DISASTER='�s���䭷' then START=mdy(09,30,YEAR);
else if DISASTER='����䭷' then START=mdy(09,10,YEAR);
else if DISASTER='Ĭ�O�䭷' then START=mdy(07,11,YEAR);
else if DISASTER='Ĭ�Ի䭷' then START=mdy(07,30,YEAR);
else if DISASTER='Ĭ�}�ǻ䭷' then START=mdy(08,06,YEAR);
else if substr(DISASTER,3,6)='��䭷' then START=mdy(07,30,YEAR);


/*event end date*/
if substr(DISASTER,1,7)='9��30��' then END=START;
else if substr(DISASTER,1,16)='5��U����6��W��' then END=mdy(06,10,YEAR);
else if substr(DISASTER,1,23)='109�~1230��110�~1��W��' then END=mdy(01,10,2021);
else if substr(DISASTER,1,7)='11~12��' then END=mdy(12,31,YEAR);
else if substr(DISASTER,1,5)='1-2��' then END=intnx('month',mdy(02,01,YEAR),0,'E');
else if substr(DISASTER,1,5)='1~2��' then END=intnx('month',mdy(02,01,YEAR),0,'E');
else if substr(DISASTER,1,5)='1~3��' then END=mdy(03,01,YEAR);
else if substr(DISASTER,1,6)='1��2��' then END=intnx('month',mdy(02,01,YEAR),0,'E');
else if substr(DISASTER,1,5)='2~3��' then END=mdy(03,31,YEAR);
else if substr(DISASTER,1,5)='3~4��' then END=mdy(04,30,YEAR);
else if substr(DISASTER,1,5)='3~5��' then END=mdy(05,31,YEAR);
else if substr(DISASTER,1,6)='3�B4��' then END=mdy(04,30,YEAR);
else if substr(DISASTER,1,8)='3���4��' then END=mdy(04,30,YEAR);
else if substr(DISASTER,1,5)='4~5��' then END=mdy(05,31,YEAR);
else if substr(DISASTER,1,5)='4~6��' then END=mdy(06,30,YEAR);
else if substr(DISASTER,1,6)='4��418' then END=mdy(04,18,YEAR);
else if substr(DISASTER,1,5)='6~7��' then END=mdy(07,31,YEAR);
else if substr(DISASTER,1,5)='6~8��' then END=mdy(08,31,YEAR);
else if substr(DISASTER,1,5)='7~8��' then END=mdy(08,31,YEAR);
else if substr(DISASTER,1,5)='8~9��' then END=mdy(09,30,YEAR);
else if substr(DISASTER,5,5)='1-3��' then END=mdy(03,31,YEAR);
else if substr(DISASTER,1,6)='9~10��' then END=mdy(10,31,YEAR);
else if substr(DISASTER,1,10)='�T��ܥ|��' then END=mdy(04,30,YEAR);
else if substr(DISASTER,5,8)='���ܢ���' then END=mdy(04,30,YEAR);

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

else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�@��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('1��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�G��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('2��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�T��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('3��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�|��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('4��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('����') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('5��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('����') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('6��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�C��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('7��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�K��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('8��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�E��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,3) in ('9��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('�Q��','10��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,6) in ('�Q�@��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('11��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,6) in ('�Q�G��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,1,4) in ('12��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~1��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,6) in ('�~12��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~2��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~7��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~8��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,5) in ('�~3��') then END=intnx('month',START,0,'E');
else if find(DISASTER,"��")=0 and DISASTER_SUB_TYPE1^="Tropical_storm" and substr(DISASTER,3,6) in ('�~����') then END=intnx('month',START,0,'E');

else if find(DISASTER,"�W��")^=0 and find(DISASTER,"1��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"1��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"1��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�@��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�@��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�@��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"2��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"2��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"2��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�G��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�G��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�G��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"3��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"3��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"3��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�T��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�T��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�T��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"4��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"4��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"4��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�|��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�|��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�|��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"5��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"5��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"5��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"����")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"����")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"����")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"6��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"6��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"6��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"����")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"����")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"����")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"7��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"7��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"7��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�C��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�C��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�C��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"8��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"8��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"8��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�K��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�K��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�K��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"9��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"9��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"9��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�E��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�E��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�E��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"10��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"10��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"10��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�Q��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�Q��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�Q��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"11��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"11��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"11��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�Q�@��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�Q�@��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�Q�@��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"12��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"12��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"12��")^=0 then END=intnx('month',START,0,'E');
else if find(DISASTER,"�W��")^=0 and find(DISASTER,"�Q�G��")^=0 then END=START+9;
else if find(DISASTER,"����")^=0 and find(DISASTER,"�Q�G��")^=0 then END=START+9;
else if find(DISASTER,"�U��")^=0 and find(DISASTER,"�Q�G��")^=0 then END=intnx('month',START,0,'E');

/*event end date from NCDR*/
if DISASTER='0517���B' then END=mdy(05,20,YEAR);
else if DISASTER='0601���B' then END=mdy(06,04,YEAR);
else if DISASTER='0611���B' then END=mdy(06,13,YEAR);
else if DISASTER='0613���B' and YEAR=2017 then END=mdy(06,18,YEAR);
else if DISASTER='0613���B' and YEAR=2018 then END=mdy(06,15,YEAR);
else if DISASTER='0812���B' then END=mdy(08,17,YEAR);
else if DISASTER='0823���a�C�����a' then END=mdy(08,30,YEAR);
else if DISASTER='0826��n��y���B' then END=mdy(08,26,YEAR);
else if DISASTER='1011���B' then END=mdy(10,15,YEAR);
else if DISASTER='10�뻨�B' and YEAR=2011 then END=mdy(10,01,YEAR);
else if DISASTER='4�뻨�B' and YEAR=2006 then END=mdy(04,11,YEAR);
else if DISASTER='5�뤤�����B' and YEAR=2012 then END=mdy(05,20,YEAR);
else if DISASTER='6�뻨�B�ή��Q�䭷' then END=mdy(06,21,YEAR);
else if DISASTER='9�뻨�B' and YEAR=2004 then END=mdy(09,07,YEAR);
else if DISASTER='9��U�����B' and YEAR=2010 then END=mdy(09,24,YEAR);
else if DISASTER='���뻨�B' and YEAR=2020 then END=mdy(05,28,YEAR);
else if DISASTER='10��_ù��䭷' then END=mdy(10,07,YEAR);
else if DISASTER='11��̶�䭷' then END=mdy(11,27,YEAR);
else if DISASTER='7����E�䭷' then END=mdy(07,11,YEAR);
else if DISASTER='8�멬���αﴣ�䭷' then END=mdy(08,09,YEAR);
else if DISASTER='8��t���䭷' then END=mdy(08,19,YEAR);
else if DISASTER='95�~�̻ͦ䭷' then END=mdy(07,26,YEAR);
else if DISASTER='95�~�ѧQ���䭷' then END=mdy(07,15,YEAR);
else if DISASTER='95�~�_�o�䭷' then END=mdy(08,09,YEAR);
else if DISASTER='97�~�d����䭷' then END=mdy(07,18,YEAR);
else if DISASTER='97�~���֧J�䭷' then END=mdy(09,16,YEAR);
else if DISASTER='97�~�����I��' then END=mdy(09,23,YEAR);
else if DISASTER='97�~��Ļ䭷' then END=mdy(07,29,YEAR);
else if DISASTER='97�~���e�䭷' then END=mdy(09,29,YEAR);
else if DISASTER='98�~�ݺ��䭷' then END=mdy(10,06,YEAR);
else if DISASTER='98�~���ԧJ�䭷' then END=mdy(08,10,YEAR);
else if DISASTER='98�~����䭷' then END=mdy(06,22,YEAR);
else if DISASTER='9�뭳���䭷' then END=mdy(09,19,YEAR);
else if DISASTER='�E����Y�䭷' then END=mdy(09,02,YEAR);
else if DISASTER='�K����ԧJ�䭷' then END=mdy(08,04,YEAR);
else if DISASTER='�Q�@��̰ǻ䭷' then END=mdy(11,03,YEAR);
else if DISASTER='�Z����䭷' then END=mdy(09,20,YEAR);
else if DISASTER='�s�˻䭷' then END=mdy(09,15,YEAR);
else if DISASTER='���R���䭷' then END=mdy(07,18,YEAR);
else if DISASTER='�Ѩ߻䭷' then END=mdy(09,22,YEAR);
else if DISASTER='�ѯ��䭷' then END=mdy(08,28,YEAR);
else if DISASTER='���F�䭷' then END=mdy(08,22,YEAR);
else if DISASTER='���B�S�䭷' then END=mdy(07,09,YEAR);
else if DISASTER='����[���Ż䭷' then END=mdy(07,31,YEAR);
else if DISASTER='�ճ��䭷' then END=mdy(08,25,YEAR);
else if DISASTER='�̧J�Ի䭷' then END=mdy(08,11,YEAR);
else if DISASTER='�̶�䭷' then END=mdy(10,01,YEAR);
else if DISASTER='�̹p�䭷�~�����y' then END=mdy(06,25,YEAR);
else if DISASTER='��Q�䭷' then END=mdy(08,26,YEAR);
else if DISASTER='�Q�_���䭷' then END=mdy(08,10,YEAR);
else if DISASTER='���Y�䭷' then END=mdy(09,29,YEAR);
else if DISASTER='�n�פε�ù�J�䭷' then END=mdy(09,02,YEAR);
else if DISASTER='�n�����䭷' and YEAR=2004 then END=mdy(12,04,YEAR);
else if DISASTER='�n�����䭷' and YEAR=2011 then END=mdy(08,31,YEAR);
else if DISASTER='���N���䭷�~�����y' then END=mdy(06,15,YEAR);
else if DISASTER='�����䭷' then END=mdy(08,04,YEAR);
else if DISASTER='�ï]�䭷' then END=mdy(05,18,YEAR);
else if DISASTER='��F�䭷' then END=mdy(05,28,YEAR);
else if DISASTER='���Q�䭷' then END=mdy(09,01,YEAR);
else if DISASTER='�����䭷' then END=mdy(09,13,YEAR);
else if DISASTER='���Ż䭷' then END=mdy(07,20,YEAR);
else if DISASTER='�ǩZ�䭷' then END=mdy(10,26,YEAR);
else if DISASTER='�{�q�䭷' then END=mdy(11,07,YEAR);
else if DISASTER='���ǥd�䭷' then END=mdy(09,18,YEAR);
else if DISASTER='����䭷' then END=mdy(08,06,YEAR);
else if DISASTER='�d�˻䭷' then END=mdy(06,10,YEAR);
else if DISASTER='�ӷ��Q�䭷' then END=mdy(07,03,YEAR);
else if DISASTER='���V�䭷' and YEAR=2010 then END=mdy(10,24,YEAR);
else if DISASTER='���V�䭷' and YEAR=2016 then END=mdy(09,28,YEAR);
else if DISASTER='�������䭷' and YEAR=2010 then END=mdy(09,10,YEAR);
else if DISASTER='�������䭷' and YEAR=2016 then END=mdy(09,15,YEAR);
else if DISASTER='���w�i�䭷' then END=mdy(07,23,YEAR);
else if DISASTER='��W�䭷' then END=mdy(10,14,YEAR);
else if DISASTER='�����Ȼ䭷' then END=mdy(07,11,YEAR);
else if DISASTER='��Ļ䭷' then END=mdy(09,22,YEAR);
else if DISASTER='����αdͺ�䭷' then END=mdy(08,29,YEAR);
else if DISASTER='�s���䭷' then END=mdy(10,03,YEAR);
else if DISASTER='����䭷' then END=mdy(09,13,YEAR);
else if DISASTER='Ĭ�O�䭷' then END=mdy(07,13,YEAR);
else if DISASTER='Ĭ�Ի䭷' then END=mdy(08,03,YEAR);
else if DISASTER='Ĭ�}�ǻ䭷' then END=mdy(08,09,YEAR);
else if substr(DISASTER,3,6)='��䭷' then END=mdy(08,03,YEAR);

if find(DISASTER,'����αdͺ')^=0 then EVENT_NAME='Trami_Kong-Rey';
else if find(DISASTER,'����[����')^=0 then EVENT_NAME='Nesat_Haitang';
else if find(DISASTER,'�����αﴣ')^=0 then EVENT_NAME='Pabuk_Wutip';
else if find(DISASTER,'�n�פε�ù�J')^=0 then EVENT_NAME='Namtheun_Lionrock';
else if find(DISASTER,'�Z����')^=0 then EVENT_NAME='Fanapi';
else if find(DISASTER,'���R��')^=0 then EVENT_NAME='Danas';
else if find(DISASTER,'�Ѩ�')^=0 then EVENT_NAME='Usagi';
else if find(DISASTER,'�ѯ�')^=0 then EVENT_NAME='Tembin';
else if find(DISASTER,'�d����')^=0 then EVENT_NAME='Kalmaegi';
else if find(DISASTER,'���B�S')^=0 then EVENT_NAME='Nepartak';
else if find(DISASTER,'�ճ�')^=0 then EVENT_NAME='Bailu';
else if find(DISASTER,'�̰�')^=0 then EVENT_NAME='Melor';
else if find(DISASTER,'�̶�')^=0 then EVENT_NAME='Mitag';
else if find(DISASTER,'�̹p')^=0 then EVENT_NAME='Meari';
else if find(DISASTER,'��Q')^=0 then EVENT_NAME='Aere';
else if find(DISASTER,'���Y')^=0 then EVENT_NAME='Dujuan';
else if find(DISASTER,'���֧J')^=0 then EVENT_NAME='Sinlaku';
else if find(DISASTER,'���E')^=0 then EVENT_NAME='Chan-hom';
else if find(DISASTER,'�ݺ�')^=0 then EVENT_NAME='Parma';
else if find(DISASTER,'�n����')^=0 then EVENT_NAME='Nanmadol';
else if find(DISASTER,'���N��')^=0 then EVENT_NAME='Hagibis';
else if find(DISASTER,'�_ù��')^=0 then EVENT_NAME='Krosa';
else if find(DISASTER,'�ï]')^=0 then EVENT_NAME='Chanchu';
else if find(DISASTER,'���Q')^=0 then EVENT_NAME='Talim';
else if find(DISASTER,'����')^=0 then EVENT_NAME='Haima';
else if find(DISASTER,'����')^=0 then EVENT_NAME='Haitang';
else if find(DISASTER,'�ǩZ')^=0 then EVENT_NAME='Nock-ten';
else if find(DISASTER,'�{�q')^=0 then EVENT_NAME='Atsani';
else if find(DISASTER,'����')^=0 then EVENT_NAME='Matsa';
else if find(DISASTER,'�ӷ��Q')^=0 then EVENT_NAME='Mindulle';
else if find(DISASTER,'���V')^=0 then EVENT_NAME='Megi';
else if find(DISASTER,'���ԧJ')^=0 then EVENT_NAME='Morakot';
else if find(DISASTER,'������')^=0 then EVENT_NAME='Meranti';
else if find(DISASTER,'���w�i')^=0 then EVENT_NAME='Matmo';
else if find(DISASTER,'��W')^=0 then EVENT_NAME='Kompasu';
else if find(DISASTER,'�t��')^=0 then EVENT_NAME='Sepat';
else if find(DISASTER,'������')^=0 then EVENT_NAME='Maria';
else if find(DISASTER,'�ѧQ��')^=0 then EVENT_NAME='Bilis';
else if find(DISASTER,'���')^=0 then EVENT_NAME='Fung-wong';
else if find(DISASTER,'����')^=0 then EVENT_NAME='Linfa';
else if find(DISASTER,'�s��')^=0 then EVENT_NAME='Longwang';
else if find(DISASTER,'���e')^=0 then EVENT_NAME='Jangmi';
else if find(DISASTER,'Ĭ�O')^=0 then EVENT_NAME='Soulik';
else if find(DISASTER,'Ĭ��')^=0 then EVENT_NAME='Saola';
else if find(DISASTER,'Ĭ�}��')^=0 then EVENT_NAME='Soudelor';
else if find(DISASTER,'�ͦ�')^=0 then EVENT_NAME='Kaemi';
else if find(DISASTER,'�_�o')^=0 then EVENT_NAME='Bopha';
else if find(DISASTER,'����')^=0 then EVENT_NAME='Wipha';
else if find(DISASTER,'�s��')^=0 then EVENT_NAME='Mangkhut';
else if find(DISASTER,'���F')^=0 then EVENT_NAME='Hato';
else if find(DISASTER,'�̧J��')^=0 then EVENT_NAME='Mekkhala';
else if find(DISASTER,'�Q�_��')^=0 then EVENT_NAME='Lekima';
else if find(DISASTER,'�����')^=0 then EVENT_NAME='Hagupit';
else if find(DISASTER,'��F')^=0 then EVENT_NAME='Songda';
else if find(DISASTER,'���ǥd')^=0 then EVENT_NAME='Malakas';
else if find(DISASTER,'�d��')^=0 then EVENT_NAME='Conson';
else if find(DISASTER,'����')^=0 then EVENT_NAME='Chanthu';
else if substr(DISASTER,3,6)='��䭷' then EVENT_NAME='In-Fa';

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
/*�a�`��������*/
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

