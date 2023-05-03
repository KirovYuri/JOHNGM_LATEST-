//Anti DDoS Attack Filterscript by Jankingston. Feel free to modify ;)

#include <a_samp>
#include <FileFunctions>

#define ATTACK_TYPE_PLAYERID 1
#define ATTACK_TYPE_IP 2

new File:ServerLogFile;
new addostimer;

main()
{
	print("|----------------------------------|");
	print("| Anti DDOS filterscript v0.1      |");
	print("|----------------------------------|");
}

public OnFilterScriptInit()
{
	ServerLogFile = fileOpen("server_log.txt", io_Read);
	addostimer = SetTimer("Anti-DDoS", 100, true);
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(addostimer);
	return 1;
}

forward AntiDDoS();
public AntiDDoS()
{
	if(!ServerLogFile)
	{
		print("Error opening server_log.txt!");
		KillTimer(addostimer);
	}
	else
	{
		new string[128];
		new strarr[2][20];
		fileSeek(ServerLogFile, -128, seek_End);
		while(fileRead(ServerLogFile, string)){}

		new pos = strfind(string, "Invalid client connecting from ", true, 10);
		if(pos == 11)
		{
			OnDDosAttackAttempt(ATTACK_TYPE_IP, INVALID_PLAYER_ID, string[pos+31]);
		}

		pos = strfind(string, "Warning: /rcon command exploit from: ", true, 10);
		if(pos == 11){
			split(string[pos+37], strarr, ':');
			OnDDosAttackAttempt(ATTACK_TYPE_PLAYERID, strval(strarr[0]), strarr[1]);
		}

		pos = strfind(string, "Warning: PlayerDialogResponse PlayerId: ", true, 10);
		if(pos == 11){

			new idx = 0;
			new plid = strval(strtok(string[pos+39], idx));
			SetPVarInt(plid, "dialogDDosAtt", GetPVarInt(plid, "dialogDDosAtt")+1);
			print("");
			if(GetPVarInt(plid, "dialogDDosAtt") > 2)OnDDosAttackAttempt(ATTACK_TYPE_PLAYERID, plid, " ");
		}

		pos = strfind(string, "Warning: PlayerDialogResponse crash exploit from PlayerId: ", true, 10);
		if(pos == 11){
			new idx = 0;
			OnDDosAttackAttempt(ATTACK_TYPE_PLAYERID, strval(strtok(string[pos+59], idx)), " ");
		}

		pos = strfind(string, "Packet was modified, sent by id: ", true, 10);
		if(pos == 11){
		    split(string[pos+33], strarr, ',');
			OnDDosAttackAttempt(ATTACK_TYPE_PLAYERID, strval(strarr[0]), " ");
		}

		pos = strfind(string, "Remote Port Refused for Player: ", true, 10);
		if(pos == 11){
			new idx = 0;
			OnDDosAttackAttempt(ATTACK_TYPE_PLAYERID, strval(strtok(string[pos+32], idx)), " ");
		}

		if(strfind(string, " due to a 'server full' attack") != -1)
		{
			pos = strfind(string, "Blocking ", true, 10);
			if(pos == 12)
			{
				new idx = 0;
				OnDDosAttackAttempt(ATTACK_TYPE_IP, INVALID_PLAYER_ID, strtok(string[pos+9], idx));
			}
		}
	}
}

forward OnDDosAttackAttempt(type, playerid, ip[]);
public OnDDosAttackAttempt(type, playerid, ip[])
{
    new string[128];
	if(type == ATTACK_TYPE_PLAYERID)
	{//block a playerid
		BanEx(playerid, "DDOS protect");
		printf("Blocked attack from playerid %d", playerid);

	}else if(type == ATTACK_TYPE_IP)
	{//block an ip address
        format(string, sizeof(string), "banip %s", ip);
		SendRconCommand(string);
		printf("Blocked attack from ip: %s", ip);
	}

}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;
		}
		i++;
	}
	return 1;
}
