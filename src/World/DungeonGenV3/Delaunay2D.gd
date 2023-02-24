extends Node
class_name Delaunay2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

class Edge:
	var a: Vector2
	var b: Vector2
	
	func _init(a: Vector2, b: Vector2):
		self.a = a
		self.b = b

	func equals(edge: Edge) -> bool:
		return (a == edge.a && b == edge.b) || (a == edge.b && b == edge.a)
	
	func length() -> float:
		return a.distance_to(b)
	
	func center() -> Vector2:
		return (a + b) * 0.5

class Triangle:
	var a: Vector2
	var b: Vector2
	var c: Vector2
	
	var edge_ab: Edge
	var edge_bc: Edge
	var edge_ca: Edge
	
	var center: Vector2
	var radius_sqr: float
	
	func _init(a: Vector2, b: Vector2, c: Vector2):
		self.a = a
		self.b = b
		self.c = c
		edge_ab = Edge.new(a,b)
		edge_bc = Edge.new(b,c)
		edge_ca = Edge.new(c,a)
		recalculate_circumcircle()
	
	
	func recalculate_circumcircle() -> void:
		var ab := a.length_squared()
		var cd := b.length_squared()
		var ef := c.length_squared()
		
		var cmb := c - b
		var amc := a - c
		var bma := b - a
	
		var circum := Vector2(
			(ab * cmb.y + cd * amc.y + ef * bma.y) / (a.x * cmb.y + b.x * amc.y + c.x * bma.y),
			(ab * cmb.x + cd * amc.x + ef * bma.x) / (a.y * cmb.x + b.y * amc.x + c.y * bma.x)
		)
	
		center = circum * 0.5
		radius_sqr = a.distance_squared_to(center)
		
	func is_point_inside_circumcircle(point: Vector2) -> bool:
		return center.distance_squared_to(point) < radius_sqr
	
	func is_corner(point: Vector2) -> bool:
		return point == a || point == b || point == c
	
	func get_corner_opposite_edge(corner: Vector2) -> Edge:
		if corner == a:
			return edge_bc
		elif corner == b:
			return edge_ca
		elif corner == c:
			return edge_ab
		else:
			return null


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
