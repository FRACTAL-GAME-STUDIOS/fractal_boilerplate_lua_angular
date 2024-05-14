if not MySQL then
    print('MySQL is not loaded, please uncomment the MySQL resource in your server.cfg or fxmanifest.lua of this resource.')
    return
end

function Load()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `fractal_crafting_tables` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `name` VARCHAR(50) DEFAULT 'Standard Bench',
            `type` VARCHAR(50) DEFAULT 'Crafting',
            `coords` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '[]' CHECK (json_valid(`coords`)),
            `model` VARCHAR(50) DEFAULT 'gr_prop_gr_bench_02b',
            `blip` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '[]' CHECK (json_valid(`blip`)),
            `available` TINYINT(1) DEFAULT 1,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1; 
    ]], {}, function(response)
        if response.changedRows > 0 then
            print('Created fractal_crafting table')
        end
    end)

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `fractal_crafting_blueprints` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `bench_id` INT(11) NOT NULL,
            `name` VARCHAR(50) DEFAULT NULL,
            `category` VARCHAR(50) DEFAULT NULL,
            PRIMARY KEY (`id`),
            FOREIGN KEY (`bench_id`) REFERENCES `fractal_crafting_tables`(`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1;
    ]], {}, function(response)
        if response.changedRows > 0 then
            print('Created fractal_crafting_blueprints table')
        end
    end)

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `fractal_crafting_modules` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `bench_id` INT(11) NOT NULL,
            `name` VARCHAR(50) DEFAULT NULL,
            `category` VARCHAR(50) DEFAULT NULL,
            PRIMARY KEY (`id`),
            FOREIGN KEY (`bench_id`) REFERENCES `fractal_crafting_tables`(`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1;
    ]], {}, function(response)
        if response.changedRows > 0 then
            print('Created fractal_crafting_modules table')
        end
    end)
end

MySQL.ready(function()
    Load()
end)