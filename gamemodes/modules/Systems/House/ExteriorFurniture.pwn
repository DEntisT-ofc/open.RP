#include <YSI\y_hooks>

/*
	########  ######## ######## #### ##    ## ########  ######  
	##     ## ##       ##        ##  ###   ## ##       ##    ## 
	##     ## ##       ##        ##  ####  ## ##       ##       
	##     ## ######   ######    ##  ## ## ## ######    ######  
	##     ## ##       ##        ##  ##  #### ##             ## 
	##     ## ##       ##        ##  ##   ### ##       ##    ## 
	########  ######## ##       #### ##    ## ########  ######  
*/
#define EXTERIOR_OBJS_VIP_GOLD				(25)
#define EXTERIOR_OBJS_VIP_SILVER			(20)
#define EXTERIOR_OBJS_VIP_BRONZE			(15)
#define EXTERIOR_OBJS_VIP_NONE				(10)

#define MAX_EXTERIOR_OBJECTS				(60)

#define EXTERIOR_DRAW_DISTANCE				(50.0)
#define EXTERIOR_HOUSE_DISTANCE				(30.0)

#define EXT_EDIT_TYPE_BUY					(1)
#define EXT_EDIT_TYPE_EDIT					(2)

#define EXTERIOR_TYPE_PLANTS				(1)
#define EXTERIOR_TYPE_FURNITURE				(2)
#define EXTERIOR_TYPE_MISC					(3)

/*
	##     ##    ###    ########   ######  
	##     ##   ## ##   ##     ## ##    ## 
	##     ##  ##   ##  ##     ## ##       
	##     ## ##     ## ########   ######  
	 ##   ##  ######### ##   ##         ## 
	  ## ##   ##     ## ##    ##  ##    ## 
	   ###    ##     ## ##     ##  ######  
*/

// rBits
static stock
	Bit4: r_ExteriorEditType	<MAX_PLAYERS>,
	Bit16:r_ExteriorObjectsId	<MAX_PLAYERS>,
	Bit16:r_ExteriorEditId		<MAX_PLAYERS>,
	Bit16:r_ExteriorBuyType		<MAX_PLAYERS>;
/*
	######## ##    ## ##     ## ##     ##  ######  
	##       ###   ## ##     ## ###   ### ##    ## 
	##       ####  ## ##     ## #### #### ##       
	######   ## ## ## ##     ## ## ### ##  ######  
	##       ##  #### ##     ## ##     ##       ## 
	##       ##   ### ##     ## ##     ## ##    ## 
	######## ##    ##  #######  ##     ##  ######  
*/

enum E_HOUSE_EXTERIOR_DATA
{
	heSQLID[EXTERIOR_OBJS_VIP_GOLD],
	heObjectId[EXTERIOR_OBJS_VIP_GOLD],
	heHouseId[EXTERIOR_OBJS_VIP_GOLD],
	heModelId[EXTERIOR_OBJS_VIP_GOLD],
	Float:hePosX[EXTERIOR_OBJS_VIP_GOLD],
	Float:hePosY[EXTERIOR_OBJS_VIP_GOLD],
	Float:hePosZ[EXTERIOR_OBJS_VIP_GOLD],
	Float:heRotX[EXTERIOR_OBJS_VIP_GOLD],
	Float:heRotY[EXTERIOR_OBJS_VIP_GOLD],
	Float:heRotZ[EXTERIOR_OBJS_VIP_GOLD]
}
new ExteriorInfo[MAX_HOUSES][E_HOUSE_EXTERIOR_DATA];

enum E_PLAYER_EXTERIOR_DATA
{
	peObjectId,
	peModelId,
	pePrice,
	Float:pePosX,
	Float:pePosY,
	Float:pePosZ,
	Float:peRotX,
	Float:peRotY,
	Float:peRotZ	
}
static stock
	PlayerExteriorInfo[MAX_PLAYERS][E_PLAYER_EXTERIOR_DATA];

enum E_EXTERIOR_PLANTS_DATA
{
	epModelid,
	epName[32],
	epPrice
}
static stock
	ExteriorPlants[][E_EXTERIOR_PLANTS_DATA] = {
		{ 628, "Palma", 250 },
		{ 2253, "Cvijece u kalju", 150 },
		{ 2244, "Cvijece u kalju1", 150 },
		{ 869, "Malo cvijece", 75 },
		{ 870, "Cvijece", 60 },
		{ 802, "Grmlje2", 120 },
		{ 753, "Mali kakstusi", 650 },
		{ 808, "Srednje grmlje", 420 },
		{ 871, "Srednje cvijece", 245 },
		{ 3810, "Visece cvijece", 700 },
		{ 3802, "Visece cvijece1", 700 },
		{ 3439, "Cvijece u stupu",	800 },
		{ 948, "Cvijece u betonskoj vazi",	700 },
		{ 639, "Brsljan", 150 },
		{ 2901, "Marijuana", 200 }
	};

