/*
 * Sample init.sqf
 * Generated by the ARMAScript New Project Wizard
 */

FHQ_introGo = false;

startLoadingScreen ["", "FHQ_loadingScreen"];
//startLoadingScreen ["Loading something", "myLoadScreen"];

if (isNil "IntroDone") then
{  
	0 fadesound 0;
	cutText ["", "BLACK FADED", 999];
};

FHQ_Difficulty = 0;
FHQ_ViewDistance = 30;
FHQ_FirstAid = 1;

if (getPlayerUID vehicle player == "381634") then
{
    FHQ_DebugMode = 1;
};

call compile preProcessFileLineNumbers "functions\mp\fhqmp.sqf";
call compile preProcessFileLineNumbers "functions\tasks\fhqtt.sqf";
BIS_Effects_Burn = compile preprocessFile "\ca\Data\ParticleEffects\SCRIPTS\destruction\burn.sqf";
"markPatrol" call compile preprocessFileLineNumbers "library\markerMakeTransparent.sqf";


progressLoadingScreen 0.5;
// Override the taskhint
FHQ_TT_taskHint =
{
    private ["_desc", "_state", "_color", "_icon", "_text"];
    
    _desc = _this select 0;
    _state = _this select 1;
    
	_color = "#ffffff";
	_icon = "taskNew";
	_text = "New Task";

	switch (tolower(_state)) do
	{
		case "created":
		{
			_color = "#ffffff";
			_icon = "taskNew";
			_text = "New Task";
		};
		case "assigned":
		{
			_color = "#ffffff";
			_icon = "taskCurrent";
			 _text = "Task Assigned";
		};
		case "succeeded":
		{
			_color = "#19FF19";
			_icon = "taskDone";
			_text = "Task Accomplished";
		};
		case "canceled":
		{
			_color = "#AAAAAA";
			_icon = "taskFailed";
			_text = "Task Cancelled";
		};
		case "failed":
		{
			_color = "#FF3300";
			_icon = "taskFailed";
			_text = "Task Failed";
		};
	};
    
    //taskHint [format ["%1\n%2", _text, _desc], _color, _icon];
    [_text, _desc, _color, _icon] execVM  "library\taskHint.sqf";
};

waitUntil {!isNil "BIS_fnc_init"};
waitUntil {!(isNil "FHQ_MP_InitDone")};

if (!isDedicated) then
{
	waitUntil {!(isNull player)};
    waitUntil {alive player};
};

if (FHQ_FirstAid == 1) then
{
	(units FHQ_playerGroup) call FHQ_fnc_addBISFirstAid;
};

{
     ["AddTopic", [_x, ["speech", "kb\speech.bikb", "kb\bounce.fsm", compile preprocessFileLineNumbers "kb\bounce.sqf"]]] call FHQ_MP_globalEvent;
} forEach ((if (isMultiplayer) then {playableUnits} else {switchableUnits}) + [ComCo, pmcPilot1]);

call compile preprocessFileLineNumbers "scripts\briefing.sqf";
call compile preprocessFileLineNUmbers "scripts\intro.sqf";
call compile preProcessFileLineNumbers "library\debugconsole_support.sqf";
call compile preprocessFileLineNumbers "scripts\loadout.sqf";
call compile preprocessFileLineNumbers "kb\playerChatEvent.sqf";
endLoadingScreen;

// State variables
FHQ_ferryStart = false;
FHQ_ferryEnd = false;
FHQ_foundOperatives = false;
FHQ_foundClient = false;
FHQ_foundSuitcase = false;
FHQ_tellAboutSuitcase = true;

// nul = [group this, getPos this, %1] call BIS_fnc_taskPatrol;
// nul = [group this, getPos this] call BIS_FNC_taskDefend;
// _null = [this, 2] execVM "scripts\checkPresence.sqf";

if (isServer) then {
    [	
		200, 600,
		100, 400, 
		["L39_2_ACR", "Mi24_D_CZ_ACR", "L159_ACR", "Mi17_Civilian", "Ka60_PMC", "An2_1_TK_CIV_EP1"], 
    	FHQ_playerGroup, 	
		3500
	] execVM "library\randomAirTraffic.sqf";
};

call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";