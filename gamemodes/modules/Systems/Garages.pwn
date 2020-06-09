// Viwo:SQLID, Int:5
#include <YSI\y_hooks>

#if defined MODULE_GARAGES
	#endinput
#endif
#define MODULE_GARAGES

#define GARAGES

/*
	######## ##    ## ##     ## ##     ##  ######
	##       ###   ## ##     ## ###   ### ##    ##
	##       ####  ## ##     ## #### #### ##
	######   ## ## ## ##     ## ## ### ##  ######
	##       ##  #### ##     ## ##     ##       ##
	##       ##   ### ##     ## ##     ## ##    ##
	######## ##    ##  #######  ##     ##  ######
*/
enum E_GARAGE_INT_DATA {
	Float:giX,
	Float:giY,
	Float:giZ
}
enum E_SAFE_EXIT {
	Float:giX,
	Float:giY,
	Float:giZ,
	Float:giRZ
}
static stock
	GaragesIntInfo[][ E_GARAGE_INT_DATA ] = {
			{ -502.3650, 1363.9989, 1102.9000 },
			{ 1946.9453, -1042.1703, 17939.90 },
			{ 1200.9727, -831.3710, 1085.3000 },
			{ 1217.2489, -780.5413, 1086.6000 }
	};

enum E_GARAGE_DATA {
	gSQLID,
	gOwnerID,
	gAdress[16],
	gEnterPck,
	gPrice,
	gLocked,
	Float:gEnterX,
	Float:gEnterY,
	Float:gEnterZ,
	Float:gExitX,
	Float:gExitY,
	Float:gExitZ,
	gHouseID
}
new
	GarageInfo[ MAX_GARAGES ][ E_GARAGE_DATA ],
	PlayerSafeExit[ MAX_PLAYERS ][E_SAFE_EXIT];

    
// Global
static stock
    	PlayerText:GarageBcg1[ MAX_PLAYERS ]			= { PlayerText:INVALID_TEXT_DRAW, ...},
		PlayerText:GarageBcg2[ MAX_PLAYERS ]			= { PlayerText:INVALID_TEXT_DRAW, ...},
		PlayerText:GarageInfoText[ MAX_PLAYERS ]		= { PlayerText:INVALID_TEXT_DRAW, ...},
		PlayerText:GarageInfoTD[ MAX_PLAYERS ]			= { PlayerText:INVALID_TEXT_DRAW, ...},
		PlayerText:GarageCMDTD[ MAX_PLAYERS ]			= { PlayerText:INVALID_TEXT_DRAW, ...};

static stock
    HideGarageTD[MAX_PLAYERS],
	Bit1:r_HDTimer<MAX_PLAYERS>  = {Bit1:false, ...},
	GarageSeller[ MAX_PLAYERS ],
	GarageBuyer[ MAX_PLAYERS ],
	GaragePrice[ MAX_PLAYERS ];

/*
	 ######  ########  #######   ######  ##    ##  ######
	##    ##    ##    ##     ## ##    ## ##   ##  ##    ##
	##          ##    ##     ## ##       ##  ##   ##
	 ######     ##    ##     ## ##       #####     ######
	      ##    ##    ##     ## ##       ##  ##         ##
	##    ##    ##    ##     ## ##    ## ##   ##  ##    ##
	 ######     ##     #######   ######  ##    ##  ######
*/
Function: OnGarageCreates(garageid)
{
    GarageInfo[ garageid ][ gSQLID ] = cache_insert_id();
	return 1;
}

stock static GetNearGarage(playerid, Float:range)
{
	new
		index = -1;
	foreach(new i: Garages) {
	    if(IsPlayerInRangeOfPoint(playerid, range, GarageInfo[ i ][ gEnterX ], GarageInfo[ i ][ gEnterY ], GarageInfo[ i ][ gEnterZ ])) {
	        index = i;
	        break;
	    }
	}
	return index;
}

stock DestroyGarageInfoTD(playerid)
{
	PlayerTextDrawDestroy( playerid, 	GarageBcg1[playerid] );
	PlayerTextDrawDestroy( playerid, 	GarageBcg2[playerid] );
	PlayerTextDrawDestroy( playerid, 	GarageInfoText[playerid] );
	PlayerTextDrawDestroy( playerid, 	GarageInfoTD[playerid] );
	PlayerTextDrawDestroy( playerid, 	GarageCMDTD[playerid] );

	GarageBcg1[playerid]				= PlayerText:INVALID_TEXT_DRAW;
	GarageBcg2[playerid] 				= PlayerText:INVALID_TEXT_DRAW;
	GarageInfoText[playerid] 			= PlayerText:INVALID_TEXT_DRAW;
	GarageInfoTD[playerid] 				= PlayerText:INVALID_TEXT_DRAW;
	GarageCMDTD[playerid] 				= PlayerText:INVALID_TEXT_DRAW;
	return 1;
}

