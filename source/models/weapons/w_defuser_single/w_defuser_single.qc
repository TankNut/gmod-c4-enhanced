// Created by Crowbar 0.63

$modelname "weapons\w_defuser_single.mdl"

$body "studio" "w_defuser_single.smd"

$surfaceprop "weapon"
$contents "solid"

$cdmaterials "models\weapons\w_models\w_eq_defuser\"

$sequence "idle" {
	"w_defuser_single_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_defuser_single_physics.smd"
{
	$mass 15
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}

$KeyValues
{
	prop_data 
	{
		"base" "Metal.Small"
	}
}
