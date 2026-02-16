# GraphDrift - Diff between desired and actual graph state

string[] missing_nodes         # Desired FQNs not found in actual set
string[] unexpected_nodes      # Actual FQNs not in desired set and not in ignored_prefixes
string[] parameter_drifts      # Parameter drift descriptions (future use)
builtin_interfaces/Time timestamp
