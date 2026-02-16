# DesiredState - Typed desired state channel (replaces std_msgs/String)
#
# Published by Composer to /muto/daemon/desired_state after deployment
# or baseline learning. The Daemon caches this for drift comparison.
#
# paused=true signals the Daemon to skip drift detection during version
# transitions. ignored_prefixes lists FQN prefixes (e.g. /rviz, /_) that
# should not be flagged as unexpected.

builtin_interfaces/Time timestamp
string stack_name
string stack_id
string stack_version
NodeState[] desired_nodes
bool paused
string[] ignored_prefixes
