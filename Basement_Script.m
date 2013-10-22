%Analyse Basement data script


[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('2ms_MLS_01nia.wav','Basement_015.wav',1,5,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_015_rawdata','png')
   saveas(hand2,'Basement_015_rawdata_db','png')
   saveas(hand3,'Basement_015_IR','png')
   saveas(hand4,'Basement_015_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('2ms_MLS_01nia.wav','Basement_008.wav',1,5,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_008_rawdata','png')
   saveas(hand2,'Basement_008_rawdata_db','png')
   saveas(hand3,'Basement_008_IR','png')
   saveas(hand4,'Basement_008_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('2ms_MLS_01nia.wav','Basement_001.wav',1,5,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_001_rawdata','png')
   saveas(hand2,'Basement_001_rawdata_db','png')
   saveas(hand3,'Basement_001_IR','png')
   saveas(hand4,'Basement_001_IR_freq','png')
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('683ms_MLS_01nia.wav','Basement_016.wav',1,16,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_016_rawdata','png')
   saveas(hand2,'Basement_016_rawdata_db','png')
   saveas(hand3,'Basement_016_IR','png')
   saveas(hand4,'Basement_016_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('683ms_MLS_01nia.wav','Basement_009.wav',1,16,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_009_rawdata','png')
   saveas(hand2,'Basement_009_rawdata_db','png')
   saveas(hand3,'Basement_009_IR','png')
   saveas(hand4,'Basement_009_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('683ms_MLS_01nia.wav','Basement_002.wav',1,16,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_002_rawdata','png')
   saveas(hand2,'Basement_002_rawdata_db','png')
   saveas(hand3,'Basement_002_IR','png')
   saveas(hand4,'Basement_002_IR_freq','png')
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_01nia.wav','Basement_017.wav',1,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_017_rawdata','png')
   saveas(hand2,'Basement_017_rawdata_db','png')
   saveas(hand3,'Basement_017_IR','png')
   saveas(hand4,'Basement_017_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_01nia.wav','Basement_010.wav',1,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_010_rawdata','png')
   saveas(hand2,'Basement_010_rawdata_db','png')
   saveas(hand3,'Basement_010_IR','png')
   saveas(hand4,'Basement_010_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_01nia.wav','Basement_003.wav',1,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_003_rawdata','png')
   saveas(hand2,'Basement_003_rawdata_db','png')
   saveas(hand3,'Basement_003_IR','png')
   saveas(hand4,'Basement_003_IR_freq','png')
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_02nia.wav','Basement_018.wav',2,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_018_rawdata','png')
   saveas(hand2,'Basement_018_rawdata_db','png')
   saveas(hand3,'Basement_018_IR','png')
   saveas(hand4,'Basement_018_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_02nia.wav','Basement_011.wav',2,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_011_rawdata','png')
   saveas(hand2,'Basement_011_rawdata_db','png')
   saveas(hand3,'Basement_011_IR','png')
   saveas(hand4,'Basement_011_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_02nia.wav','Basement_004.wav',2,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_004_rawdata','png')
   saveas(hand2,'Basement_004_rawdata_db','png')
   saveas(hand3,'Basement_004_IR','png')
   saveas(hand4,'Basement_004_IR_freq','png')
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_04nia.wav','Basement_019.wav',4,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_019_rawdata','png')
   saveas(hand2,'Basement_019_rawdata_db','png')
   saveas(hand3,'Basement_019_IR','png')
   saveas(hand4,'Basement_019_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_04nia.wav','Basement_012.wav',4,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_012_rawdata','png')
   saveas(hand2,'Basement_012_rawdata_db','png')
   saveas(hand3,'Basement_012_IR','png')
   saveas(hand4,'Basement_012_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_04nia.wav','Basement_005.wav',4,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_005_rawdata','png')
   saveas(hand2,'Basement_005_rawdata_db','png')
   saveas(hand3,'Basement_005_IR','png')
   saveas(hand4,'Basement_005_IR_freq','png')
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_10nia.wav','Basement_020.wav',10,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_020_rawdata','png')
   saveas(hand2,'Basement_020_rawdata_db','png')
   saveas(hand3,'Basement_020_IR','png')
   saveas(hand4,'Basement_020_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_10nia.wav','Basement_013.wav',10,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_013_rawdata','png')
   saveas(hand2,'Basement_013_rawdata_db','png')
   saveas(hand3,'Basement_013_IR','png')
   saveas(hand4,'Basement_013_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_10nia.wav','Basement_006.wav',10,17,0);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_006_rawdata','png')
   saveas(hand2,'Basement_006_rawdata_db','png')
   saveas(hand3,'Basement_006_IR','png')
   saveas(hand4,'Basement_006_IR_freq','png')
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_10nia.wav','Basement_021.wav',10,17,1);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_021_rawdata','png')
   saveas(hand2,'Basement_021_rawdata_db','png')
   saveas(hand3,'Basement_021_IR','png')
   saveas(hand4,'Basement_021_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_10nia.wav','Basement_014.wav',10,17,1);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_014_rawdata','png')
   saveas(hand2,'Basement_014_rawdata_db','png')
   saveas(hand3,'Basement_014_IR','png')
   saveas(hand4,'Basement_014_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_10nia.wav','Basement_007.wav',10,17,1);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_007_rawdata','png')
   saveas(hand2,'Basement_007_rawdata_db','png')
   saveas(hand3,'Basement_007_IR','png')
   saveas(hand4,'Basement_007_IR_freq','png')
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_10.wav','Basement_022.wav',10,17,1);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_022_rawdata','png')
   saveas(hand2,'Basement_022_rawdata_db','png')
   saveas(hand3,'Basement_022_IR','png')
   saveas(hand4,'Basement_022_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_10.wav','Basement_023.wav',10,17,1);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_023_rawdata','png')
   saveas(hand2,'Basement_023_rawdata_db','png')
   saveas(hand3,'Basement_023_IR','png')
   saveas(hand4,'Basement_023_IR_freq','png')
end

[ir, H,hand1,hand2,hand3,hand4] = AnalyseBasement('1365ms_MLS_10.wav','Basement_024.wav',10,17,1);

result = input('Save graphs? 0 or 1');

if result == 1
   saveas(hand1,'Basement_024_rawdata','png')
   saveas(hand2,'Basement_024_rawdata_db','png')
   saveas(hand3,'Basement_024_IR','png')
   saveas(hand4,'Basement_024_IR_freq','png')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%