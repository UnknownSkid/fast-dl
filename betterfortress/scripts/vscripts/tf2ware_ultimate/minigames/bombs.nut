minigame <- Ware_MinigameData
({
	name          = "Bombs Away"
	author		  = ["sasch", "ficool2"]
	description   = "Survive the bombs!"
	duration      = 4.0
	music         = "ohno"
	start_pass    = true
	allow_damage  = true
	fail_on_death = true
})

bomb_model <- "models/workshop/weapons/c_models/c_quadball/w_quadball_grenade.mdl"

function OnPrecache()
{
	PrecacheModel(bomb_model)
}

function OnStart()
{
	Ware_SetGlobalLoadout(TF_CLASS_PYRO, "Flame Thrower")
	Ware_CreateTimer(@() SpawnBombs(), 0.1)
	Ware_CreateTimer(@() SpawnBombs(), 0.2)
}

function OnUpdate()
{
	foreach (player in Ware_MinigamePlayers)
		Ware_DisablePlayerPrimaryFire(player)
}

function SpawnBombs()
{
	local mins = Ware_MinigameLocation.mins
	local maxs = Ware_MinigameLocation.maxs
	
	foreach (player in Ware_MinigamePlayers)
	{
		local pipe = Ware_CreateEntity("tf_projectile_pipe")
		
		SetPropFloat(pipe, "m_flDamage", 250.0)
		SetPropInt(pipe, "m_iTeamNum", TEAM_SPECTATOR)
		SetPropFloat(pipe, "m_flModelScale", 2.0)
		
		local origin = player.GetOrigin()
		origin += Vector(RandomFloat(-150, 150), RandomFloat(-150, 150), RandomFloat(350, 450))
		origin.x = Clamp(origin.x, mins.x, maxs.x)
		origin.y = Clamp(origin.y, mins.y, maxs.y)
		pipe.SetAbsOrigin(origin)
		
		Ware_SlapEntity(pipe, 160.0)
		
		pipe.DispatchSpawn()
		pipe.SetModel(bomb_model)
	}
}