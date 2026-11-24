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

---@param trigger QueuedTrigger
function EnqueueTrigger(trigger)
	table.insert(trigger_queue, trigger)
end

function RunTriggerQueue()
	local todo = trigger_queue
	handle_trigger_queue = false
	trigger_queue = {}

	---@type table<TriggerType, { delay_frames: integer, shotstates: integer[] }>
	local groups = {}
	---@type TriggerType[]
	local group_order = {}

	if #todo == 0 then return end

	for _,trigger in pairs(todo) do
		if not groups[trigger.type] then
			table.insert(group_order, trigger.type)
			groups[trigger.type] = {
				delay_frames = trigger.delay_frames or 20,
				shotstates = {}
			}
		end

		table.insert(groups[trigger.type].shotstates, trigger.draw_count or 1)
	end

	for _,type in pairs(group_order) do
		local group = groups[type]

		if type == TRIGGER_HIT_WORLD then BeginTriggerHitWorld()
		elseif type == TRIGGER_TIMER then BeginTriggerTimer(group.delay_frames)
		elseif type == TRIGGER_DEATH then BeginTriggerDeath()
		else goto continue end

		for _,draw_count in pairs(group.shotstates) do
			draw_shot(create_shot(draw_count), true)
		end

		EndTrigger()
		::continue::
	end
end

local orig_begin_proj = BeginProjectile
function BeginProjectile(...)
	orig_begin_proj(...)

	if handle_trigger_queue then
		RunTriggerQueue()
	end
end

local orig_start_shot = _start_shot
function _start_shot(...)
	orig_start_shot(...)
	trigger_queue = {}
	handle_trigger_queue = false
end

local orig_add_projectile = add_projectile
function add_projectile(file)
	if not reflecting and #trigger_queue > 0 then
		handle_trigger_queue = true
	end

	orig_add_projectile(file)
end

local orig_add_trigger = add_projectile_trigger_hit_world
function add_projectile_trigger_hit_world(file, draws)
	if not reflecting and #trigger_queue > 0 then
		EnqueueTrigger({
			type = TRIGGER_HIT_WORLD,
			draw_count = draws
		})

		add_projectile(file)
		return
	end

	orig_add_trigger(file, draws)
end

local orig_add_timer = add_projectile_trigger_timer
function add_projectile_trigger_timer(file, delay_frames, draws)
	if not reflecting and #trigger_queue > 0 then
		EnqueueTrigger({
			type = TRIGGER_TIMER,
			delay_frames = delay_frames,
			draw_count = draws
		})

		add_projectile(file)
		return
	end

	orig_add_timer(file, delay_frames, draws)
end

local orig_add_exptrigger = add_projectile_trigger_death
function add_projectile_trigger_death(file, draws)
	if not reflecting and #trigger_queue > 0 then
		EnqueueTrigger({
			type = TRIGGER_DEATH,
			draw_count = draws
		})
	
		add_projectile(file)
		return
	end

	orig_add_exptrigger(file, draws)
end

--#endregion
