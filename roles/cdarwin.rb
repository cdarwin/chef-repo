name "cdarwin"
description "Setup cdarwin user and configure sudo and stuff."
# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list(
    "recipe[users::sysadmins]",
    "recipe[sudo]",
    "recipe[cdarwin]"
)
# Attributes applied if the node doesn't have it set already.
#default_attributes()
# Attributes applied no matter what the node has set already.
override_attributes(
    :authorization => {
        :sudo => {
            :groups => ["sudo", "admin", "sysadmin"],
            :users => ["ubuntu", "cdarwin"],
            :passwordless => true
        }
    }
)
