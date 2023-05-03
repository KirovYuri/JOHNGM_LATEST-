// Includes
// - Weapon Config
// - SimpleINI

#define DIALOG_MENU_WC 7777
#define DIALOG_EDIT_WC 7778

new CustomDamage[57];
new SelectedItem;
new Float:tempDamage;

stock Float:s_WeaponDamage[] = {
	1.0, // 0 - Fist
	1.0, // 1 - Brass knuckles
	1.0, // 2 - Golf club
	1.0, // 3 - Nitestick
	1.0, // 4 - Knife
	1.0, // 5 - Bat
	1.0, // 6 - Shovel
	1.0, // 7 - Pool cue
	1.0, // 8 - Katana
	1.0, // 9 - Chainsaw
	1.0, // 10 - Dildo
	1.0, // 11 - Dildo 2
	1.0, // 12 - Vibrator
	1.0, // 13 - Vibrator 2
	1.0, // 14 - Flowers
	1.0, // 15 - Cane
	82.5, // 16 - Grenade
	0.0, // 17 - Teargas
	1.0, // 18 - Molotov
	9.9, // 19 - Vehicle M4 (custom)
	46.2, // 20 - Vehicle minigun (custom)
	0.0, // 21
	8.25, // 22 - Colt 45
	13.2, // 23 - Silenced
	46.2, // 24 - Deagle
	3.3, // 25 - Shotgun
	3.3, // 26 - Sawed-off
	4.95, // 27 - Spas
	6.6, // 28 - UZI
	8.25, // 29 - MP5
	9.9, // 30 - AK47
	9.9, // 31 - M4
	6.6, // 32 - Tec9
	24.75, // 33 - Cuntgun
	41.25, // 34 - Sniper
	82.5, // 35 - Rocket launcher
	82.5, // 36 - Heatseeker
	1.0, // 37 - Flamethrower
	46.2, // 38 - Minigun
	82.5, // 39 - Satchel
	0.0, // 40 - Detonator
	0.33, // 41 - Spraycan
	0.33, // 42 - Fire extinguisher
	0.0, // 43 - Camera
	0.0, // 44 - Night vision
	0.0, // 45 - Infrared
	0.0, // 46 - Parachute
	0.0, // 47 - Fake pistol
	2.64, // 48 - Pistol whip (custom)
	9.9, // 49 - Vehicle
	330.0, // 50 - Helicopter blades
	82.5, // 51 - Explosion
	1.0, // 52 - Car park (custom)
	1.0, // 53 - Drowning
	165.0  // 54 - Splat
};

CreateSettings()
{
	new set[150];
	file_Create("customdamage.ini");
	new File:settings=fopen("customdamage.ini", io_append);
        
	for(new index; index < 57; index++)
	{
		format(set, 150, "%s = %f\n", g_WeaponName[index], s_WeaponDamage[index]);
		fwrite(settings, set);
	}
	fclose(settings);
}

LoadSettings()
{
	if(!fexist("customdamage.ini"))
	{
		print("[Damage Settings] customdamage.ini Could not Found!");
		print("> Creating Settings File...");
		CreateSettings();
		print("> Created.");
	}
	
	print("[Damage Settings] Loading CDamage Tables...");
	file_Open("customdamage.ini");
	
	for(new index; index < 57; index++)
	{
		CustomDamage[index] = floatround(file_GetFloat(g_WeaponName[index]));
		
		tempDamage = floatround(CustomDamage[index]);
		SetWeaponDamage(index, DAMAGE_TYPE_STATIC, tempDamage);
		
		printf("> %s = %i", g_WeaponName[index], CustomDamage[index]);
	}
	
	file_Close();
	print("[Damage Settings] CDamage Tables Loaded!");
}

SaveSettings()
{
	file_Open("customdamage.ini");
	
	for(new index; index < 57; index++)
	{
		tempDamage = floatround(CustomDamage[index]);
		file_SetFloat(g_WeaponName[index], tempDamage);
		SetWeaponDamage(index, DAMAGE_TYPE_STATIC, tempDamage);
	}
	
	file_Save("customdamage.ini");
	file_Close();
}


OpenMenuDialog(editorID)
{
    SelectedItem = 0;
    new menuHeader[50], menuSelection[5000], menuResult[5000];
    
    format(menuHeader, 50, "ID\tName\tValue\n");
    for(new index = 0; index < sizeof(g_WeaponName); index++)
    {
        format(menuSelection, 5000, "%s\t%i\t%s\t%i\n", menuSelection, index, g_WeaponName[index], CustomDamage[index]);
    }
    
    format(menuResult, 5000, "%s%s", menuHeader, menuSelection);
    ShowPlayerDialog(editorID, DIALOG_MENU_WC, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Damage Configuration", menuResult, "Change", "Close");
}
