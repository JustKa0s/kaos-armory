Config = {}

Config.OnlyPolicemen = true

Config.ReceiveAmmo = 250
Config.Perm = "police.pc"

Config.Armory = { ["x"] = 452.32196044922, ["y"] = -980.03033447266, ["z"] = 30.689582824707, ["h"] = 270.0 }
Config.ArmoryPed = { ["x"] = 454.18048095703, ["y"] = -980.11981201172, ["z"] = 30.689603805542, ["h"] = 90.0, ["hash"] = "s_m_m_security_01" }

Config.Weapons = { -- https://wiki.rage.mp/index.php?title=Weapons Her kan i finde de forskellige våben modeller
    {
        weaponModel = "weapon_combatpistol",
        title = "Tjeneste pistol"
    },
    {
        weaponModel = "weapon_smg",
        title = "SMG"
    },
    {
        weaponModel = "weapon_stungun",
        title = "Strømpistol"
    },
    {
        weaponModel = "weapon_nightstick",
        title = "Stav"
    },
    {
        weaponModel = "weapon_carbinerifle",
        title = "Carbine Rifle"
    }
--  { - fx:
--     weaponModel = "weapon_bat",
--     title = "Bat"
--  }
}