//Sistema de Anti-Lock ON "Samp-Laucher"
//Add Include "LockOn"

#include <a_samp>
#include <lockon>

#define funcao%0(%1) \
	forward%0(%1); public%0(%1)
	
#define 	Vermelho  						0xFF0000C8
#define     SCMToAll 						SendClientMessageToAll
#define 	DIALOG_LOCKON                  (0)

public OnFilterScriptInit()
{
	print("Carregando Lock-On");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

stock KickDelay(playerid)
{
	SetTimerEx("KickMe", 1000, false, "d", playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new Detect[150];
	if(PlayerMobileInfo[playerid][isHaveAutoaim] == true)
	{
		format(Detect, sizeof(Detect), "[Anti-Lock-On] {ffffff}%s {ff2400}was kicked automatically!", pNome(playerid));
	    SCMToAll(Vermelho,Detect);
	    KickDelay(playerid);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

stock pNome(playerid)
{
	new GetNome[24];
	GetPlayerName(playerid, GetNome, 24);
	return GetNome;
}

funcao KickMe(playerid)
{
	return Kick(playerid);
}
