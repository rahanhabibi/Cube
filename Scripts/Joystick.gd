extends Control

var output_vector: Vector2 = Vector2.ZERO
var _touch_index: int = -1
var _center: Vector2
var _knob: Vector2
var _radius: float = 66.0

func _ready() -> void:
    _center = size * 0.5
    _knob = _center
    mouse_filter = Control.MOUSE_FILTER_STOP
    queue_redraw()

func _notification(what: int) -> void:
    if what == NOTIFICATION_RESIZED:
        _center = size * 0.5
        if _touch_index == -1:
            _knob = _center
        queue_redraw()

func _gui_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed and _touch_index == -1:
            _touch_index = event.index
            _update_stick(event.position)
            accept_event()
        elif not event.pressed and event.index == _touch_index:
            _release_stick()
            accept_event()
    elif event is InputEventScreenDrag and event.index == _touch_index:
        _update_stick(event.position)
        accept_event()
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            _touch_index = 0
            _update_stick(event.position)
        else:
            _release_stick()
        accept_event()
    elif event is InputEventMouseMotion and _touch_index == 0 and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        _update_stick(event.position)
        accept_event()

func _update_stick(pos: Vector2) -> void:
    var delta := pos - _center
    if delta.length() > _radius:
        delta = delta.normalized() * _radius
    _knob = _center + delta
    output_vector = Vector2(delta.x / _radius, delta.y / _radius).limit_length(1.0)
    queue_redraw()

func _release_stick() -> void:
    _touch_index = -1
    _knob = _center
    output_vector = Vector2.ZERO
    queue_redraw()

func _draw() -> void:
    draw_circle(_center, _radius + 9.0, Color(0.05, 0.08, 0.12, 0.22))
    draw_circle(_center, _radius, Color(0.12, 0.16, 0.22, 0.48))
    draw_arc(_center, _radius, 0, TAU, 48, Color(1, 1, 1, 0.55), 3.0, true)
    draw_circle(_knob, 29.0, Color(0.92, 0.96, 1.0, 0.88))
    draw_arc(_knob, 29.0, 0, TAU, 32, Color(0.18, 0.25, 0.35, 0.9), 2.0, true)