enum E_EXTERIOR_FURNITURE_DATA
{
	efModelid,
	efName[32],
	efPrice
}
static stock
	ExteriorFurniture[][E_EXTERIOR_FURNITURE_DATA] = {
		{ 1255, "Ljezaljka",  500 },
		{ 1280, "Klupa", 50 },
		{ 2370, "Stol", 430 },
		{ 1432, "Stol i stolice", 250 },
		{ 1594, "Stol i stolice2", 180 },
		{ 1648, "Peskir", 380 },
		{ 1421, "Kutije", 150 },
		{ 2452, "Frizider", 600 },
		{ 946,  "Kos", 800 },
		{ 11319, "Garazna vrata", 900 },
		{ 11686, "Sank", 1000 },
		{ 11725, "Kamin", 1500 },
		{ 2901, "Marijuana", 200 },
		{ 2069, "Lampa", 150 },
		{ 1646, "Ljezaljka2", 200 },
        { 1645, "Ljezaljka3", 250 },
        { -2037, "Laptop",   800 },
		{ 941, "Radni stol", 250 },
		{ 2627, "Traka za trcanje", 300 },
		{ 2630, "Fiksni bicikl", 200 },
		{ 2629, "Bench1", 300 },
		{ 2628, "Bench2", 150 },
		{ 2631, "Gym Prostirka1", 150 },
		{ 2632, "Gym Prostirka2", 150 },
		{ 11727, "Zidna lampa", 100 },
		{ 1711, "Fotelja", 100 },
		{ 1712, "Kauc", 200 }
	};


enum E_EXTERIOR_MISC_DATA
{
	emModelid,
	emName[16],
	emPrice
}
static stock
	ExteriorMisc[][E_EXTERIOR_MISC_DATA] = {
		{ 1481	, "Rostilj"				, 320 },
		{ -2039	, "Piksla"				, 320 },
		{ 2680	, "Katanac"				, 80 },
		{ 2048	, "Zastava1"			, 50 },
		{ 2063	, "Police"		    	, 500 },
		{ 1328	, "Kanta za smece"		, 100 },
		{ 2047	, "Zastava2"			, 50 },
		{ 11245	, "LS Zastava"			, 100 },
		{ 1966	, "Garazna vrata"		, 625 },
		{ 19897	, "Kutija cigara"		, 20  },
		{ 19831	, "Rostilj2"			, 345 },
		{ 1946	, "Lopta"				, 50  },
		{ 1215	, "Stupic"				, 120 },
		{ 910	, "Kontenjer"			, 450 },
		{ 970	, "Ograda"				, 100 },
		{ 1408	, "Drvena ograda"		, 150 },
		{ 1483	, "Nadstrjesnica"		, 1000},
		{ 3031	, "Radar"				, 500 },
		{ 2919	, "Torba"				, 120 },
		{ 19624 , "Kovceg"				, 150 },
		{ 19900	, "Tool box1"			, 800 },
		{ 19921 , "Tool box2"			, 100 },
		{ 19621 , "Kanister"			, 50  },
		{ 19632 , "Drvo i vatra"		, 150 },
		{ 19860 , "Vrata1"				, 150 },
		{ 1505  , "Vrata2"				, 150 },
		{ 1569 	, "Vrata3"				, 150 },
		{ 11743 , "Kafe aparat"		    , 100 },
		{ 2229 	, "Zvucnik1"		    , 100 },
		{ 2233 	, "Zvucnik2"		    , 150 },
		{ 1958	, "Mikseta1"            , 250 },
		{ 14820	, "Mikseta2"            , 300 },
		{ 3031	, "Satelit"             , 200 },
		{ 1670	, "Jelo za stol1"       , 100 },
		{ 2800	, "Jelo za stol2"       , 100 },
		{ -2034	, "Burger kesa"         , 100 },
		{ 2801	, "Jelo za stol3"       , 100 },
		{ 1478	, "Posta sanduce"       , 150 },
		{ 2672	, "Smece1"              , 50  },
		{ 2675	, "Smece2"              , 50  },
		{ 2673	, "Smece3"              , 50  }
	};


/*
	 ######  ########  #######   ######  ##    ##  ######  
	##    ##    ##    ##     ## ##    ## ##   ##  ##    ## 
	##          ##    ##     ## ##       ##  ##   ##       
	 ######     ##    ##     ## ##       #####     ######  
		  ##    ##    ##     ## ##       ##  ##         ## 
	##    ##    ##    ##     ## ##    ## ##   ##  ##    ## 
	 ######     ##     #######   ######  ##    ##  ######  
*/
stock LoadHouseExterior(houseid)
{
	new
		loadExterior[128];
	format(loadExterior, 128, "SELECT * FROM `house_exteriors` WHERE `house_id` = '%d'", HouseInfo[houseid][hSQLID]);
	mysql_pquery(g_SQL, loadExterior, "OnHouseExteriorLoad", "i", houseid);
}
 
stock ReloadHouseExterior(houseid)
{
	for( new index=0; index < EXTERIOR_OBJS_VIP_GOLD; index++ ) 
	{
		if(ExteriorInfo[houseid][heSQLID][index] != -1) 
		{
			if( IsValidDynamicObject(ExteriorInfo[houseid][heObjectId][index]) ) 
			{
				DestroyDynamicObject(ExteriorInfo[houseid][heObjectId][index]);
				ExteriorInfo[houseid][heObjectId][index] = INVALID_OBJECT_ID;
			}
			ExteriorInfo[houseid][heSQLID][index] = -1;
			ExteriorInfo[houseid][heHouseId][index] = 0;
			ExteriorInfo[houseid][heModelId][index] = 0;
			ExteriorInfo[houseid][hePosX][index] = 0.0;
			ExteriorInfo[houseid][hePosY][index] = 0.0;
			ExteriorInfo[houseid][hePosZ][index] = 0.0;
			ExteriorInfo[houseid][heRotX][index] = 0.0;
			ExteriorInfo[houseid][heRotY][index] = 0.0;
			ExteriorInfo[houseid][heRotZ][index] = 0.0;
		}
	}
	LoadHouseExterior(houseid);
	return 1;
}
stock static CreatePreviewObject(playerid)
{
	if(playerid == INVALID_PLAYER_ID) return 0;
	new
		Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	GetXYInFrontOfPlayer(playerid, X, Y, 1.5);
	
	PlayerExteriorInfo[playerid][peObjectId] = CreatePlayerObject(playerid, PlayerExteriorInfo[playerid][peModelId], X, Y, Z, 0.0, 0.0, 0.0);
	Bit4_Set(r_ExteriorEditType, playerid, EXT_EDIT_TYPE_BUY);
	EditPlayerObject(playerid, PlayerExteriorInfo[playerid][peObjectId]);
	return 1;
}

