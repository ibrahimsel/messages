# GraphEvent - Published only when graph state changes
#
# event_type values: node_appeared, node_disappeared, node_crashed,
# safety_node_lost, drift_detected, drift_resolved,
# reconciliation_started, reconciliation_completed

builtin_interfaces/Time timestamp
string event_type
string stack_name
string node_name
string node_namespace
string details
