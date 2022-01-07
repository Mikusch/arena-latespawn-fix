/*
 * Copyright (C) 2021  Mikusch
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <sourcemod>
#include <dhooks>
#include <tf2_stocks>

#pragma semicolon 1
#pragma newdecls required

#define TF_GAMETYPE_ARENA	4

static DynamicHook g_DHookShouldGainInstantSpawn;

public Plugin myinfo =
{
	name = "[TF2] Arena Late Spawn Fix",
	author = "Mikusch",
	description = "Fixes players spawning during the round in arena mode",
	version = "1.1.1",
	url = "https://github.com/Mikusch/arena-latespawn-fix"
}

public void OnPluginStart()
{
	AddCommandListener(CommandListener_JoinClass, "joinclass");
	AddCommandListener(CommandListener_JoinClass, "join_class");
	
	GameData gamedata = new GameData("arena-latespawn-fix");
	if (!gamedata)
		SetFailState("Could not find arena-latespawn-fix gamedata");
	
	g_DHookShouldGainInstantSpawn = CreateDynamicHook(gamedata, "CTFPlayer::ShouldGainInstantSpawn");
	delete gamedata;
	
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client))
			OnClientPutInServer(client);
	}
}

public void OnClientPutInServer(int client)
{
	if (g_DHookShouldGainInstantSpawn)
		g_DHookShouldGainInstantSpawn.HookEntity(Hook_Post, client, DHookCallback_ShouldGainInstantSpawn_Post);
}

public Action CommandListener_JoinClass(int client, const char[] command, int args)
{
	// Prevents an exploit that allows players to spawn on team unassigned
	if (TF2_GetClientTeam(client) == TFTeam_Unassigned)
		return Plugin_Handled;
	
	return Plugin_Continue;
}

public MRESReturn DHookCallback_ShouldGainInstantSpawn_Post(int client, DHookReturn ret)
{
	// Prevents an exploit that allows players to spawn during a running round
	if (GameRules_GetProp("m_nGameType") == TF_GAMETYPE_ARENA)
	{
		ret.Value = false;
		return MRES_Supercede;
	}
	
	return MRES_Ignored;
}

static DynamicHook CreateDynamicHook(GameData gamedata, const char[] name)
{
	DynamicHook hook = DynamicHook.FromConf(gamedata, name);
	if (!hook)
		LogError("Failed to create hook setup handle for %s", name);
	
	return hook;
}
