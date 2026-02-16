# GraphSnapshot - Complete graph state at a point in time
#
# stack_id and stack_version are separate fields to preserve the existing
# separation in StatePersistence. External tools should use stack_version
# for version filtering, not parse it from stack_id.

builtin_interfaces/Time timestamp
string stack_name
string stack_id
string stack_version
string status                  # converged | drifted | reconciling | safety_degraded | unknown
NodeState[] desired_nodes
NodeState[] actual_nodes
GraphDrift drift
