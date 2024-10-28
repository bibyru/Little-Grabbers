extends Node3D

func PlatformPress():
	$AnimationPlayer.play("ButtonPressed")

func PlatformUnpress():
	$AnimationPlayer.play("ButtonUnpress")