stock static GetPlayerExteriorSlots(playerid)
{
	switch(PlayerInfo[playerid][pDonateRank])
	{
		case 1: return EXTERIOR_OBJS_VIP_BRONZE;
		case 2: return EXTERIOR_OBJS_VIP_SILVER;
		case 3,4: return EXTERIOR_OBJS_VIP_GOLD;
	}
	return EXTERIOR_OBJS_VIP_NONE;
}

stock static FindFreeSlot(playerid, houseid)
{
	for(new i = 0; i < GetPlayerExteriorSlots(playerid); i++)
	{
		if(ExteriorInfo[houseid][heModelId][i] == 0)
		{
			return i;
		}
	}
	return -1;
}

stock static CreateExteriorObject(playerid)
{
	if(Bit4_Get(r_ExteriorEditType, playerid) != EXT_EDIT_TYPE_BUY) return 0;
	
	// Create Object
	new 
		houseid = PlayerInfo[playerid][pHouseKey],
		index = FindFreeSlot(playerid, houseid);
	if(index == -1) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Nemate slobodnih slotova, razmislite da uplatite VIP za vise slotova!");

	ExteriorInfo[houseid][heObjectId][index]	= CreateDynamicObject(
														PlayerExteriorInfo[playerid][peModelId], 
														PlayerExteriorInfo[playerid][pePosX], 
														PlayerExteriorInfo[playerid][pePosY], 
														PlayerExteriorInfo[playerid][pePosZ],
														PlayerExteriorInfo[playerid][peRotX], 
														PlayerExteriorInfo[playerid][peRotY],
														PlayerExteriorInfo[playerid][peRotZ], 
														0, 
														0, 
														-1, 
														EXTERIOR_DRAW_DISTANCE, 
														EXTERIOR_DRAW_DISTANCE
													);
													
	ExteriorInfo[houseid][heHouseId][index]		= HouseInfo[houseid][hSQLID];
	ExteriorInfo[houseid][heModelId][index]		= PlayerExteriorInfo[playerid][peModelId];
	ExteriorInfo[houseid][hePosX][index]		= PlayerExteriorInfo[playerid][pePosX];
	ExteriorInfo[houseid][hePosY][index]		= PlayerExteriorInfo[playerid][pePosY];
	ExteriorInfo[houseid][hePosZ][index]		= PlayerExteriorInfo[playerid][pePosZ];
	ExteriorInfo[houseid][heRotX][index]		= PlayerExteriorInfo[playerid][peRotX];
	ExteriorInfo[houseid][heRotY][index]		= PlayerExteriorInfo[playerid][peRotY];
	ExteriorInfo[houseid][heRotZ][index]		= PlayerExteriorInfo[playerid][peRotZ];
	
	// Insert query
	new
		extInsert[256];
	mysql_format(g_SQL, extInsert, 256, "INSERT INTO `house_exteriors`(`house_id`, `modelid`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`) VALUES ('%d','%d','%f','%f','%f','%f','%f','%f')",
		HouseInfo[PlayerInfo[playerid][pHouseKey]][hSQLID],
		PlayerExteriorInfo[playerid][peModelId],
		PlayerExteriorInfo[playerid][pePosX],
		PlayerExteriorInfo[playerid][pePosY],
		PlayerExteriorInfo[playerid][pePosZ],
		PlayerExteriorInfo[playerid][peRotX],
		PlayerExteriorInfo[playerid][peRotY],
		PlayerExteriorInfo[playerid][peRotZ]
	);
	mysql_tquery(g_SQL, extInsert, "OnExteriorObjectsInsert", "ii", playerid, index);
	
	ResetPlayerExteriorVars(playerid);
	return 1;
}

stock static SetExteriorObjectPos(playerid, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	new 
		houseid = PlayerInfo[playerid][pHouseKey],
		index = Bit16_Get(r_ExteriorEditId, playerid);
		
	ExteriorInfo[houseid][heObjectId][index] = CreateDynamicObject(ExteriorInfo[houseid][heModelId][index], fX, fY, fZ, fRotX, fRotY, fRotZ, 0, 0, -1, EXTERIOR_DRAW_DISTANCE, EXTERIOR_DRAW_DISTANCE);
	ExteriorInfo[houseid][hePosX][index] = fX;
	ExteriorInfo[houseid][hePosY][index] = fY;
	ExteriorInfo[houseid][hePosZ][index] = fZ;
	ExteriorInfo[houseid][heRotX][index] = fRotX;
	ExteriorInfo[houseid][heRotY][index] = fRotY;
	ExteriorInfo[houseid][heRotZ][index] = fRotZ;
	
	// MySQL query
	new extEditObject[200];
	format(extEditObject, 200, "UPDATE `house_exteriors` SET `pos_x`='%f',`pos_y`='%f',`pos_z`='%f',`rot_x`='%f',`rot_y`='%f',`rot_z`='%f' WHERE `id` = '%d'",
		ExteriorInfo[houseid][hePosX][index],
		ExteriorInfo[houseid][hePosY][index],
		ExteriorInfo[houseid][hePosZ][index],
		ExteriorInfo[houseid][heRotX][index],
		ExteriorInfo[houseid][heRotY][index],
		ExteriorInfo[houseid][heRotZ][index],
		ExteriorInfo[houseid][heSQLID][index]
	);
	mysql_tquery(g_SQL, extEditObject);

	// Reset Vars	
	ResetPlayerExteriorVars(playerid);
	Streamer_UpdateEx(playerid, fX, fY, fZ);
	return 1;
}

