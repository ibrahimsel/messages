# Muto Messages

| ROS 2 Distro | Ubuntu | Python | Status |
|---|---|---|---|
| Foxy | 20.04 | 3.8 | [![Foxy](https://github.com/ibrahimsel/messages/actions/workflows/ci-foxy.yml/badge.svg)](https://github.com/ibrahimsel/messages/actions/workflows/ci-foxy.yml) |
| Humble | 22.04 | 3.10 | [![Humble](https://github.com/ibrahimsel/messages/actions/workflows/ci-humble.yml/badge.svg)](https://github.com/ibrahimsel/messages/actions/workflows/ci-humble.yml) |
| Jazzy | 24.04 | 3.12 | [![Jazzy](https://github.com/ibrahimsel/messages/actions/workflows/ci-jazzy.yml/badge.svg)](https://github.com/ibrahimsel/messages/actions/workflows/ci-jazzy.yml) |

**Muto Messages** (`muto_msgs`) provides ROS 2 message and service definitions for inter-component communication including stack manifests, actions, commands, and plugin interfaces.

## Messages

### PluginResponse

Standard outcome returned by all plugins to indicate success or failure.

| Field | Type | Description |
|---|---|---|
| `result_code` | `uint32` | `0` for success, non-zero for error. |
| `error_message` | `string` | Short error name (empty on success). |
| `error_description` | `string` | Detailed error description (empty on success). |

```python
from muto_msgs.msg import PluginResponse

resp = PluginResponse()
resp.result_code = 0
resp.error_message = ''
resp.error_description = ''
```

### MutoActionMeta

Metadata attached to action requests, used for MQTT request/reply correlation.

| Field | Type | Description |
|---|---|---|
| `response_topic` | `string` | MQTT topic to publish the response to. |
| `correlation_data` | `string` | Opaque identifier to match responses to requests. |

```python
from muto_msgs.msg import MutoActionMeta

meta = MutoActionMeta()
meta.response_topic = 'muto/reply/device-01'
meta.correlation_data = 'req-abc-123'
```

### MutoAction

A remote action request received from the cloud or another Muto agent.

| Field | Type | Description |
|---|---|---|
| `context` | `string` | Target thing ID (e.g. `org.eclipse.muto:device-01`). |
| `method` | `string` | Action method name (e.g. `start`, `stop`, `apply`). |
| `payload` | `string` | JSON-encoded payload for the action. |
| `meta` | `MutoActionMeta` | Reply routing metadata. |

```python
from muto_msgs.msg import MutoAction

action = MutoAction()
action.context = 'org.eclipse.muto:device-01'
action.method = 'apply'
action.payload = '{"stack_id": "nav-stack-v2"}'
```

### StackManifest

Full description of a deployable software stack.

| Field | Type | Description |
|---|---|---|
| `name` | `string` | Human-readable stack name. |
| `context` | `string` | Thing ID that owns this stack. |
| `stack_id` | `string` | Unique identifier for the stack definition. |
| `type` | `string` | Stack type (e.g. `ros2_launch`, `docker_compose`). |
| `stack` | `string` | JSON or YAML stack definition body. |
| `url` | `string` | Git URL to fetch the stack source from. |
| `branch` | `string` | Git branch to checkout. |
| `launch_description_source` | `string` | Path to the launch file within the checked-out source. |
| `args` | `string` | JSON-encoded launch arguments. |
| `source` | `string` | Local filesystem path to the stack source after provisioning. |
| `on_start` | `string` | Hook command to run before starting the stack. |
| `on_kill` | `string` | Hook command to run before stopping the stack. |
| `result` | `PluginResponse` | Outcome of the last plugin that processed this manifest. |

```python
from muto_msgs.msg import StackManifest

manifest = StackManifest()
manifest.name = 'Navigation Stack v2'
manifest.stack_id = 'nav-stack-v2'
manifest.type = 'ros2_launch'
manifest.url = 'https://github.com/example/nav-stack.git'
manifest.branch = 'main'
manifest.launch_description_source = 'launch/navigation.launch.py'
```

### PlanManifest

A composed deployment pipeline that chains plugin steps together.

| Field | Type | Description |
|---|---|---|
| `pipeline` | `string` | Ordered list of plugin names to execute (JSON array). |
| `current` | `StackManifest` | The stack manifest being processed through the pipeline. |
| `result` | `PluginResponse` | Overall pipeline result. |

```python
from muto_msgs.msg import PlanManifest, StackManifest

plan = PlanManifest()
plan.pipeline = '["provision", "compose", "launch"]'
plan.current = StackManifest()
plan.current.name = 'Navigation Stack v2'
```

### CommandInput

Input for the command plugin system.

| Field | Type | Description |
|---|---|---|
| `command` | `string` | Command name to execute (e.g. `ros2_node_list`, `ros2_topic_echo`). |
| `payload` | `string` | JSON-encoded arguments for the command. |

```python
from muto_msgs.msg import CommandInput

cmd = CommandInput()
cmd.command = 'ros2_topic_list'
cmd.payload = '{}'
```

### CommandOutput

Result of a command plugin execution.

| Field | Type | Description |
|---|---|---|
| `payload` | `string` | JSON-encoded command output. |
| `result` | `PluginResponse` | Success/failure status. |

```python
from muto_msgs.msg import CommandOutput

output = CommandOutput()
output.payload = '{"topics": ["/cmd_vel", "/odom", "/scan"]}'
output.result.result_code = 0
```

### ThingHeaders

Eclipse Ditto protocol headers for digital-twin messages.

| Field | Type | Description |
|---|---|---|
| `reply_to` | `string` | Address to send replies to. |
| `correlation_id` | `string` | Request correlation identifier. |
| `ditto_originator` | `string` | Identity of the message originator in Ditto. |
| `response_required` | `bool` | Whether a response is expected. |
| `content_type` | `string` | MIME type of the payload (e.g. `application/json`). |

```python
from muto_msgs.msg import ThingHeaders

headers = ThingHeaders()
headers.correlation_id = 'cmd-456'
headers.response_required = True
headers.content_type = 'application/json'
```

### Thing

An Eclipse Ditto digital-twin protocol message.

| Field | Type | Description |
|---|---|---|
| `topic` | `string` | Ditto protocol topic (e.g. `org.eclipse.muto/device-01/things/twin/commands/modify`). |
| `headers` | `ThingHeaders` | Ditto protocol headers. |
| `path` | `string` | JSON pointer path within the thing (e.g. `/features/stack/properties/current`). |
| `value` | `string` | JSON-encoded value to set at the path. |
| `channel` | `string` | Ditto channel (`twin` or `live`). |
| `action` | `string` | Ditto action (`next`, `complete`, `failed`). |
| `meta` | `MutoActionMeta` | MQTT reply metadata. |

```python
from muto_msgs.msg import Thing, ThingHeaders

thing = Thing()
thing.topic = 'org.eclipse.muto/device-01/things/twin/commands/modify'
thing.path = '/features/stack/properties/current'
thing.value = '{"name": "nav-stack-v2"}'
thing.channel = 'twin'
thing.headers = ThingHeaders()
thing.headers.content_type = 'application/json'
```

### Gateway

Envelope for messages bridged between MQTT and the ROS 2 graph.

| Field | Type | Description |
|---|---|---|
| `topic` | `string` | MQTT topic the message was received on or should be published to. |
| `payload` | `string` | Raw JSON payload. |
| `meta` | `MutoActionMeta` | Reply routing metadata. |

```python
from muto_msgs.msg import Gateway

gw = Gateway()
gw.topic = 'muto/inbox/device-01'
gw.payload = '{"method": "apply", "stack_id": "nav-stack-v2"}'
```

## Services

### CommandPlugin

Execute a command through the pluggable command system.

**Request:**

| Field | Type | Description |
|---|---|---|
| `input` | `CommandInput` | Command name and arguments. |

**Response:**

| Field | Type | Description |
|---|---|---|
| `output` | `CommandOutput` | Command result and status. |

```python
from muto_msgs.srv import CommandPlugin
from muto_msgs.msg import CommandInput

req = CommandPlugin.Request()
req.input = CommandInput()
req.input.command = 'ros2_topic_list'
req.input.payload = '{}'

# response.output.payload contains the result JSON
# response.output.result.result_code == 0 on success
```

### ComposePlugin

Run the compose (orchestration) step of a deployment pipeline. The composer resolves the pipeline definition and chains the appropriate plugins.

**Request:**

| Field | Type | Description |
|---|---|---|
| `start` | `bool` | `True` to start composing, `False` to cancel. |
| `input` | `PlanManifest` | Pipeline definition and stack manifest. |

**Response:**

| Field | Type | Description |
|---|---|---|
| `output` | `PlanManifest` | Updated manifest after composition. |
| `success` | `bool` | Whether the compose step succeeded. |
| `err_msg` | `string` | Error message if `success` is `False`. |

```python
from muto_msgs.srv import ComposePlugin
from muto_msgs.msg import PlanManifest, StackManifest

req = ComposePlugin.Request()
req.start = True
req.input = PlanManifest()
req.input.pipeline = '["provision", "launch"]'
req.input.current = StackManifest()
req.input.current.name = 'Navigation Stack v2'

# response.success == True on success
# response.output contains the updated PlanManifest
```

### LaunchPlugin

Start or stop a ROS 2 launch file as part of a deployment pipeline.

**Request:**

| Field | Type | Description |
|---|---|---|
| `start` | `bool` | `True` to launch, `False` to stop. |
| `input` | `PlanManifest` | Pipeline context with stack manifest (launch file path, args). |

**Response:**

| Field | Type | Description |
|---|---|---|
| `output` | `PlanManifest` | Updated manifest after launch/stop. |
| `success` | `bool` | Whether the launch operation succeeded. |
| `err_msg` | `string` | Error message if `success` is `False`. |

```python
from muto_msgs.srv import LaunchPlugin
from muto_msgs.msg import PlanManifest, StackManifest

req = LaunchPlugin.Request()
req.start = True
req.input = PlanManifest()
req.input.current = StackManifest()
req.input.current.launch_description_source = 'launch/navigation.launch.py'
req.input.current.args = '{"use_sim_time": "true"}'
```

### ProvisionPlugin

Provision (download/checkout) stack source code before deployment.

**Request:**

| Field | Type | Description |
|---|---|---|
| `start` | `bool` | `True` to start provisioning. |
| `input` | `PlanManifest` | Pipeline context with stack manifest (URL, branch). |

**Response:**

| Field | Type | Description |
|---|---|---|
| `output` | `PlanManifest` | Updated manifest with `source` path populated. |
| `success` | `bool` | Whether provisioning succeeded. |
| `err_msg` | `string` | Error message if `success` is `False`. |

```python
from muto_msgs.srv import ProvisionPlugin
from muto_msgs.msg import PlanManifest, StackManifest

req = ProvisionPlugin.Request()
req.start = True
req.input = PlanManifest()
req.input.current = StackManifest()
req.input.current.url = 'https://github.com/example/nav-stack.git'
req.input.current.branch = 'main'

# response.output.current.source will contain the local checkout path
```

### CoreTwin

Generic string-in/string-out service for digital-twin queries.

**Request:**

| Field | Type | Description |
|---|---|---|
| `input` | `string` | Query string (typically JSON). |

**Response:**

| Field | Type | Description |
|---|---|---|
| `output` | `string` | Result string (typically JSON). |

```python
from muto_msgs.srv import CoreTwin

req = CoreTwin.Request()
req.input = '{"query": "get_thing_state"}'

# response.output contains the JSON result
```

## Part of Eclipse Muto

Eclipse Muto is an adaptive framework and runtime for managing ROS 2 software stacks on autonomous vehicles and edge devices. See the [main repository](https://github.com/eclipse-muto/muto) for full documentation.

## License

[Eclipse Public License 2.0](LICENSE)
