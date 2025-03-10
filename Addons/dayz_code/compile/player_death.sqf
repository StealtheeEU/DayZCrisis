private ["_display","_body","_playerID","_array","_source","_method","_canHitFree","_isBandit","_punishment","_humanityHit","_myKills","_humanity","_kills","_killsV","_myGroup"];
disableSerialization;
if (deathHandled) exitWith {};

deathHandled = true;
//Death
//Prevent client freezes
_display = findDisplay 49;
if(!isNull _display) then {_display closeDisplay 0;};
if (dialog) then {closeDialog 0;};
if (visibleMap) then {openMap false;};

_body = player;
_playerID = getPlayerUID player;
disableUserInput true;
//add weapon on back to player...
if (dayz_onBack != "") then {
		_body addWeapon dayz_onBack;
};
//Send Death Notice
//["PVDZ_plr_Death",[dayz_characterID,0,_body,_playerID,dayz_playerName]] call callRpcProcedure;
		PVDZ_plr_Death = [dayz_characterID,0,_body,_playerID];
		publicVariableServer "PVDZ_plr_Death";

_id = [player,20,true,getPosATL player] call player_alertZombies;

sleep 0.5;

player setDamage 1;
0.1 fadeSound 0;

player setVariable ["NORRN_unconscious", false, true];
player setVariable ["unconsciousTime", 0, true];
player setVariable ["USEC_isCardiac",false,true];
player setVariable ["medForceUpdate",true,true];
//remove combat timer on death
player setVariable ["startcombattimer", 0];
r_player_unconscious = false;
r_player_cardiac = false;


_array = _this;
if (count _array > 0) then {
	_source = _array select 0;
	_method = _array select 1;
	if ((!isNull _source) and (_source != player)) then {
		_canHitFree = player getVariable ["freeTarget",false];
		_isBandit = (player getVariable["humanity",0]) <= -2000;
		_punishment = _canHitFree or _isBandit; //if u are bandit or start first - player will not recieve humanity drop
		_humanityHit = 0;
		if (!_punishment) then {
			//i'm "not guilty" - kill me and be punished
			_myKills = ((player getVariable ["humanKills",0]) / 30) * 1000;
			_humanityHit = -(2000 - _myKills);
			_kills = _source getVariable ["humanKills",0];
			_source setVariable ["humanKills",(_kills + 1),true];
			PVDZ_send = [_source,"Humanity",[_source,_humanityHit,300]];
			publicVariableServer "PVDZ_send";
		} else {
			//i'm "guilty" - kill me as bandit
			_killsV = _source getVariable ["banditKills",0];
			_source setVariable ["banditKills",(_killsV + 1),true];
		};
	};
	_body setVariable ["deathType",_method,true];
};

terminate dayz_musicH;
//terminate dayz_lootCheck;
terminate dayz_slowCheck;
terminate dayz_animalCheck;
terminate dayz_monitor1;
terminate dayz_medicalH;
terminate dayz_gui;
//terminate dayz_zedCheck;
terminate dayz_locationCheck;
//terminate dayz_combatCheck;
//terminate dayz_spawnCheck;

//Reset (just in case)
//deleteVehicle dayz_playerTrigger;
//disableUserInput false;
r_player_dead = true;

"dynamicBlur" ppEffectEnable true;"dynamicBlur" ppEffectAdjust [4]; "dynamicBlur" ppEffectCommit 0.2;

"colorCorrections" ppEffectEnable true;
"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 0.01],  [1, 1, 1, 0.0]];
"colorCorrections" ppEffectCommit 1;

//Player is Dead!
3 fadeSound 0;
sleep 1;

dayz_originalPlayer enableSimulation true;

addSwitchableUnit dayz_originalPlayer;
setPlayable dayz_originalPlayer;
selectPlayer dayz_originalPlayer;

_myGroup = group _body;
[_body] joinSilent dayz_firstGroup;
deleteGroup _myGroup;

3 cutRsc ["default", "PLAIN",3];
4 cutRsc ["default", "PLAIN",3];

_body setVariable["combattimeout", 0, true];

//["dayzFlies",player] call broadcastRpcCallAll;
sleep 2;

1 cutRsc ["dsow","BLACK OUT",3];

playMusic "dayz_track_death_1";

"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit 5;
"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 1],  [1, 1, 1, 1]];"colorCorrections" ppEffectCommit 5;

sleep 2;

for  "_x" from 5 to 1 step -1 do {
	titleText [format[localize "str_return_lobby", _x], "PLAIN DOWN", 1];
	sleep 1;
};

PVDZ_Server_Simulation = [_body, false];
publicVariableServer "PVDZ_Server_Simulation";

endMission "END1";