stock static EditExteriorObject(playerid, index)
{
	if(playerid == INVALID_PLAYER_ID || index == -1) return 0;
	new
		houseid = PlayerInfo[playerid][pHouseKey];
	if(houseid == INVALID_HOUSE_ID) return 0;

	if(IsValidDynamicObject(ExteriorInfo[houseid][heObjectId][index]))
	{
		DestroyDynamicObject(ExteriorInfo[houseid][heObjectId][index]);
		ExteriorInfo[houseid][heObjectId][index] = INVALID_OBJECT_ID;
	}
	
	PlayerExteriorInfo[playerid][peModelId] 	=  ExteriorInfo[houseid][heModelId][index];
	PlayerExteriorInfo[playerid][pePosX] 		=  ExteriorInfo[houseid][hePosX][index];
	PlayerExteriorInfo[playerid][pePosY] 		=  ExteriorInfo[houseid][hePosY][index];
	PlayerExteriorInfo[playerid][pePosZ] 		=  ExteriorInfo[houseid][hePosZ][index];
	PlayerExteriorInfo[playerid][peRotX] 		=  ExteriorInfo[houseid][heRotX][index];
	PlayerExteriorInfo[playerid][peRotY] 		=  ExteriorInfo[houseid][heRotY][index];
	PlayerExteriorInfo[playerid][peRotZ] 		=  ExteriorInfo[houseid][heRotZ][index];
	
	PlayerExteriorInfo[playerid][peObjectId] = CreatePlayerObject(
													playerid, 
													PlayerExteriorInfo[playerid][peModelId],
													PlayerExteriorInfo[playerid][pePosX],
													PlayerExteriorInfo[playerid][pePosY],
													PlayerExteriorInfo[playerid][pePosZ],
													PlayerExteriorInfo[playerid][peRotX],
													PlayerExteriorInfo[playerid][peRotY],
													PlayerExteriorInfo[playerid][peRotZ]
												);
	
	Bit4_Set(r_ExteriorEditType, playerid, EXT_EDIT_TYPE_EDIT);
	Bit16_Set(r_ExteriorEditId, playerid, index);
	EditPlayerObject(playerid, PlayerExteriorInfo[playerid][peObjectId]);
	return 1;
}

stock static ResetExteriorObject(playerid, index)
{
	if(playerid == INVALID_PLAYER_ID || index == -1) return 0;
	new
		houseid = PlayerInfo[playerid][pHouseKey];
	if(houseid == INVALID_HOUSE_ID) return 0;
	
	// Creates Object
	ExteriorInfo[houseid][heObjectId][index]	= CreateDynamicObject(
														PlayerExteriorInfo[playerid][peModelId], 
														PlayerExteriorInfo[playerid][pePosX], 
														PlayerExteriorInfo[playerid][pePosY], 
														PlayerExteriorInfo[playerid][pePosZ],
														PlayerExteriorInfo[playerid][peRotX], 
														PlayerExteriorInfo[playerid][peRotY],
														PlayerExteriorInfo[playerid][peRotZ], 
														0, 
														0, 
														-1, 
														EXTERIOR_DRAW_DISTANCE, 
														EXTERIOR_DRAW_DISTANCE
													);
													
	ResetPlayerExteriorVars(playerid);
	return 1;
}

stock static DeleteExteriorObject(houseid, index)
{
	if(houseid == INVALID_HOUSE_ID) return 0;
	
	// Object Destroy
	if(IsValidDynamicObject(ExteriorInfo[houseid][heObjectId][index])) 
	{
		DestroyDynamicObject(ExteriorInfo[houseid][heObjectId][index]);
		ExteriorInfo[houseid][heObjectId][index] = INVALID_OBJECT_ID;
	} 
	
	// MySQL Query
	new extDeleteObject[128];
	format(extDeleteObject, 128, "DELETE FROM `house_exteriors` WHERE `id` = '%d'", ExteriorInfo[houseid][heSQLID][index]);
	mysql_tquery(g_SQL, extDeleteObject);
	
	// Enum Cleanup
	ExteriorInfo[houseid][heSQLID][index]		= -1;
	ExteriorInfo[houseid][heHouseId][index]		= 0;
	ExteriorInfo[houseid][heModelId][index]		= 0;
	ExteriorInfo[houseid][hePosX][index]		= 0.0;
	ExteriorInfo[houseid][hePosY][index]		= 0.0;
	ExteriorInfo[houseid][hePosZ][index]		= 0.0;
	ExteriorInfo[houseid][heRotX][index]		= 0.0;
	ExteriorInfo[houseid][heRotY][index]		= 0.0;
	ExteriorInfo[houseid][heRotZ][index]		= 0.0;
	return 1;
}

