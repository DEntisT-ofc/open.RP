 // Weapon Edit FilterScript by Logan
#include <YSI_Coding\y_hooks>

#define MAX_WEAPON_OBJECT_SLOTS		(2) // Po igracu
#define PRIMARY_WEAPON_SLOT 		(8)
#define SECONDARY_WEAPON_SLOT		(7)

static 
	EditingWeapon[MAX_PLAYERS] = 0,
	WeaponTick[MAX_PLAYERS];

enum weaponSettings
{
	wsSQLID,
    Float:Position[6],
    Bone
}
static 
	WeaponSettings[MAX_PLAYERS][MAX_WEAPON_OBJECT_SLOTS][weaponSettings];
static stock GetWeaponObjectSlot(weaponid)
{
    new objectslot;

    switch (weaponid)
    {
        case 22..24: objectslot = SECONDARY_WEAPON_SLOT;
        case 25..27: objectslot = PRIMARY_WEAPON_SLOT;
        case 28, 29, 32: objectslot = PRIMARY_WEAPON_SLOT;
        case 30, 31: objectslot = PRIMARY_WEAPON_SLOT;
        case 33, 34: objectslot = PRIMARY_WEAPON_SLOT;
        case 35..38: objectslot = PRIMARY_WEAPON_SLOT;
    }
    return objectslot;
}

static stock GetWeaponObjectEnum(weaponid)
{
	new slot = SortWeaponSlot(weaponid),
		enumreturn = 0;
	switch(slot)
	{
		case 1: enumreturn = 0;
		case 2: enumreturn = 1;
	}
	return enumreturn;
}

stock GetWeaponModel(weaponid)
{
    new model;

    switch(weaponid)
    {
		case 1: model = 331;
		case 2..8: model = 332 + weaponid;
		case 9: model = 341;
		case 10..15: model = 311 + weaponid;
        case 22..29: model = 324 + weaponid;
        case 30: model = 355;
        case 31: model = 356;
        case 32: model = 372;
        case 33..38: model = 324 + weaponid;
    }
    return model;
}

static stock PlayerHasWeapon(playerid, weaponid)
{
    new weapon, ammo;

    for (new i; i < 13; i++)
    {
        GetPlayerWeaponData(playerid, i, weapon, ammo);
        if(weapon == weaponid && ammo != 0) return 1;
    }
    return 0;
}

stock UpdatePlayerWeaponSettings(playerid)
{
	if(NetStats_GetConnectedTime(playerid) - WeaponTick[playerid] >= 50)
    {
        new weaponid, ammo, objectslot, count, index;

        for (new i = 2; i <= 7; i++) //Loop only through the slots that may contain the wearable weapons
        {
            GetPlayerWeaponData(playerid, i, weaponid, ammo);

            if(weaponid && ammo && IsWeaponWearable(weaponid) && EditingWeapon[playerid] != weaponid)
            {
                objectslot = GetWeaponObjectSlot(weaponid);
				index = GetWeaponObjectEnum(weaponid);

                if(AC_GetPlayerWeapon(playerid) != weaponid && !IsPlayerAttachedObjectSlotUsed(playerid, objectslot))
                    SetPlayerAttachedObject(playerid, objectslot, GetWeaponModel(weaponid), WeaponSettings[playerid][index][Bone], WeaponSettings[playerid][index][Position][0], WeaponSettings[playerid][index][Position][1], WeaponSettings[playerid][index][Position][2], WeaponSettings[playerid][index][Position][3], WeaponSettings[playerid][index][Position][4], WeaponSettings[playerid][index][Position][5], 1.0, 1.0, 1.0);

                else if(IsPlayerAttachedObjectSlotUsed(playerid, objectslot) && AC_GetPlayerWeapon(playerid) == weaponid) RemovePlayerAttachedObject(playerid, objectslot);
            }
        }
        for (new l=7; l <= 8; l++)
        {
			if(IsPlayerAttachedObjectSlotUsed(playerid, l))
			{
				count = 0;

				for (new j = 22; j <= 38; j++) if(PlayerHasWeapon(playerid, j) && GetWeaponObjectSlot(j) == l && !IsPlayerInAnyVehicle(playerid))
					count++;

				if(!count) RemovePlayerAttachedObject(playerid, l);
			}
        }
        WeaponTick[playerid] = NetStats_GetConnectedTime(playerid);
    }
	return 1;
}

