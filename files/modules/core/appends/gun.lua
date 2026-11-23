local do_global_stats = not ModSettingGet("noita.hardmod.cheeseless_triggers.disabled")

--[[ Global Stats ]]--
--#region

local null_shot_nullify = {
	"damage_electricity_add", "damage_explosion_add", "damage_explosion",
	"damage_critical_chance", "damage_ice_add", "damage_projectile_add",
	"damage_critical_chance", "damage_healing_add", "gore_particles",
}

---@param from ShotState
---@param to ShotState
local function apply_global_stats(from, to)
	if not from or from == to then return end

	if do_global_stats then
		to.fire_rate_wait = from.fire_rate_wait
		to.spread_degrees = from.spread_degrees
	end

	if from.global_null_shot and not to.global_null_shot then
		to.damage_null_all = 1
		for _,key in pairs(null_shot_nullify) do
			to[key] = 0
		end

		to.extra_entities = to.extra_entities.."data/entities/particles/tinyspark_white_small.xml,data/entities/misc/zero_damage.xml,"
		to.global_null_shot = true
	end
end

local orig_draw_shot = draw_shot

---@param shot Shot
function draw_shot(shot, instant_reload_if_empty)
	apply_global_stats(c, shot.state)
	orig_draw_shot(shot, instant_reload_if_empty)
	apply_global_stats(shot.state, c)
end

--#endregion

--[[ Custom Triggers ]]--
--#region

---@alias TriggerType 1|2|3
---@class QueuedTrigger
---@field type TriggerType
---@field draw_count integer
---@field delay_frames integer?

---@type QueuedTrigger[]
trigger_queue = {}
local handle_trigger_queue = false

TRIGGER_HIT_WORLD = 1
TRIGGER_TIMER = 2
TRIGGER_DEATH = 3

local orig_begin_proj = BeginProjectile
function BeginProjectile(...)
	orig_begin_proj(...)

	if handle_trigger_queue then
		handle_trigger_queue = false
		if #trigger_queue == 0 then return end

		local todo = trigger_queue
		trigger_queue = {}

		for _,trigger in pairs(todo) do
			if trigger.type == TRIGGER_HIT_WORLD then BeginTriggerHitWorld()
			elseif trigger.type == TRIGGER_TIMER then BeginTriggerTimer(trigger.delay_frames)
			elseif trigger.type == TRIGGER_DEATH then BeginTriggerDeath()
			else break end

			draw_shot(create_shot(trigger.draw_count), true)
			EndTrigger()
		end
	end
end

local orig_start_shot = _start_shot
function _start_shot(...)
	orig_start_shot(...)
	trigger_queue = {}
	handle_trigger_queue = false
end

local function wrap_add_projectile(orig_fn)
	return function(...)
		if not reflecting then
			handle_trigger_queue = true
		end

		orig_fn(...)
	end
end

add_projectile                   = wrap_add_projectile(add_projectile)
-- TODO: [AT][spark bolt trigger] seems broken, other combinations work fine tho?...
-- dont have energy to figure this out rn
add_projectile_trigger_hit_world = wrap_add_projectile(add_projectile_trigger_hit_world)
add_projectile_trigger_timer     = wrap_add_projectile(add_projectile_trigger_timer)
add_projectile_trigger_death     = wrap_add_projectile(add_projectile_trigger_death)

--#endregion