stock static ResetPlayerExteriorVars(playerid)
{
	// Player Enum
	if(IsValidPlayerObject(playerid, PlayerExteriorInfo[playerid][peObjectId]))
	{
		DestroyPlayerObject(playerid, PlayerExteriorInfo[playerid][peObjectId]);
		PlayerExteriorInfo[playerid][peObjectId] = INVALID_OBJECT_ID;
	}
	
	PlayerExteriorInfo[playerid][peModelId]		= 0;
	PlayerExteriorInfo[playerid][pePosX]		= 0.0;
	PlayerExteriorInfo[playerid][pePosY]		= 0.0;
	PlayerExteriorInfo[playerid][pePosZ]		= 0.0;
	PlayerExteriorInfo[playerid][peRotX]		= 0.0;
	PlayerExteriorInfo[playerid][peRotY]		= 0.0;
	PlayerExteriorInfo[playerid][peRotZ]		= 0.0;
	
	// rBits
	Bit4_Set(r_ExteriorEditType, playerid, 0);
	Bit16_Set(r_ExteriorObjectsId, playerid, 0);
	Bit16_Set(r_ExteriorEditId, playerid, 0);
	Bit16_Set(r_ExteriorBuyType, playerid, 0);
	return 1;
}

stock static FindExteriorObjectId(playerid, Float:radius)
{
	foreach(new h : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 40.0, HouseInfo[ h ][ hEnterX ], HouseInfo[ h ][ hEnterY ], HouseInfo[ h ][ hEnterZ ]))
		{
			for(new i = 0; i < EXTERIOR_OBJS_VIP_GOLD; i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, radius, ExteriorInfo[h][hePosX][i], ExteriorInfo[h][hePosY][i], ExteriorInfo[h][hePosZ][i]))
				{
					return i;
				}
			}			
		}
	}
	return -1;
}

stock static FindExteriorObjectHouse(playerid, Float:radius)
{
	foreach(new h : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 40.0, HouseInfo[ h ][ hEnterX ], HouseInfo[ h ][ hEnterY ], HouseInfo[ h ][ hEnterZ ]))
		{
			for(new i = 0; i < EXTERIOR_OBJS_VIP_GOLD; i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, radius, ExteriorInfo[h][hePosX][i], ExteriorInfo[h][hePosY][i], ExteriorInfo[h][hePosZ][i]))
				{
					return h;
				}
			}			
		}
	}
	return -1;
}

/*
	 ######     ###    ##       ##       ########     ###     ######  ##    ##  ######  
	##    ##   ## ##   ##       ##       ##     ##   ## ##   ##    ## ##   ##  ##    ## 
	##        ##   ##  ##       ##       ##     ##  ##   ##  ##       ##  ##   ##       
	##       ##     ## ##       ##       ########  ##     ## ##       #####     ######  
	##       ######### ##       ##       ##     ## ######### ##       ##  ##         ## 
	##    ## ##     ## ##       ##       ##     ## ##     ## ##    ## ##   ##  ##    ## 
	 ######  ##     ## ######## ######## ########  ##     ##  ######  ##    ##  ######  
*/
forward OnHouseExteriorLoad(houseid);
public OnHouseExteriorLoad(houseid)
{
	if(!cache_num_rows())
		return 0;
	new i, 
		rows = cache_num_rows();
	
	for( i = 0; i < rows; i++ ) 
	{
		cache_get_value_name_int(i		, "id"				, ExteriorInfo[houseid][heSQLID][i]);
		cache_get_value_name_int(i		, "modelid"			, ExteriorInfo[houseid][heModelId][i]);
		cache_get_value_name_float(i	, "pos_x"			, ExteriorInfo[houseid][hePosX][i]);
		cache_get_value_name_float(i	, "pos_y"			, ExteriorInfo[houseid][hePosY][i]);
		cache_get_value_name_float(i	, "pos_z"			, ExteriorInfo[houseid][hePosZ][i]);
		cache_get_value_name_float(i	, "rot_x"			, ExteriorInfo[houseid][heRotX][i]);
		cache_get_value_name_float(i	, "rot_y"			, ExteriorInfo[houseid][heRotY][i]);
		cache_get_value_name_float(i	, "rot_z"			, ExteriorInfo[houseid][heRotZ][i]);
	}
	for( i = 0; i < rows; i++ )
		ExteriorInfo[houseid][heObjectId][i] = CreateDynamicObject(ExteriorInfo[houseid][heModelId][i], ExteriorInfo[houseid][hePosX][i], ExteriorInfo[houseid][hePosY][i], ExteriorInfo[houseid][hePosZ][i], ExteriorInfo[houseid][heRotX][i], ExteriorInfo[houseid][heRotY][i], ExteriorInfo[houseid][heRotZ][i], 0, 0, -1, EXTERIOR_DRAW_DISTANCE, EXTERIOR_DRAW_DISTANCE);
	
	return 1;
}