stock IsWeaponWearable(weaponid)
    return (weaponid >= 25 && weaponid <= 38);

stock NiteStickPD(weaponid)
	return (weaponid == 3);

stock IsWeaponHideable(weaponid)
    return (weaponid == 28 || weaponid == 32);


static RefreshPlayerWeaponSettings(playerid, weaponid)
{
	new index = GetWeaponObjectEnum(weaponid);

	mysql_fquery(SQL_Handle(), 
		"UPDATE weaponsettings SET WeaponID = '%d', PosX = '%f', PosY = '%f', PosZ = '%f',\n\
			RotX = '%f', RotY = '%f', RotZ = '%f' WHERE id = '%d'",
		weaponid,
		WeaponSettings[playerid][index][Position][0],
		WeaponSettings[playerid][index][Position][1],
		WeaponSettings[playerid][index][Position][2],
		WeaponSettings[playerid][index][Position][3],
		WeaponSettings[playerid][index][Position][4],
		WeaponSettings[playerid][index][Position][5],
		WeaponSettings[playerid][index][wsSQLID]
	);
	return 1;
}

static SavePlayerWeaponSettings(playerid, weaponid)
{
	new 
		index = GetWeaponObjectEnum(weaponid);
	if(WeaponSettings[playerid][index][wsSQLID] == -1)
	{
		inline OnWeaponSettingsInsert()
		{
			WeaponSettings[playerid][index][wsSQLID] = cache_insert_id();
			RefreshPlayerWeaponSettings(playerid, weaponid);
			return 1;
		}
        MySQL_TQueryInline(SQL_Handle(),
			using inline OnWeaponSettingsInsert,
			va_fquery(SQL_Handle(), "INSERT INTO weaponsettings (playerid, WeaponID, Bone) VALUES ('%d', %d, %d)", 
				PlayerInfo[playerid][pSQLID], 
				weaponid, 
				WeaponSettings[playerid][index][Bone]
			), 
			"ii", 
			playerid, 
			weaponid
		);
	}
	else RefreshPlayerWeaponSettings(playerid, weaponid);
	return 1;
}

static LoadPlayerWeaponSettings(playerid)
{
	inline OnWeaponSettingsLoaded()
	{
		new 
			rows, 
			weaponid, 
			index;
		
		cache_get_row_count(rows);
		if(rows  == 0) 
			return 0;

		for (new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "WeaponID", weaponid);
			index = GetWeaponObjectEnum(weaponid);

			cache_get_value_name_int(i,   "id"	, WeaponSettings[playerid][index][wsSQLID]);
			cache_get_value_name_float(i, "PosX", WeaponSettings[playerid][index][Position][0]);
			cache_get_value_name_float(i, "PosY", WeaponSettings[playerid][index][Position][1]);
			cache_get_value_name_float(i, "PosZ", WeaponSettings[playerid][index][Position][2]);

			cache_get_value_name_float(i, "RotX", WeaponSettings[playerid][index][Position][3]);
			cache_get_value_name_float(i, "RotY", WeaponSettings[playerid][index][Position][4]);
			cache_get_value_name_float(i, "RotZ", WeaponSettings[playerid][index][Position][5]);

			cache_get_value_name_int(i, "Bone", WeaponSettings[playerid][index][Bone]);
		}
		return 1;
	}
    MySQL_TQueryInline(SQL_Handle(),
		using inline OnWeaponSettingsLoaded,
		va_fquery(SQL_Handle(), "SELECT * FROM weaponsettings WHERE playerid = '%d'", PlayerInfo[playerid][pSQLID]),
		"i", 
		playerid
	);
	return 1;
}

hook function LoadPlayerStats(playerid)
{
	LoadPlayerWeaponSettings(playerid);
	return continue(playerid);
}

