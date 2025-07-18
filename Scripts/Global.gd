# Global.gd
extends Node

var goods = {
	"medicine": {"weight": 2, "value": 150, "risk": 0.9},
	"food": {"weight": 1, "value": 50, "risk": 0.3},
	"fuel": {"weight": 3, "value": 100, "risk": 0.7},
	"electronics": {"weight": 2, "value": 200, "risk": 0.8}
}

var crew = {
	"lookout": {"cost": 75, "effect": "risk_reduction"}
}

var player_money = 1000
var selected_goods = []
var hired_crew = []