forward OnExteriorObjectsInsert(playerid, index);
public OnExteriorObjectsInsert(playerid, index)
{
	ExteriorInfo[PlayerInfo[playerid][pHouseKey]][heSQLID][index] = cache_insert_id();
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

hook OnPlayerDisconnect(playerid, reason)
{
	ResetPlayerExteriorVars(playerid);
	return 1;
}

hook OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;
	GetObjectPos(objectid, oldX, oldY, oldZ);
	GetObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
	
	if(!IsValidPlayerObject(playerid, objectid)) return;
	switch(Bit4_Get(r_ExteriorEditType, playerid))
	{
		case EXT_EDIT_TYPE_BUY:
		{
			switch(response) 
			{
				case EDIT_RESPONSE_FINAL:
				{
					new houseid = PlayerInfo[playerid][pHouseKey];
					if(!IsPlayerInRangeOfPoint(playerid, EXTERIOR_HOUSE_DISTANCE, HouseInfo[houseid][hEnterX], HouseInfo[houseid][hEnterY], HouseInfo[houseid][hEnterZ])) 
					{
						SetExteriorObjectPos(playerid, oldX, oldY, oldZ, oldRotX, oldRotY, oldRotZ);
						SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste blizu svoje kuce! Susjedima je ZABRANJENO mapati eksterijer!");
						Streamer_UpdateEx(playerid, oldX, oldY, oldZ);
						return;
					}
					PlayerToBudgetMoney(playerid, PlayerExteriorInfo[playerid][pePrice]); // Novac ide u proracun
					// Input data in enum
					PlayerExteriorInfo[playerid][pePosX] = fX;
					PlayerExteriorInfo[playerid][pePosY] = fY;
					PlayerExteriorInfo[playerid][pePosZ] = fZ;
					PlayerExteriorInfo[playerid][peRotX] = fRotX;
					PlayerExteriorInfo[playerid][peRotY] = fRotY;
					PlayerExteriorInfo[playerid][peRotZ] = fRotZ;
					
					// Delete previous object
					if(IsValidPlayerObject(playerid, objectid))
					{
						DestroyPlayerObject(playerid, PlayerExteriorInfo[playerid][peObjectId]);
						PlayerExteriorInfo[playerid][peObjectId] = INVALID_OBJECT_ID;
					}
					// Buy object
					CreateExteriorObject(playerid);
				}
				case EDIT_RESPONSE_CANCEL: 
				{
					// Delete previous object
					if(IsValidPlayerObject(playerid, objectid))
					{
						DestroyPlayerObject(playerid, PlayerExteriorInfo[playerid][peObjectId]);
						PlayerExteriorInfo[playerid][peObjectId] = INVALID_OBJECT_ID;
					}
					ResetPlayerExteriorVars(playerid);
					ShowPlayerDialog(playerid, DIALOG_EXTERIOR_BUY_TYPE, DIALOG_STYLE_LIST, "Exteriors - Kupovina objekta (Tip)", "Biljke\nNamjestaj\nOstalo", "Choose", "Abort");
				}
			}
			
		}
		case EXT_EDIT_TYPE_EDIT:
		{
			switch(response) 
			{
				case EDIT_RESPONSE_FINAL:
				{
					new houseid = PlayerInfo[playerid][pHouseKey];
					if(!IsPlayerInRangeOfPoint(playerid, EXTERIOR_HOUSE_DISTANCE, HouseInfo[houseid][hEnterX], HouseInfo[houseid][hEnterY], HouseInfo[houseid][hEnterZ])) 
					{
						SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste blizu svoje kuce! Susjedima je ZABRANJENO mapati eksterijer!");
						return;
					}
					// Delete previous object
					if(IsValidPlayerObject(playerid, objectid))
					{
						DestroyPlayerObject(playerid, PlayerExteriorInfo[playerid][peObjectId]);
						PlayerExteriorInfo[playerid][peObjectId] = INVALID_OBJECT_ID;
					}
					SetExteriorObjectPos(playerid, fX, fY, fZ, fRotX, fRotY, fRotZ);
				}
				case EDIT_RESPONSE_CANCEL:
				{
					ResetExteriorObject(playerid, Bit16_Get(r_ExteriorEditId, playerid));
				}
			}
		}
	}
}