hook OnPlayerEditAttachedObj(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new 
		weaponid = EditingWeapon[playerid];
    if(weaponid)
    {
        if(response)
        {
            new enum_index = GetWeaponObjectEnum(weaponid);

            WeaponSettings[playerid][enum_index][Position][0] = fOffsetX;
            WeaponSettings[playerid][enum_index][Position][1] = fOffsetY;
            WeaponSettings[playerid][enum_index][Position][2] = fOffsetZ;
            WeaponSettings[playerid][enum_index][Position][3] = fRotX;
            WeaponSettings[playerid][enum_index][Position][4] = fRotY;
            WeaponSettings[playerid][enum_index][Position][5] = fRotZ;

            SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);

			va_SendMessage(playerid, 
				MESSAGE_TYPE_SUCCESS, 
				"Uspjesno ste promjenili poziciju od %s.", 
				GetWeaponNameEx(weaponid)
			);

            SavePlayerWeaponSettings(playerid, weaponid);
			EditingWeapon[playerid] = 0;
        }
		else
		{
			SendMessage(playerid, MESSAGE_TYPE_ERROR, "Neuspjesno ste promjenili poziciju svog oruzja.");
			EditingWeapon[playerid] = 0;
		}
    }
    return 1;
}

hook OnPlayerUpdate(playerid)
{
	UpdatePlayerWeaponSettings(playerid);
    return 1;
}

hook OnPlayerConnect(playerid)
{
    for (new i; i < MAX_WEAPON_OBJECT_SLOTS; i++)
    {
		WeaponSettings[playerid][i][wsSQLID]	 = -1;
        WeaponSettings[playerid][i][Position][0] = -0.116;
        WeaponSettings[playerid][i][Position][1] = 0.189;
        WeaponSettings[playerid][i][Position][2] = 0.088;
        WeaponSettings[playerid][i][Position][3] = 0.0;
        WeaponSettings[playerid][i][Position][4] = 44.5;
        WeaponSettings[playerid][i][Position][5] = 0.0;
        WeaponSettings[playerid][i][Bone] = 1;
    }
    WeaponTick[playerid] = 0;
	EditingWeapon[playerid] = 0;
    return 1;
}

hook function ResetPlayerVariables(playerid)
{
	WeaponTick[playerid] = 0;
	EditingWeapon[playerid] = 0;
	return continue(playerid);
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_WEAPON_BONE)
    {
        if(response)
        {
            new 
				weaponid = EditingWeapon[playerid], 
				enum_index = GetWeaponObjectEnum(weaponid);

            WeaponSettings[playerid][enum_index][Bone] = listitem + 1;
			va_SendMessage(playerid, 
				MESSAGE_TYPE_SUCCESS, 
				"Uspjesno ste promjenili bone oruzja %s.", 
				GetWeaponNameEx(weaponid)
			);
            SavePlayerWeaponSettings(playerid, weaponid);
        }
        EditingWeapon[playerid] = 0;
        return 1;
    }
    return 1;
}

