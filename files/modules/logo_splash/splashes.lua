local y,m,d = GameGetDateAndTimeUTC()
local evil_level = (y * 31469 + m * 929 + d * 541) % 100 + 1

local splashes = {
	-- TODO: update this before release
	-- (you can use `tokei`, or just ping me on discord @.qtyui)
	"15,000 Lines Of Code",

	"Evil Level Today: " .. evil_level .. "%",
	"Dunk is bald",
	"Now atleast 1% harder!",
	"I hope you like dying!",
	"Eba was here",
	"Insert splash text here",
	"Dani was here",
	"Every pixel is stimulated",
	"UserK",
	"Brought to you by Team Fairmod",
	"A Notla Classic!",
	"Now with 100% more false-walls!",
	"Well it's not Fairmod!",
	"We were nice this time!",
	">:)",
	"Welcome to your Doom!",
	"Conga Lyne was here",
	"10,000 witches used to make it to the work, now it's a ghost town",
	"Community Collab Mod 2026!",
	"Betcha can't even make it past Hiisi Base!",
	"Now do an all bosses run!",
	"Recommended by 9 out of 10 dentists!",
	"You won't last 5 minutes",
	"Nightmare Impossible Unwinnable Beyond Hell Edition!",
	"Ira was here",
	"Arduus!",
	"Nuke yourself today to heal to full health!",
	"Call 1800-Kolmisilma for a refund on all defective chainsaws",
	"Every pixel is simulated to kill you",
	"You CAN Win Me; I CAN Be Beat :)",
	"TANNEREYE IS DEAD.",
	"Ira approaches",
	"Ira? More like IRATE!!! gottem",
	"The Divine is on the phone, pick up.",
	"\"Fair mod too\"? I sure hope it is!",
	"Enemies may bleed lava!",
	"Crystals entwined deceive divine!",
	"Note: Some things may be 1% easier",
	"Now with rotation!",
	"Everyone say \"Thank you Lamier\" for making this text rotatable!",
	"Saving Grace had it coming.",
	"Beat this to unlock Epilogue 3!",
	"Lamia was drunk",
	"qtyui_ was here",
	"Hämis :+1:",
	"NT Sadge",
	"Sponsored by CEO Hiisilius IV",
	"No Fun Allowed",
	"0% cheese!",
	"Fair Mod 2: This Time It's Actually Fair",
	"Fixes NB-13, NB-25 and NB-103",
	"Restored 5wand!",
	"exploding u :3",
	"noita.harmod",
	"woag...\nnewline...",
	"why do these splashes keep mentioning a \"fair mod\"????",
	"We added Polymorph Immunity perk!!!! (enemies only)",
	"Made with love, passion, and also a lot of spite!",
	"What do you mean the deadline is nearly up?!?",
}

local cool_mods = {
	"Fairmod",
	"Perkageddon",
	"Apotheosis",
	"D2D Content Pack",
}
for _,coolmod in ipairs(cool_mods) do
	splashes[#splashes+1] = "Also try "..coolmod.."!"
end

return splashes