hook OnModelSelResponse( playerid, extraid, index, modelid, response )
{
	switch(extraid)
	{
		case DIALOG_EXTERIOR_BUY:
		{
			if(!response) return ShowPlayerDialog(playerid, DIALOG_EXTERIOR_BUY_TYPE, DIALOG_STYLE_LIST, "Exteriors - Kupovina objekta (Tip)", "Biljke\nNamjestaj\nOstalo", "Choose", "Abort");
			switch(Bit16_Get(r_ExteriorBuyType, playerid))
			{
				case 0: {	// Biljke
					va_ShowPlayerDialog(playerid, DIALOG_EXTERIOR_SURE, DIALOG_STYLE_MSGBOX, "Exteriors - Sigurni?", ""COL_WHITE"Zelite li kupiti ovaj objekt?\n"COL_CYAN"Ime: "COL_WHITE"%s\n"COL_CYAN"Cijena: "COL_WHITE"%d"COL_GREEN"$", "Buy", "Abort",
						ExteriorPlants[index][epName], 
						ExteriorPlants[index][epPrice]
					);
					Bit16_Set(r_ExteriorObjectsId, playerid, index);
				}
				case 1: {	// Furniture
					va_ShowPlayerDialog(playerid, DIALOG_EXTERIOR_SURE, DIALOG_STYLE_MSGBOX, "Exteriors - Sigurni?", ""COL_WHITE"Zelite li kupiti ovaj objekt?\n"COL_CYAN"Ime: "COL_WHITE"%s\n"COL_CYAN"Cijena: "COL_WHITE"%d"COL_GREEN"$", "Buy", "Abort",
						ExteriorFurniture[index][efName], 
						ExteriorFurniture[index][efPrice]
					);
					Bit16_Set(r_ExteriorObjectsId, playerid, index);
				}
				case 2: {	// Misc
					va_ShowPlayerDialog(playerid, DIALOG_EXTERIOR_SURE, DIALOG_STYLE_MSGBOX, "Exteriors - Sigurni?", ""COL_WHITE"Zelite li kupiti ovaj objekt?\n"COL_CYAN"Ime: "COL_WHITE"%s\n"COL_CYAN"Cijena: "COL_WHITE"%d"COL_GREEN"$", "Buy", "Abort",
						ExteriorMisc[index][emName], 
						ExteriorMisc[index][emPrice]
					);
					Bit16_Set(r_ExteriorObjectsId, playerid, index);
				}
			}
		}
		case DIALOG_EXTERIOR_EDIT:
		{
			if(!response) return ShowPlayerDialog(playerid, DIALOG_EXTERIOR_MENU, DIALOG_STYLE_LIST, "Exteriors", "Kupi objekt\nUredi object\nObrisati objekt\nObrisati SVE objekte", "Choose", "Abort");
			EditExteriorObject(playerid, index);
		}
		case DIALOG_EXTERIOR_DELETE:
		{
			if(!response) return ShowPlayerDialog(playerid, DIALOG_EXTERIOR_MENU, DIALOG_STYLE_LIST, "Exteriors", "Kupi objekt\nUredi object\nObrisati objekt\nObrisati SVE objekte", "Choose", "Abort");
			DeleteExteriorObject(PlayerInfo[playerid][pHouseKey], index);
			SendMessage(playerid, MESSAGE_TYPE_SUCCESS, "Uspjesno ste obrisali objekt!");
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch( dialogid ) 
	{
		case DIALOG_EXTERIOR_MENU:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0:  	// Kupovina
				{
					if( PlayerInfo[playerid][pHouseKey] == INVALID_HOUSE_ID)
						return SendErrorMessage(playerid, "Niste vlasnik kuce!");
					if(FindFreeSlot(playerid, PlayerInfo[playerid][pHouseKey]) == -1) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Nemate slobodnih slotova, razmislite da uplatite VIP za vise slotova!");
					ShowPlayerDialog(playerid, DIALOG_EXTERIOR_BUY_TYPE, DIALOG_STYLE_LIST, "Exteriors - Kupovina objekta (Tip)", "Biljke\nNamjestaj\nOstalo", "Choose", "Abort");
				}
				case 1:		// Uredivanje
				{
					if(PlayerInfo[playerid][pHouseKey] == INVALID_HOUSE_ID)
						return SendErrorMessage(playerid, "Niste vlasnik kuce!");
					new	
						tmp_objects[EXTERIOR_OBJS_VIP_GOLD], houseid = PlayerInfo[playerid][pHouseKey], count = 0;
					for(new i = 0; i < GetPlayerExteriorSlots(playerid); i++)
					{
						if(ExteriorInfo[houseid][heModelId][i] != 0)
						{
							tmp_objects[i] = ExteriorInfo[houseid][heModelId][i];
							count++;
						}
					}	
					ShowModelESelectionMenu(playerid, "Exteriors - Uredjivanje", DIALOG_EXTERIOR_EDIT, tmp_objects, count, 0.0, 0.0, 0.0, 1.0, -1, true, tmp_objects);
				}
				case 2:		// Brisanje objekta
				{
					if(PlayerInfo[playerid][pHouseKey] == INVALID_HOUSE_ID)
						return SendErrorMessage(playerid, "Niste vlasnik kuce!");
					new	
						tmp_objects[EXTERIOR_OBJS_VIP_GOLD], houseid = PlayerInfo[playerid][pHouseKey], count = 0;
					for(new i = 0; i < GetPlayerExteriorSlots(playerid); i++)
					{
						if(ExteriorInfo[houseid][heModelId][i] != 0)
						{
							tmp_objects[i] = ExteriorInfo[houseid][heModelId][i];
							count++;
						}
					}	
					ShowModelESelectionMenu(playerid, "Exteriors - Brisanje", DIALOG_EXTERIOR_DELETE, tmp_objects, count, 0.0, 0.0, 0.0, 1.0, -1, true, tmp_objects);
				}
				case 3:		// Brisanje svih objekata
				{
					if(PlayerInfo[playerid][pHouseKey] == INVALID_HOUSE_ID)
						return SendErrorMessage(playerid, "Niste vlasnik kuce!");
					new houseid = PlayerInfo[playerid][pHouseKey];
					for (new i = 0; i < EXTERIOR_OBJS_VIP_GOLD; i++) // sizeof(ExteriorInfo)
					{
						if(ExteriorInfo[houseid][heModelId][i] != 0)
							DeleteExteriorObject(PlayerInfo[playerid][pHouseKey], i);
					}
					SendMessage(playerid, MESSAGE_TYPE_SUCCESS, "Uspjesno ste obrisali sve objekte u svome eksterijeru!");
				}
			}
			return 1;
		}
		case DIALOG_EXTERIOR_BUY_TYPE:
		{
			if(!response) return ShowPlayerDialog(playerid, DIALOG_EXTERIOR_MENU, DIALOG_STYLE_LIST, "Exteriors", "Kupi objekt\nUredi object\nObrisati objekt\nObrisati SVE objekte", "Choose", "Abort");
			
			switch(listitem)
			{
				case 0:	// Biljke
				{
					new	
						tmp_objects[sizeof(ExteriorPlants)];
					for(new i = 0; i < sizeof(ExteriorPlants); i++)
					{
						if(ExteriorPlants[i][epModelid] != 0)
							tmp_objects[i] = ExteriorPlants[i][epModelid];
					}
					ShowModelESelectionMenu(playerid, "Exteriors - Kupovina", DIALOG_EXTERIOR_BUY, tmp_objects, sizeof(tmp_objects), 0.0, 0.0, 0.0, 1.0, -1, true, tmp_objects);
				}
				case 1:	// Furniture
				{
					new	
						tmp_objects[sizeof(ExteriorFurniture)];
					for(new i = 0; i < sizeof(ExteriorFurniture); i++)
					{
						if(ExteriorFurniture[i][efModelid] != 0)
							tmp_objects[i] = ExteriorFurniture[i][efModelid];
					}
					ShowModelESelectionMenu(playerid, "Exteriors - Kupovina", DIALOG_EXTERIOR_BUY, tmp_objects, sizeof(tmp_objects), 0.0, 0.0, 0.0, 1.0, -1, true, tmp_objects);
				}
				case 2:	// Misc
				{
					new	
						tmp_objects[sizeof(ExteriorMisc)];
					for(new i = 0; i < sizeof(ExteriorMisc); i++)
					{
						if(ExteriorMisc[i][emModelid] != 0)
							tmp_objects[i] = ExteriorMisc[i][emModelid];
					}
					ShowModelESelectionMenu(playerid, "Exteriors - Kupovina", DIALOG_EXTERIOR_BUY, tmp_objects, sizeof(tmp_objects), 0.0, 0.0, 0.0, 1.0, -1, true, tmp_objects);
				}
			}
			Bit16_Set(r_ExteriorBuyType, playerid, listitem);
			return 1;
		}
		case DIALOG_EXTERIOR_SURE:
		{
			if(!response) return ShowPlayerDialog(playerid, DIALOG_EXTERIOR_BUY_TYPE, DIALOG_STYLE_LIST, "Exteriors - Kupovina objekta (Tip)", "Biljke\nNamjestaj\nOstalo", "Choose", "Abort");
			
			new 
				index = Bit16_Get(r_ExteriorObjectsId, playerid),
				type = Bit16_Get(r_ExteriorBuyType, playerid);
			switch(type)
			{
				case 0: { // Biljke
					if(AC_GetPlayerMoney(playerid) < ExteriorPlants[index][epPrice])
						return SendFormatMessage(playerid, MESSAGE_TYPE_ERROR, "Nemate dovoljno novaca za kupovinu objekta (%d$)!", ExteriorPlants[index][epPrice]);
					
					// Enum set
					PlayerExteriorInfo[playerid][peModelId] = ExteriorPlants[index][epModelid];
					PlayerExteriorInfo[playerid][pePrice] 	= ExteriorPlants[index][epPrice];
					
					// Reset Vars
					Bit16_Set(r_ExteriorObjectsId, playerid, 0);
					
					// Preview
					CreatePreviewObject(playerid);
				}
				case 1: { // Furniture
					if(AC_GetPlayerMoney(playerid) < ExteriorFurniture[index][efPrice])
						return SendFormatMessage(playerid, MESSAGE_TYPE_ERROR, "Nemate dovoljno novaca za kupovinu objekta (%d$)!", ExteriorFurniture[index][efPrice]);
					
					// Enum set
					PlayerExteriorInfo[playerid][peModelId] = ExteriorFurniture[index][efModelid];
					PlayerExteriorInfo[playerid][pePrice] 	= ExteriorFurniture[index][efPrice];
					
					// Reset Vars
					Bit16_Set(r_ExteriorObjectsId, playerid, 0);
					
					// Preview
					CreatePreviewObject(playerid);
				}
				case 2: { // Misc
					if(AC_GetPlayerMoney(playerid) < ExteriorMisc[index][emPrice])
						return SendFormatMessage(playerid, MESSAGE_TYPE_ERROR, "Nemate dovoljno novaca za kupovinu objekta (%d$)!", ExteriorMisc[index][emPrice]);
					
					// Enum set
					PlayerExteriorInfo[playerid][peModelId] = ExteriorMisc[index][emModelid];
					PlayerExteriorInfo[playerid][pePrice] 	= ExteriorMisc[index][emPrice];
					
					// Reset Vars
					Bit16_Set(r_ExteriorObjectsId, playerid, 0);
					
					// Preview
					CreatePreviewObject(playerid);
				}
			}
			return 1;
		}
	}
	return 0;
}

