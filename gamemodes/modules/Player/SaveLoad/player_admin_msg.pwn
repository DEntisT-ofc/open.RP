#include <YSI_Coding\y_hooks>

LoadPlayerAdminMessage(playerid)
{
    mysql_pquery(g_SQL, 
        va_fquery(g_SQL, "SELECT * FROM player_admin_msg WHERE sqlid = '%d'", PlayerInfo[playerid][pSQLID]),
        "LoadingPlayerAdminMessage", 
        "i", 
        playerid
    );
    return 1;
}

Public: LoadingPlayerAdminMessage(playerid)
{
    if(!cache_num_rows())
    {
        mysql_fquery_ex(g_SQL, 
            "INSERT INTO player_admin_msg(sqlid, AdminMessage, AdminMessageBy, AdmMessageConfirm) \n\
                VALUES('%d', '', '', '0')",
            PlayerInfo[playerid][pSQLID]
        );
        return 1;
    }
    cache_get_value_name(0, "AdminMessage", PlayerAdminMessage[playerid][pAdminMsg], 1536);
    cache_get_value_name(0, "AdminMessageBy", PlayerAdminMessage[playerid][pAdminMsgBy], 60);
    cache_get_value_name_int(0, "AdmMessageConfirm", PlayerAdminMessage[playerid][pAdmMsgConfirm]);
    return 1;
}

hook LoadPlayerStats(playerid)
{
    LoadPlayerAdminMessage(playerid);
    return 1;
}

SavePlayerAdminMessage(playerid)
{
    mysql_fquery_ex(g_SQL,
        "UPDATE player_admin_msg SET AdminMessage = '%e', AdminMessageBy = '%e', AdmMessageConfirm = '%d' \n\
            WHERE sqlid = '%d'",
        PlayerAdminMessage[playerid][pAdminMsg],
        PlayerAdminMessage[playerid][pAdminMsgBy],
        PlayerAdminMessage[playerid][pAdmMsgConfirm],
        PlayerInfo[playerid][pSQLID]
    );
    return 1;
}

hook SavePlayerData(playerid)
{
    SavePlayerAdminMessage(playerid);
    return 1;
}

hook ResetPlayerVariables(playerid)
{
    PlayerAdminMessage[playerid][pAdminMsg][0] = EOS;
    PlayerAdminMessage[playerid][pAdminMsgBy][0] = EOS;
    PlayerAdminMessage[playerid][pAdmMsgConfirm] = false;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(SafeSpawned[playerid])
    {
        mysql_fquery(g_SQL, "UPDATE player_admin_msg SET AdminMessage = '', AdminMessageBy = '', AdmMessageConfirm = '0' \n\
            WHERE sqlid = '%d'", 
            PlayerInfo[playerid][pSQLID]
        );
    }
    return 1;
}

Public: AddAdminMessage(playerid, user_name[], reason[])
{
	new rows;
	
    cache_get_row_count(rows);
	if(!rows)
	 	return SendClientMessage(playerid, COLOR_RED, "[GRESKA - MySQL]: Ne postoji korisnik s tim nickom!");
	
	new
		on,
		sqlid;
	
	cache_get_value_name_int(0, "sqlid" , sqlid);
	cache_get_value_name_int(0, "online" , on);
	
	if(on)
	{
		sscanf(user_name, "u", on);
		
		if(on != INVALID_PLAYER_ID && IsPlayerConnected(on) && SafeSpawned[on])
		{
			va_SendClientMessage(on, COLOR_NICEYELLOW, "(( PM od %s[%d]: %s ))", 
				GetName(playerid, false), 
				playerid, 
				reason
			);
			va_SendClientMessage(playerid, COLOR_RED, "(( PM za %s[%d]: %s ))", 
				user_name, 
				on, 
				reason
			);
			SendClientMessage(playerid, COLOR_RED, "[!] Navedeni korisnik je bio in-game te mu je poslana poruka.");
			return 1;
		}
	}	
	mysql_fquery(g_SQL,
		"UPDATE player_admin_msg SET AdminMessage = '%e', AdminMessageBy = '%e', AdmMessageConfirm = '0' WHERE sqlid = '%d'",
		reason, 
		GetName(playerid, true), 
		sqlid
	);

	SendFormatMessage(playerid, MESSAGE_TYPE_SUCCESS, "You have sucessfully left %s a message: %s", user_name, reason);
	return 1;
}

SendServerMessage(sqlid, reason[])
{
	mysql_fquery(g_SQL, 
		"UPDATE player_admin_msg SET AdminMessage = '%e', AdminMessageBy = 'Server', AdmMessageConfirm = '0' \n\
			WHERE sqlid = '%d'",
		reason, 
		sqlid
	);
	return 1;
}