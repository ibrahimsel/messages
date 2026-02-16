# NodeState - Represents a single ROS 2 node in the graph
#
# For stack/declarative and stack/legacy (with nodes), package_name and
# executable are populated from the manifest. For stack/workspace and
# stack/native, these fields are EMPTY in the learned baseline because
# ROS 2 graph introspection APIs do not expose this metadata.
#
# managed_by_muto is set by the Daemon's DriftDetector: true if the
# node's FQN matches an entry in the desired state set.

string name
string namespace
string fully_qualified_name
string package_name
string executable
string status                  # running | missing | unexpected | crashed
string[] publisher_topics
string[] subscriber_topics
string[] service_names
bool managed_by_muto