/*
	 ######  ##     ## ########   ######  
	##    ## ###   ### ##     ## ##    ## 
	##       #### #### ##     ## ##       
	##       ## ### ## ##     ##  ######  
	##       ##     ## ##     ##       ## 
	##    ## ##     ## ##     ## ##    ## 
	 ######  ##     ## ########   ######  
*/
CMD:exterior(playerid, params[])
{
	new houseid = PlayerInfo[playerid][pHouseKey];
	if(houseid == INVALID_HOUSE_ID) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ne posjedujete kucu!");
	if(!IsPlayerInRangeOfPoint(playerid, EXTERIOR_HOUSE_DISTANCE, HouseInfo[houseid][hEnterX], HouseInfo[houseid][hEnterY], HouseInfo[houseid][hEnterZ])) 
			return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste blizu svoje kuce! Susjedima je ZABRANJENO mapati eksterijer!");
	ShowPlayerDialog(playerid, DIALOG_EXTERIOR_MENU, DIALOG_STYLE_LIST, "Exteriors", "Kupi objekt\nUredi object\nObrisati objekt\nObrisati SVE objekte", "Choose", "Abort");
	return 1;
}
CMD:deleteext(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 2) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste ovlasteni za koristenje ove komande!");
	new index = FindExteriorObjectId(playerid, 5.0);
	new houseid = FindExteriorObjectHouse(playerid, 5.0);
	if(index == -1) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste blizu eksterijer objekta!");
	DeleteExteriorObject(houseid, index);
	SendMessage(playerid, MESSAGE_TYPE_SUCCESS, "Uspjesno ste obrisali objekt pored sebe!");
	return 1;
}
CMD:checkextowner(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 2) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste ovlasteni za koristenje ove komande!");
	new index = FindExteriorObjectHouse(playerid, 5.0);
	if(index == -1) return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Niste blizu eksterijer objekta!");
	SendFormatMessage(playerid, MESSAGE_TYPE_INFO, "Vlasnik ovog objekta je %s (houseid %d).", GetPlayerNameFromSQL(HouseInfo[index][hOwnerID]), index);
	return 1;
}