stock static CreateGarageInfoTD(playerid)
{
	DestroyGarageInfoTD(playerid);
	GarageBcg1[playerid] = CreatePlayerTextDraw(playerid, 639.612121, 116.752761, "usebox");
	PlayerTextDrawLetterSize(playerid, 		GarageBcg1[playerid], 0.000000, 10.236042);
	PlayerTextDrawTextSize(playerid, 		GarageBcg1[playerid], 497.499877, 0.000000);
	PlayerTextDrawAlignment(playerid, 		GarageBcg1[playerid], 1);
	PlayerTextDrawColor(playerid, 			GarageBcg1[playerid], 0);
	PlayerTextDrawUseBox(playerid, 			GarageBcg1[playerid], true);
	PlayerTextDrawBoxColor(playerid, 		GarageBcg1[playerid], 102);
	PlayerTextDrawSetShadow(playerid, 		GarageBcg1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, 		GarageBcg1[playerid], 0);
	PlayerTextDrawFont(playerid, 			GarageBcg1[playerid], 0);
	PlayerTextDrawShow(playerid,			GarageBcg1[playerid]);

	GarageBcg2[playerid] = CreatePlayerTextDraw(playerid, 639.575012, 116.860000, "usebox");
	PlayerTextDrawLetterSize(playerid, 		GarageBcg2[playerid], 0.000000, 1.238053);
	PlayerTextDrawTextSize(playerid, 		GarageBcg2[playerid], 497.500000, 0.000000);
	PlayerTextDrawAlignment(playerid, 		GarageBcg2[playerid], 1);
	PlayerTextDrawColor(playerid, 			GarageBcg2[playerid], 0);
	PlayerTextDrawUseBox(playerid, 			GarageBcg2[playerid], true);
	PlayerTextDrawBoxColor(playerid, 		GarageBcg2[playerid], 102);
	PlayerTextDrawSetShadow(playerid, 		GarageBcg2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, 		GarageBcg2[playerid], 0);
	PlayerTextDrawFont(playerid, 			GarageBcg2[playerid], 0);
	PlayerTextDrawShow(playerid,			GarageBcg2[playerid]);

	GarageInfoText[playerid] = CreatePlayerTextDraw(playerid, 501.850006, 117.488006, "GARAGE INFO");
	PlayerTextDrawLetterSize(playerid, 		GarageInfoText[playerid], 0.336050, 1.023200);
	PlayerTextDrawAlignment(playerid, 		GarageInfoText[playerid], 1);
	PlayerTextDrawColor(playerid, 			GarageInfoText[playerid], -1);
	PlayerTextDrawSetShadow(playerid, 		GarageInfoText[playerid], 0);
	PlayerTextDrawSetOutline(playerid, 		GarageInfoText[playerid], 1);
	PlayerTextDrawFont(playerid, 			GarageInfoText[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid, GarageInfoText[playerid], 51);
	PlayerTextDrawSetProportional(playerid, GarageInfoText[playerid], 1);
	PlayerTextDrawShow(playerid,			GarageInfoText[playerid]);

	GarageInfoTD[playerid] = CreatePlayerTextDraw(playerid, 503.999877, 134.456085, "Vlasnik: Richard Collins~n~Cijena: 10.000~g~$");
	PlayerTextDrawLetterSize(playerid, 		GarageInfoTD[playerid], 0.282599, 0.967758);
	PlayerTextDrawAlignment(playerid, 		GarageInfoTD[playerid], 1);
	PlayerTextDrawColor(playerid, 			GarageInfoTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, 		GarageInfoTD[playerid], 1);
	PlayerTextDrawSetOutline(playerid, 		GarageInfoTD[playerid], 0);
	PlayerTextDrawFont(playerid, 			GarageInfoTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, GarageInfoTD[playerid], 255);
	PlayerTextDrawSetProportional(playerid, GarageInfoTD[playerid], 1);
	PlayerTextDrawShow(playerid,			GarageInfoTD[playerid]);

	GarageCMDTD[playerid] = CreatePlayerTextDraw(playerid, 503.550079, 190.175903, "Raspolozive komande:~n~      /garage lock, /ring, /enter");
	PlayerTextDrawLetterSize(playerid, 		GarageCMDTD[playerid], 0.240599, 0.879841);
	PlayerTextDrawAlignment(playerid, 		GarageCMDTD[playerid], 1);
	PlayerTextDrawColor(playerid, 			GarageCMDTD[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, 		GarageCMDTD[playerid], 1);
	PlayerTextDrawSetOutline(playerid, 		GarageCMDTD[playerid], 0);
	PlayerTextDrawFont(playerid, 			GarageCMDTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, GarageCMDTD[playerid], 255);
	PlayerTextDrawSetProportional(playerid, GarageCMDTD[playerid], 1);
	PlayerTextDrawShow(playerid,			GarageCMDTD[playerid]);
	return 1;
}

stock LoadServerGarages()
{
    mysql_tquery(g_SQL, "SELECT * FROM `server_garages` WHERE 1", "OnServerGaragesLoad", "");
	return 1;
}

forward OnServerGaragesLoad();
public OnServerGaragesLoad()
{
	if( !cache_num_rows() ) return printf( "MySQL Report: No garages exist to load.");
	for( new row = 0; row < cache_num_rows(); row++ ) {
 	    cache_get_value_name_int( row, 		"id"		, GarageInfo[ row ][ gSQLID ]);
		cache_get_value_name_int( row, 		"ownerid"	, GarageInfo[ row ][ gOwnerID ]);
		cache_get_value_name(row, "adress", GarageInfo[ row ][ gAdress ], 16);
		cache_get_value_name_int( row, 		"price"	, GarageInfo[ row ][ gPrice ]);
		cache_get_value_name_int( row, 		"locked"	, GarageInfo[ row ][ gLocked ]);
		cache_get_value_name_int( row, 		"houseid"	, GarageInfo[ row ][ gHouseID ]);
		cache_get_value_name_float( row, 	"enterX"	, GarageInfo[ row ][ gEnterX ]);
		cache_get_value_name_float( row, 	"enterY"	, GarageInfo[ row ][ gEnterY ]);
		cache_get_value_name_float( row, 	"enterZ"	, GarageInfo[ row ][ gEnterZ ]);
		cache_get_value_name_float( row, 	"exitX"		, GarageInfo[ row ][ gExitX ]);
		cache_get_value_name_float( row, 	"exitY"		, GarageInfo[ row ][ gExitY ]);
		cache_get_value_name_float( row, 	"exitZ"		, GarageInfo[ row ][ gExitZ ]);

		GarageInfo[ row ][ gEnterPck ] = CreateDynamicPickup( 19522, 2, GarageInfo[ row ][ gEnterX ], GarageInfo[ row ][ gEnterY ], GarageInfo[ row ][ gEnterZ ], -1, -1, -1, 100.0 );
		Iter_Add(Garages, row);
	}
	printf("MySQL Report: Garages Loaded (%d)!", cache_num_rows());
	return 1;
}

forward HideGaragesTDs(playerid);
public HideGaragesTDs(playerid)
{
	Bit1_Set(r_HDTimer, playerid, false);
	KillTimer(HideGarageTD[playerid]);
    DestroyGarageInfoTD(playerid);
    return 1;
}

/*
	##     ##  #######   #######  ##    ##  ######
	##     ## ##     ## ##     ## ##   ##  ##    ##
	##     ## ##     ## ##     ## ##  ##   ##
	######### ##     ## ##     ## #####     ######
	##     ## ##     ## ##     ## ##  ##         ##
	##     ## ##     ## ##     ## ##   ##  ##    ##
	##     ##  #######   #######  ##    ##  ######
*/
hook OnGameModeInit()
{
	// Medium garage - Fokker (1217.2489, -780.5413, 1086.6)
	CreateObject(18045, 1213.00049, -782.49664, 1087.54016,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19815, 1205.61218, -784.50305, 1087.01575,   0.00000, 0.00000, -270.00000);
	CreateDynamicObject(19817, 1208.56116, -778.80066, 1084.78735,   0.00000, 0.00000, 90.68001);
	CreateDynamicObject(19899, 1206.10083, -781.71649, 1085.54150,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19900, 1205.94482, -785.44696, 1085.54199,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19903, 1209.63611, -781.13446, 1085.54248,   0.00000, 0.00000, 18.54000);
	CreateDynamicObject(8572, 1215.04834, -786.77087, 1085.06506,   0.00000, 0.00000, 180.11971);
	CreateDynamicObject(17951, 1220.39526, -780.23212, 1087.33215,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1499, 1218.05310, -787.04773, 1085.54456,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1265, 1217.97266, -789.41565, 1086.10449,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(923, 1219.40942, -788.97260, 1086.30493,   0.00000, 0.00000, 89.99998);
	CreateDynamicObject(1449, 1218.16089, -788.81873, 1085.92615,   0.00000, 0.00000, -243.24020);
	CreateDynamicObject(3761, 1208.71753, -786.90662, 1086.78064,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19812, 1205.93921, -783.50720, 1085.92163,   0.00000, 0.00000, 55.20001);
	CreateDynamicObject(19812, 1203.97778, -782.39337, 1085.92163,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19812, 1205.96338, -784.40808, 1085.92163,   0.00000, 0.00000, 94.73998);
	CreateDynamicObject(1432, 1219.45557, -784.84296, 1085.54541,   0.00000, 0.00000, 97.44004);
	CreateDynamicObject(1486, 1219.53040, -784.40613, 1086.30005,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1486, 1219.50720, -785.28186, 1086.30005,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1486, 1218.92004, -785.56482, 1086.30005,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1510, 1219.43677, -784.91650, 1086.17188,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1485, 1219.45007, -784.67993, 1086.19336,   12.82200, 0.00000, -80.40000);
	CreateDynamicObject(2103, 1219.82629, -784.80719, 1086.15442,   0.00000, 0.00000, -92.64000);
	CreateDynamicObject(2814, 1219.17896, -784.55261, 1086.15894,   0.00000, 0.00000, 17.82000);
	CreateDynamicObject(1008, 1206.07825, -781.31122, 1086.81116,   0.00000, 0.00000, 88.32000);
	CreateDynamicObject(1081, 1206.74390, -777.69354, 1086.00000,   0.00000, -90.54800, 0.42000);
	CreateDynamicObject(1075, 1207.25146, -777.74976, 1086.10400,   0.00000, -45.65300, 0.00000);


	// Small garages - Fokker (1200.9727, -831.3710, 1085.3000)
	CreateObject(14783, 1205.44080, -831.65717, 1086.28406,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1481, 1213.03027, -834.90918, 1084.69238,   0.00000, 0.00000, -120.00103);
	CreateDynamicObject(19815, 1204.80225, -837.91479, 1085.71106,   0.00000, 0.00000, -180.00011);
	CreateDynamicObject(19903, 1207.36902, -835.89587, 1084.31238,   0.00000, 0.00000, 148.55983);
	CreateDynamicObject(19900, 1204.49084, -837.58392, 1084.31165,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19900, 1205.12305, -837.58392, 1084.31165,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19621, 1204.33582, -837.51392, 1085.26587,   0.00000, 0.00000, 39.54000);
	CreateDynamicObject(1778, 1206.05811, -837.85242, 1084.31433,   0.00000, 0.00000, 203.93990);
	CreateDynamicObject(2102, 1204.98364, -837.52283, 1085.18982,   0.00000, 0.00000, -157.92000);
	CreateDynamicObject(1369, 1212.72717, -836.91260, 1084.88940,   0.00000, 0.00000, -72.71996);
	CreateDynamicObject(11710, 1209.42004, -825.61627, 1087.24194,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19573, 1212.77576, -834.49493, 1084.31445,   -4.92700, 0.00000, -118.02000);
	CreateDynamicObject(2690, 1208.19714, -825.95966, 1084.65320,   0.00000, 0.00000, -315.65979);
	CreateDynamicObject(3761, 1204.77588, -826.36725, 1085.52856,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1440, 1201.72327, -837.08875, 1084.79053,   0.00000, 0.00000, 178.02010);
	CreateDynamicObject(11745, 1203.67896, -837.63696, 1084.42505,   0.00000, 0.00000, -52.92001);

	// Small garages - B-Matt (-502.3650, 1363.9989, 1102.9000)
	CreateObject(14783, -367.88763, 1369.34839, 1100.44275,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14796, -10607.50000, 2900.49438, 717.96722,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(939, -362.65616, 1364.30750, 1099.19995,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1348, -366.14661, 1363.96667, 1099.15002,   0.00000, 0.00000, 42.24000);
	CreateDynamicObject(936, -367.69119, 1374.84241, 1098.94995,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1810, -365.65894, 1374.40613, 1098.47253,   0.00000, 0.00000, 31.02001);
	CreateDynamicObject(921, -365.93686, 1375.26489, 1101.36792,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19377, -370.08722, 1370.54614, 1098.30005,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19377, -370.15436, 1361.86792, 1098.30005,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19377, -363.09879, 1367.87146, 1098.30005,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19377, -363.06467, 1371.36389, 1098.30005,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(14798, -499.40201, 1363.60205, 1102.44067,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14797, -497.76651, 1363.62573, 1102.55005,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1712, -498.35669, 1361.98804, 1101.25000,   0.00000, 0.00000, 232.13989);
	CreateDynamicObject(19377, -500.07056, 1370.29004, 1101.12000,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19377, -500.20059, 1359.46997, 1101.09998,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19377, -506.23901, 1364.88647, 1101.09998,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19377, -491.63101, 1368.60925, 1101.10999,   0.00000, 90.00000, 0.00000);

	
	//Modern garage - Pajo (1946.9453, -1042.1703, 17939.9)
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19446,1943.900,-1041.300,17940.599,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1943.900,-1050.900,17940.599,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1943.900,-1031.699,17940.599,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1943.900,-1041.300,17944.099,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1948.599,-1030.900,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1948.599,-1052.000,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1958.199,-1052.000,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1958.199,-1030.900,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1943.900,-1050.900,17944.099,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1943.900,-1031.699,17944.099,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1948.800,-1030.900,17944.099,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1958.400,-1030.900,17944.099,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1948.800,-1052.000,17944.099,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1958.400,-1052.000,17944.099,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1967.800,-1052.000,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1968.000,-1052.000,17944.099,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1967.800,-1030.900,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1968.000,-1030.800,17944.099,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19384,1972.500,-1032.599,17940.599,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1972.500,-1047.699,17940.599,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1972.500,-1035.599,17944.000,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1972.500,-1045.199,17944.000,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1972.500,-1054.800,17944.000,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1977.300,-1043.000,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1980.599,-1038.400,17940.599,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1980.599,-1028.800,17940.599,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(19446,1977.400,-1030.800,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1975, "texttest", "kb_red", 0);
	tmpobjid = CreateDynamicObject(2637,1974.599,-1030.699,17941.000,90.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1967.300,-1035.800,17943.300,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1967.300,-1045.400,17943.300,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1967.300,-1055.000,17943.300,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1956.800,-1035.699,17943.300,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1956.800,-1045.300,17943.300,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1956.800,-1054.900,17943.300,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1946.300,-1035.699,17943.300,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1946.300,-1045.300,17943.300,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1946.300,-1054.900,17943.300,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1977.800,-1038.300,17942.400,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19379,1977.699,-1028.699,17942.400,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);

	CreateObject(19377,1946.199,-1041.300,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1946.400,-1050.900,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1946.300,-1031.699,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1956.900,-1050.900,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1956.699,-1041.300,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1956.800,-1031.699,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1967.199,-1050.900,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1967.199,-1041.300,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1967.199,-1031.699,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1977.699,-1034.599,17938.800,0.000,90.000,0.000);
	CreateObject(19377,1977.699,-1044.099,17938.800,0.000,90.000,0.000);
	CreateDynamicObject(3352,1944.000,-1041.900,17940.199,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1649,1972.400,-1036.400,17940.599,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1649,1972.400,-1040.800,17940.599,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1649,1972.599,-1036.300,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1649,1972.599,-1040.699,17940.599,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2571,1976.800,-1032.599,17938.900,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2271,1978.300,-1031.400,17940.599,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1731,1980.300,-1032.099,17941.099,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1744,1974.199,-1030.900,17940.000,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2206,1975.699,-1040.199,17938.900,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1714,1976.699,-1042.000,17938.900,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1705,1977.900,-1037.500,17938.900,0.000,0.000,332.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1828,1976.699,-1035.800,17938.900,0.000,0.000,30.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1705,1974.300,-1038.099,17938.900,0.000,0.000,33.995,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2010,1973.000,-1042.400,17938.900,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2010,1980.000,-1042.400,17938.900,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(3963,1976.699,-1042.900,17940.699,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1667,1978.500,-1032.000,17939.500,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1667,1978.300,-1031.699,17939.500,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1664,1977.199,-1040.300,17940.000,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1667,1977.099,-1040.500,17939.921,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1491,1972.500,-1031.800,17938.900,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1438,1945.699,-1032.699,17938.900,0.000,0.000,74.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1190,1944.400,-1037.199,17939.099,0.000,264.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1190,1944.199,-1037.400,17939.099,0.000,263.919,304.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1097,1944.199,-1035.300,17939.400,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1098,1972.400,-1044.599,17940.900,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1097,1972.400,-1047.400,17940.900,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1080,1972.300,-1050.300,17940.900,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1079,1948.199,-1031.000,17942.199,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1078,1952.000,-1031.000,17940.300,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1077,1956.400,-1031.000,17942.099,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1075,1961.500,-1031.000,17940.300,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1075,1966.199,-1031.000,17942.199,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(11391,1947.500,-1051.000,17940.199,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1001,1944.400,-1049.599,17939.800,0.000,64.000,338.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1221,1944.599,-1048.800,17939.300,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2964,1968.599,-1045.099,17938.900,0.000,0.000,312.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(3000,1968.800,-1045.199,17939.851,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(3003,1968.300,-1044.699,17939.851,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(3002,1969.000,-1044.900,17939.851,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2999,1969.400,-1045.500,17939.851,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2998,1968.800,-1045.400,17939.851,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2997,1968.400,-1044.500,17939.851,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(338,1967.900,-1044.099,17939.099,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(338,1967.699,-1044.300,17939.099,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1186,1969.599,-1051.699,17939.099,0.000,266.000,172.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1186,1970.300,-1051.500,17939.099,0.000,249.995,75.996,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(14826,1956.099,-1052.800,17939.699,0.000,0.000,314.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1712,1967.000,-1051.300,17938.900,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18608,1948.199,-1044.900,17944.058,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18608,1957.400,-1045.099,17944.058,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18608,1966.500,-1045.199,17944.058,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if( Bit1_Get(r_HDTimer, playerid) ) {
   		KillTimer(HideGarageTD[playerid]);
   		Bit1_Set(r_HDTimer, playerid, false);
    }
    if( GarageBuyer[ playerid ] != INVALID_PLAYER_ID ) {
        new
            giveplayerid = GarageBuyer[ playerid ];
        GarageSeller[ giveplayerid ]	= INVALID_PLAYER_ID;
        GaragePrice[ giveplayerid ] 	= 0;
        GarageBuyer[ playerid ]         = INVALID_PLAYER_ID;
    }
    if( GarageSeller[ playerid ] != INVALID_PLAYER_ID ) {
    	GarageBuyer[ GarageSeller[ playerid ] ] = INVALID_PLAYER_ID;
    	GarageSeller[ playerid ]	= INVALID_PLAYER_ID;
        GaragePrice[ playerid ] 	= 0;
    }
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if( dialogid == DIALOG_GARAGE_SELL ) {
		if(response) {
			new
				seller = GarageSeller[ playerid ];
			if( seller == INVALID_PLAYER_ID ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Nitko vam nije ponudio prodaju garaze!");
			if( !IsPlayerConnected(seller) ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Prodavac nije online!");
			if( AC_GetPlayerMoney(playerid) < GaragePrice[ playerid ] ) return SendFormatMessage(playerid, MESSAGE_TYPE_ERROR, "Nemate dovoljno novaca (%d$)!", GaragePrice[ playerid ]);
			
			new
				garage = PlayerInfo[ seller ][ pGarageKey ];
			
			PlayerInfo[ playerid ][ pGarageKey ]    = PlayerInfo[ seller ][ pGarageKey ];
			GarageInfo[ garage ][ gOwnerID ] 		= PlayerInfo[ playerid ][ pSQLID ];
			PlayerInfo[ seller ][ pGarageKey ] 		= -1;
			
			new
				query[64];
			format(query, 64, "UPDATE `server_garages` SET `ownerid` = '%d' WHERE `id` = '%d'",
				GarageInfo[ garage ][ gOwnerID ],
				GarageInfo[ garage ][ gSQLID ]
			);
			mysql_tquery(g_SQL, query, "", "");
			
			PlayerToPlayerMoneyTAX( playerid, seller, GaragePrice[ playerid ], true, LOG_TYPE_GARAGESELL); // prodaja garaze igrac igracu koja se oporezuje
			
			GarageSeller[ playerid ]	= INVALID_PLAYER_ID;
			GarageBuyer[ seller ] 		= INVALID_PLAYER_ID;
			GaragePrice[ playerid ] 	= 0;
			
			GameTextForPlayer(playerid, "~g~Garaza kupljena", 2000, 1);
		}
	}
	return 0;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
	foreach(new garage: Garages) {
		if( GarageInfo[ garage ][ gEnterPck ] == pickupid ) {
			new
				textString[ 128 ];
			if( !GarageInfo[ garage ][ gOwnerID ] ) {
				CreateGarageInfoTD(playerid);
	  			format( textString, 128, "Garaza je na prodaju~n~Adresa: %s~n~Cijena: %d~g~$~n~",
	                GarageInfo[ garage ][ gAdress ],
					GarageInfo[ garage ][ gPrice ]
				);
				PlayerTextDrawSetString( playerid, GarageCMDTD[ playerid ], "Raspolozive komande:~n~      /enter, /garage buy");
			} else {
				CreateGarageInfoTD(playerid);
				format( textString, 128, "Vlasnik: %s~n~Adresa: %s~n~Cijena: %d~g~$",
					GetPlayerNameFromSQL(GarageInfo[ garage ][ gOwnerID ]),
					GarageInfo[ garage ][ gAdress ],
					GarageInfo[ garage ][ gPrice ]
				);
				PlayerTextDrawSetString( playerid, GarageCMDTD[ playerid ], "Raspolozive komande:~n~      /genter, /garage lock (vlasnik)");
			}

			PlayerTextDrawSetString( playerid, GarageInfoTD[ playerid ], textString );
			Bit1_Set(r_HDTimer, playerid, true);
			HideGarageTD[playerid] = SetTimerEx("HideGaragesTDs", 3000, false, "i", playerid);
			break;
		}
	}
	return 1;
}

/*
	 ######  ##     ## ########
	##    ## ###   ### ##     ##
	##       #### #### ##     ##
	##       ## ### ## ##     ##
	##       ##     ## ##     ##
	##    ## ##     ## ##     ##
	 ######  ##     ## ########
*/
CMD:create_garage(playerid, params[])
{
	if( PlayerInfo[ playerid ][ pAdmin ] < 1337 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste ovlasteni za koristenje ove komande!");

	new
		type, price, houseid,
		garage = Iter_Free(Garages),
		adress[16];

	if( sscanf(params, "ddds[16] ", type, price, houseid, adress) ) return SendClientMessage(playerid, COLOR_RED, "USAGE: /create_garage [tip][cijena][houseid][adresa]");
	if( type > 3 || type < 0) return SendClientMessage(playerid, COLOR_RED, "USAGE: /create_garage [tip] [cijena] [houseid] [adresa]"), SendClientMessage(playerid, COLOR_GREY, "[!] - Ako ne zelite da garaza bude spojena uz kucu unesite pod 'houseid' -> 9999'.");
	if(strlen(adress) < 1 || strlen(adress) > 16) return SendErrorMessage(playerid, "Adresa mora imati minimalno 1, a maksimalno 16 slova!");
	
	GetPlayerPos(playerid, GarageInfo[ garage ][ gEnterX ], GarageInfo[ garage ][ gEnterY ], GarageInfo[ garage ][ gEnterZ ]);
	GarageInfo[ garage ][ gOwnerID ] 			= 0;
	GarageInfo[ garage ][ gPrice ] 				= price;
	GarageInfo[ garage ][ gHouseID ] 			= houseid;
	GarageInfo[ garage ][ gLocked ] 			= 1;
	GarageInfo[ garage ][ gExitX ]				= GaragesIntInfo[ type ][ giX ];
	GarageInfo[ garage ][ gExitY ]				= GaragesIntInfo[ type ][ giY ];
	GarageInfo[ garage ][ gExitZ ]				= GaragesIntInfo[ type ][ giZ ];
	strreplace(adress, '_', ' ');
	format(GarageInfo[ garage ][ gAdress ], 16, adress);

	new
	    query[ 600 ];
	format(query, 600, "INSERT INTO `server_garages` (`ownerid`, `adress`, `price`, `locked`, `houseid`, `enterX`, `enterY`, `enterZ`, `exitX`, `exitY`, `exitZ`) VALUES ('0', '%q', '%d', '0', '%d', '%.4f', '%.4f', '%.4f', '%.4f', '%.4f', '%.4f')",
		GarageInfo[ garage ][ gAdress ],
		GarageInfo[ garage ][ gPrice ],
		GarageInfo[ garage ][ gHouseID ],
		GarageInfo[ garage ][ gEnterX ],
		GarageInfo[ garage ][ gEnterY ],
		GarageInfo[ garage ][ gEnterZ ],
		GarageInfo[ garage ][ gExitX ],
		GarageInfo[ garage ][ gExitY ],
		GarageInfo[ garage ][ gExitZ ]
	);
	mysql_tquery(g_SQL, query, "OnGarageCreates", "i", garage);
	GarageInfo[ garage ][ gEnterPck ] = CreateDynamicPickup( 19522, 2, GarageInfo[ garage ][ gEnterX ], GarageInfo[ garage ][ gEnterY ], GarageInfo[ garage ][ gEnterZ ], -1, -1, -1, 100.0 );
	Iter_Add(Garages, garage);
	return 1;
}

CMD:garage(playerid, params[])
{
	new
	    param[10],
		garage = PlayerInfo[playerid][pGarageKey];
	if(sscanf(params, "s[10] ", param)) {
	    SendClientMessage(playerid, COLOR_RED, "USAGE: /garage [odabir]");
	    SendClientMessage(playerid, COLOR_GREY, "[ODABIR]: buy - sell - lock - locate - changeint(admin)");
	    return 1;
	}
	if( !strcmp(param, "lock", true) ) {
		if( garage == -1 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ne posjedujete garazu!");
		if( IsPlayerInRangeOfPoint(playerid, 10.0, GarageInfo[ garage ][ gEnterX ], GarageInfo[ garage ][ gEnterY ], GarageInfo[ garage ][ gEnterZ ]) || Bit16_Get( gr_PlayerInGarage, playerid ) != 9999 ) {
			if( !GarageInfo[ garage ][ gLocked ] ) {
			    GarageInfo[ garage ][ gLocked ] = 1;
			    GameTextForPlayer(playerid, "~r~Garaza zakljucana", 2000, 1);
			    
			    new
				    string[64];
				format(string, sizeof(string), "* %s zakljucava garazu.", GetName(playerid));
                SendClientMessage(playerid, COLOR_PURPLE, string);
		 		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 20, 20000);
			}
			else if( GarageInfo[ garage ][ gLocked ] ) {
			    GarageInfo[ garage ][ gLocked ] = 0;
		     	GameTextForPlayer(playerid, "~g~Garaza otkljucana", 2000, 1);

				new
				    string[64];
				format(string, sizeof(string), "* %s otkljucava garazu.", GetName(playerid));
                SendClientMessage(playerid, COLOR_PURPLE, string);
		 		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 20, 20000);
			}
		} else return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste blizu svoje garaze!");
	}
	else if( !strcmp(param, "buy", true) ) {
        new
	        nearGarage = GetNearGarage(playerid, 5.0);
		if( garage != -1 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Vec posjedujete garazu!");
	    if( nearGarage == -1 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste blizu garaza!");
		if( AC_GetPlayerMoney(playerid) < GarageInfo[ nearGarage ][ gPrice ] ) return SendFormatMessage(playerid, MESSAGE_TYPE_ERROR, "Nemate dovoljno novca (%d$)", GarageInfo[ nearGarage ][ gPrice ]);
		if( GarageInfo[ nearGarage ][ gHouseID ] != INVALID_HOUSE_ID && GarageInfo[ nearGarage ][ gHouseID ] != PlayerInfo[ playerid ][ pHouseKey ] ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Morate posjedovati kucu na kojoj je garaza!");

		PlayerToBudgetMoney(playerid, GarageInfo[ nearGarage ][ gPrice ]); // Novac ide u proracun
		PlayerInfo[ playerid ][ pGarageKey ]    = nearGarage;
		GarageInfo[ nearGarage ][ gOwnerID ] 	= PlayerInfo[ playerid ][ pSQLID ];
		GarageInfo[ nearGarage ][ gLocked ] 	= 1;
		
		new
		    query[128];
		format(query, 128, "UPDATE `server_garages` SET `ownerid` = '%d', `locked` = '1' WHERE `id` = '%d'",
		    GarageInfo[ nearGarage ][ gOwnerID ],
		    GarageInfo[ nearGarage ][ gSQLID ]
		);
		mysql_tquery(g_SQL, query, "", "");
		SendFormatMessage(playerid, MESSAGE_TYPE_SUCCESS, "Uspjesno ste kupili garazu za (%d$)", GarageInfo[ nearGarage ][ gPrice ]);
	}
	else if( !strcmp(param, "sell", true) ) {
        if( garage == -1 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ne posjedujete garazu!");
		if( GarageBuyer[ playerid ] != INVALID_PLAYER_ID ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Vec ste nekome ponudili prodaju garaze!");
		new
	        giveplayerid,
			price;
		if( sscanf( params, "s[10]ud", param, giveplayerid, price ) ) return SendClientMessage(playerid, COLOR_RED, "USAGE: /garage sell [playerid/dio imena][cijena]");
		if( !IsPlayerConnected(giveplayerid) || !SafeSpawned[giveplayerid] ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Taj igrac nije sigurno spawnan/online!");
        if( !ProxDetectorS(5.0, playerid, giveplayerid) ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Taj igrac nije blizu vas!");
		if( PlayerInfo[ giveplayerid ][ pGarageKey ] != -1 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Kupac vec posjeduje garazu!");
		if( GarageInfo[ garage ][ gHouseID ] != INVALID_HOUSE_ID && PlayerInfo[ giveplayerid ][ pHouseKey ] != GarageInfo[ garage ][ gHouseID ] ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Korisnik nema tu kucu!");
		if( price < 5000 || price > 999999) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Prodajna cijena garaze ne moze biti manja od 5000$, ni veca od 999 999$!");
		
		GarageSeller[ giveplayerid ]= playerid;
		GarageBuyer[ playerid ] 	= giveplayerid;
		GaragePrice[ giveplayerid ] = price;
		
		va_ShowPlayerDialog(giveplayerid, DIALOG_GARAGE_SELL, DIALOG_STYLE_MSGBOX, "%s vam zeli prodati garazu", "Zelite li kupiti garazu od %s za %d$?", "Kupi", "Odustani",
			GetName(playerid,true),
			GetName(playerid, true),
			price
		);
	}
	else if( !strcmp(param, "locate", true) ) {
	    if( garage == -1 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ne posjedujete garazu!");
	    SetPlayerCheckpoint(playerid, GarageInfo[ garage ][ gEnterX ], GarageInfo[ garage ][ gEnterY ], GarageInfo[ garage ][ gEnterZ ], 5.0);
	}
	else if( !strcmp(param, "changeint", true) ) {
	    if( PlayerInfo[ playerid ][ pAdmin ] < 1337 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste ovlasteni za koristenje ove komande!");
	    new
	        type, garageid;
		if( sscanf(params, "s[10]ii", param, garageid, type) ) return SendClientMessage(playerid, COLOR_RED, "USAGE: /garage changeint [garageid][tip (0-3)]");
		if( type > 3 || type < 0) return SendClientMessage(playerid, COLOR_RED, "USAGE: /garage changeint [tip (0-3)]");
		if( !Iter_Contains(Garages, garageid )) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Taj ID garaze ne postoji!");

		GarageInfo[ garageid ][ gExitX ]				= GaragesIntInfo[ type ][ giX ];
		GarageInfo[ garageid ][ gExitY ]				= GaragesIntInfo[ type ][ giY ];
		GarageInfo[ garageid ][ gExitZ ]				= GaragesIntInfo[ type ][ giZ ];

	    new
		    query[ 256 ];
		format(query, sizeof(query), "UPDATE `server_garages` SET `exitX` = '%f', `exitY` = '%f', `exitZ` = '%f' WHERE `id` = '%d'",
			GarageInfo[ garageid ][ gExitX ],
			GarageInfo[ garageid ][ gExitY ],
			GarageInfo[ garageid ][ gExitZ ],
			GarageInfo[ garageid ][ gSQLID ]
		);
		mysql_tquery(g_SQL, query, "", "");
	}
	else if( !strcmp(param, "delete", true) ) {
	    if( PlayerInfo[ playerid ][ pAdmin ] < 1337 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste ovlasteni za koristenje ove komande!");
	    new
		    garageid = -1;
		foreach(new x: Garages) {
			if( GarageInfo[ x ][ gEnterX ] != 0.0 ) {
				if( IsPlayerInRangeOfPoint( playerid, 5.0, GarageInfo[ x ][ gEnterX ], GarageInfo[ x ][ gEnterY ], GarageInfo[ x ][ gEnterZ ] ) ) {
					garageid = x;
					break;
				}
			}
		}
		if( garageid == -1 ) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste blizu garaze!");
		new
		    query[ 256 ];
		format(query, 256, "DELETE FROM `server_garages` WHERE `id` = '%d' LIMIT 1", GarageInfo[garageid][gSQLID]);
		mysql_tquery(g_SQL, query, "", "");

		if(IsValidDynamicPickup(GarageInfo[ garageid ][ gEnterPck ])) {
		    DestroyDynamicPickup(GarageInfo[ garageid ][ gEnterPck ]);
		}
		Iter_Remove(Garages, garageid);
		
		GarageInfo[ garageid ][ gOwnerID ] 				= 0;
		GarageInfo[ garageid ][ gPrice ] 				= 0;
		GarageInfo[ garageid ][ gHouseID ] 				= 0;
		GarageInfo[ garageid ][ gLocked ] 				= 0;
		GarageInfo[ garageid ][ gEnterX ]				= 0.0;
		GarageInfo[ garageid ][ gEnterY ]				= 0.0;
		GarageInfo[ garageid ][ gEnterZ ]				= 0.0;
		GarageInfo[ garageid ][ gExitX ]				= 0.0;
		GarageInfo[ garageid ][ gExitY ]				= 0.0;
		GarageInfo[ garageid ][ gExitZ ]				= 0.0;
	}
	else {
	    SendClientMessage(playerid, COLOR_RED, "USAGE: /garage [odabir]");
	    SendClientMessage(playerid, COLOR_GREY, "[ODABIR]: buy - sell - lock - locate - changeint(admin) - delete(admin)");
	    return 1;
	}
	return 1;
}

CMD:genter(playerid, params[])
{
	new
	    garage = -1;
	foreach(new x: Garages) {
		if( GarageInfo[ x ][ gEnterX ] != 0.0 ) {
			if( IsPlayerInRangeOfPoint( playerid, 5.0, GarageInfo[ x ][ gEnterX ], GarageInfo[ x ][ gEnterY ], GarageInfo[ x ][ gEnterZ ] ) ) {
				garage = x;
				break;
			}
		}
	}
    if( garage != -1 ) {
    	new
			vehicleid = GetPlayerVehicleID(playerid);
		if( PlayerInfo[ playerid ][ pSQLID ] == GarageInfo[ garage ][ gOwnerID ] || !GarageInfo[ garage ][ gLocked ] ) {
			if( GarageInfo[ garage ][ gOwnerID ] == PlayerInfo[ playerid ][ pSQLID ] ) GameTextForPlayer( playerid, "~w~Dobrodosli u garazu", 800, 1 );

			if( !IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER ) {
				SetPlayerPosEx( playerid, GarageInfo[ garage ][ gExitX ], GarageInfo[ garage ][ gExitY ], GarageInfo[ garage ][ gExitZ ], GarageInfo[ garage ][ gSQLID ], 5, true );
   			}
			else if( IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) == PLAYER_STATE_DRIVER ) {
				TogglePlayerControllable(playerid, 0);

				new Float: X, Float: Y, Float: Z, Float: A;
				GetVehiclePos(vehicleid, X, Y, Z);
				GetVehicleZAngle(vehicleid, A);

				PlayerSafeExit[playerid][giX] = X;
				PlayerSafeExit[playerid][giY] = Y;
				PlayerSafeExit[playerid][giZ] = Z;
				PlayerSafeExit[playerid][giRZ] = A;
				SetVehiclePosEx(playerid, GarageInfo[ garage ][ gExitX ], GarageInfo[ garage ][ gExitY ] + 1.5, GarageInfo[ garage ][ gExitZ ], GarageInfo[ garage ][ gSQLID ], 5, true);
				SetVehicleZAngle(vehicleid, 90.0);
			}
			Bit16_Set( gr_PlayerInGarage, playerid, garage );
			DestroyGarageInfoTD( playerid );
		} else return GameTextForPlayer( playerid, "~r~Zakljucano", 1000, 1 );
		return 1;
	}
	return 1;
}
CMD:asellgarage(playerid, params[])
{
    new garage,
	globalstring[184],
		TmpQuery[158];
    if(sscanf(params, "i", garage)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /asellgarage [garageid]");
	
	if( !Iter_Contains(Garages, garage )) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Taj ID garaze ne postoji!");
		
	if(GarageInfo[garage][gSQLID] == 0)
		return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ta garaza ne postoji!");
	
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{	
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pGarageKey] == garage)
			{
				PlayerInfo[i][pGarageKey] = -1;
				SendClientMessage(i, COLOR_RED, "[ ! ] Garaza vam je iseljena od strane admina!");
				break;
			}				
		}
		
		format( TmpQuery, sizeof(TmpQuery), "UPDATE `server_garages` SET `ownerid` = '0' WHERE `id` = '%d'", 
			GarageInfo[garage][gSQLID]
		);
		mysql_tquery(g_SQL, TmpQuery, "", "");
		
		GarageInfo[garage][gOwnerID] 				= 0;
		GarageInfo[ garage ][ gLocked ] 			= 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		SendMessage(playerid, MESSAGE_TYPE_SUCCESS, "Prodao si garazu admin komandom!");
		format(globalstring, sizeof(globalstring), "*Admin %s je iselio garazu %i.",GetName(playerid, false), garage);
		SendAdminMessage(COLOR_LIGHTBLUE, globalstring);
		LogASellBiznis(globalstring);
	}
	else SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste ovlasteni za koristenje ove komande!");
	return 1;
}
CMD:garageo(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste ovlasteni za koristenje ove komande!");
	new
		garage;
	if( sscanf( params, "i", garage ) ) return SendClientMessage(playerid, COLOR_RED, "USAGE: /garageo [garageid]");
	if( 0 <= garage <= MAX_GARAGES ) 
	{
		if(GarageInfo[garage][gSQLID] == 0)
			return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ta garaza ne postoji!");
		
		SetPlayerPosEx(playerid, GarageInfo[ garage ][ gEnterX ], GarageInfo[ garage ][ gEnterY ], GarageInfo[ garage ][ gEnterZ ], 0, 0, true);
	} 
	else 
		SendClientMessage(playerid, COLOR_RED, "USAGE: /garageo [garageid]");
	
	return 1;
}
//khawaja garages
CMD:garageentrance(playerid, params[])
{
	new proplev;
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Nisi 1337!");
	if (sscanf(params, "i", proplev)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /garageentrance [garageid]");
	if(proplev >= MAX_GARAGES || proplev < 0) return SendClientMessage(playerid,COLOR_RED, "Nema garaze tog ID-a!");

	new
		Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);

	GarageInfo[proplev][gEnterX] = X;
	GarageInfo[proplev][gEnterY] = Y;
	GarageInfo[proplev][gEnterZ] = Z;

	DestroyDynamicPickup(GarageInfo[ proplev ][ gEnterPck ]);
    GarageInfo[ proplev ][ gEnterPck ] = CreateDynamicPickup( 19522, 2, GarageInfo[ proplev ][ gEnterX ], GarageInfo[ proplev ][ gEnterY ], GarageInfo[ proplev ][ gEnterZ ], -1, -1, -1, 100.0 );

	new
		bigquery[ 256 ];
	format(bigquery, sizeof(bigquery), "UPDATE `server_garages` SET `enterX` = '%f', `enterY` = '%f', `enterZ` = '%f' WHERE `id` = '%d'",
		X,
		Y,
		Z,
		GarageInfo[proplev][ gSQLID ]
	);
	mysql_tquery(g_SQL, bigquery, "");
    return 1;
}

CMD:customgarageint(playerid, params[])
{
    new
		Float:iX, Float:iY, Float:iZ,
		garageid;

	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_RED, "GRESKA: Niste ovlasteni za koristenje ove komande!");
	if(sscanf(params, "ifff", garageid, iX, iY, iZ)) {
		SendClientMessage(playerid, COLOR_RED, "USAGE: /customgarageint [garageid][X][Y][Z]");
		SendClientMessage(playerid, COLOR_GREY, "NOTE: Taj ID MORA biti u skripti!");
		return 1;
	}
	if(garageid >= MAX_GARAGES || garageid < 0) return SendClientMessage(playerid,COLOR_RED, "Nema garaze tog ID-a!");

	GarageInfo[garageid][gExitX] 		= iX;
	GarageInfo[garageid][gExitY] 		= iY;
	GarageInfo[garageid][gExitZ] 		= iZ;

	new
		bigquery[256];
	format(bigquery, sizeof(bigquery), "UPDATE `server_garages` SET `exitX` = '%f', `exitY` = '%f', `exitZ` = '%f' WHERE `id` = '%d'",
		GarageInfo[garageid][gExitX],
		GarageInfo[garageid][gExitY],
		GarageInfo[garageid][gExitZ],
		GarageInfo[garageid][gSQLID]
	);
	mysql_tquery(g_SQL, bigquery, "");
	return 1;
}