CMD:weapon(playerid, params[])
{
	new weaponid = AC_GetPlayerWeapon(playerid),
		option[12];

	if(isnull(params))
	if(sscanf(params, "s[12] ", option))
		return SendClientMessage(playerid, COLOR_RED, "[?]: /weapon [adjust/bone/hide]");

	if(!strcmp(params, "adjust", true))
	{
		if(!weaponid)
			return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ne drzite nikakvo oruzje u rukama.");
		if(!IsWeaponWearable(weaponid) || NiteStickPD(weaponid))
			return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Samo vatrena oruzja se mogu stavljati na tijelo.");
		if(EditingWeapon[playerid])
			return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Vec namjestate poziciju oruzja.");

		EditingWeapon[playerid] = weaponid;
		new index = GetWeaponObjectEnum(weaponid);

		SetPlayerArmedWeapon(playerid, 0);

		SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][index][Bone], WeaponSettings[playerid][index][Position][0], WeaponSettings[playerid][index][Position][1], WeaponSettings[playerid][index][Position][2], WeaponSettings[playerid][index][Position][3], WeaponSettings[playerid][index][Position][4], WeaponSettings[playerid][index][Position][5], 1.0, 1.0, 1.0);
		EditAttachedObject(playerid, GetWeaponObjectSlot(weaponid));
	}
	else if(!strcmp(params, "bone", true))
	{
		if(!weaponid)
			return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ne drzite nikakvo oruzje u rukama.");
		if(!IsWeaponWearable(weaponid))
			return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Samo vatrena oruzja se mogu stavljati na tijelo.");
		if(EditingWeapon[playerid])
			return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Vec namjestate poziciju oruzja.");

		ShowPlayerDialog(playerid, DIALOG_WEAPON_BONE, DIALOG_STYLE_LIST, "Bone", "Spine\nHead\nLeft upper arm\nRight upper arm\nLeft hand\nRight hand\nLeft thigh\nRight thigh\nLeft foot\nRight foot\nRight calf\nLeft calf\nLeft forearm\nRight forearm\nLeft shoulder\nRight shoulder\nNeck\nJaw", "Choose", "Cancel");
		EditingWeapon[playerid] = weaponid;
	}
	else if(!strcmp(params, "hide", true))
	{
		if(EditingWeapon[playerid])
			return SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ne mozes sakriti oruzje kada ga editas.");

		new string[150];

		if(HiddenWeapon[playerid][pwWeaponId] != 0)
		{
			if(!Player_SafeSpawned(playerid))
				return va_SendMessage(playerid, MESSAGE_TYPE_ERROR,"Pricekajte dok zavrsi spawn te da dobijete unfreeze!");

			if(!CheckPlayerWeapons(playerid, HiddenWeapon[playerid][pwWeaponId], true))
				return 1;

			va_SendMessage(playerid, MESSAGE_TYPE_INFO, 
				"Izvadili ste svoj sakriveni %s.", 
				GetWeaponNameEx(HiddenWeapon[playerid][pwWeaponId])
			);
			#if defined MODULE_LOGS
			Log_Write("logfiles/weapon_hide.txt", "(%s) %s[SQL:%d] takes out his hidden %s(%d) with /weapon hide.",
				ReturnDate(),
				GetName(playerid, false),
				PlayerInfo[playerid][pSQLID],
				GetWeaponNameEx(HiddenWeapon[playerid][pwWeaponId]),
				HiddenWeapon[playerid][pwAmmo]
			);
			#endif

			format( string, sizeof(string), 
				"* %s vadi sakriveni %s ispod odjece.", 
				GetName(playerid, true), 
				GetWeaponNameEx(HiddenWeapon[playerid][pwWeaponId]) 
			);
			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 20, 8000);

			new	puzavac = IsCrounching(playerid);
			SetAnimationForWeapon(playerid, HiddenWeapon[playerid][pwWeaponId], puzavac);
			AC_GivePlayerWeapon(playerid, HiddenWeapon[playerid][pwWeaponId], HiddenWeapon[playerid][pwAmmo], true, true);

			HiddenWeapon[playerid][pwSQLID] = -1;
			HiddenWeapon[playerid][pwWeaponId] = 0;
			HiddenWeapon[playerid][pwAmmo] = 0;
		}
		else
		{
			if(!IsWeaponHideable(weaponid))
			{
				SendMessage(playerid, MESSAGE_TYPE_ERROR, "Ne mozete sakriti primary oruzje!");
				SendMessage(playerid, MESSAGE_TYPE_INFO, "Oruzja koja mozete sakriti: microSMG i Tec9.");
				return 1;
			}
			if(IsPlayerAttachedObjectSlotUsed(playerid, GetWeaponObjectSlot(weaponid)))
				RemovePlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid));

			va_SendMessage(playerid, MESSAGE_TYPE_INFO, "Sakrili ste svoj %s.", GetWeaponNameEx(weaponid));
			format( string, sizeof(string), "* %s sakriva %s ispod odjece.", GetName(playerid, true), GetWeaponNameEx(weaponid));
			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 20, 8000);

			new slot = GetWeaponSlot(weaponid);
			HiddenWeapon[playerid][pwSQLID] = PlayerWeapons[playerid][pwSQLID][slot];
			HiddenWeapon[playerid][pwWeaponId] = PlayerWeapons[playerid][pwWeaponId][slot];
			HiddenWeapon[playerid][pwAmmo] = PlayerWeapons[playerid][pwAmmo][slot];
			PlayerWeapons[playerid][pwHidden][slot] = 1;
			#if defined MODULE_LOGS
			Log_Write("logfiles/weapon_hide.txt", "(%s) %s[SQL:%d] hides his %s(%d) with /weapon hide.",
				ReturnDate(),
				GetName(playerid, false),
				PlayerInfo[playerid][pSQLID],
				weaponname,
				HiddenWeapon[playerid][pwAmmo]
			);
			#endif
			AC_SavePlayerWeapon(playerid, slot);
			AC_ResetPlayerWeapon(playerid, HiddenWeapon[playerid][pwWeaponId], false);
		}
	}
	else SendClientMessage(playerid, COLOR_RED, "[?]: /weapon [adjust/bone/hide]");
	return 1;
}
