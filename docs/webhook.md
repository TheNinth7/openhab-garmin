# Custom Webhook

If your openHAB setup does not support the JSON-based REST API for sending commands, you can configure a custom Webhook using the Webhook binding instead.

Follow the steps below to set it up:

---

## 1. Install the Webhook Binding

Install the [Webhook HTTP binding](https://community.openhab.org/t/webhook-http-binding/152184).

![Webhook Installation](screenshots/custom-webhook/1_Webhook_installation.png)

---

## 2. Create a Webhook Thing

Create a new Webhook Thing.

![Thing Creation](screenshots/custom-webhook/2_1_Thing_creation.png)

Go to the **Code** tab and enter the following YAML (replace `UID` with your own):

```yaml
UID: webhook:Webhook:d1097152a4
label: Webhook
thingTypeUID: webhook:Webhook
configuration:
  expression: resp.status=200
channels:
  - id: lastCall
    channelTypeUID: webhook:lastCall-channel
    label: Last request
    configuration: {}
  - id: trigger
    channelTypeUID: webhook:trigger-channel
    label: Trigger
    configuration:
      expression: >-
        {
          var gson = new("com.google.gson.Gson");
          var jsonRoot = {:}; var jsonBody = {:};
          if (!empty(req.body.text)) jsonBody.put("text", req.body.text);
          if (!empty(req.body.json)) jsonBody.put("json", req.body.json);
          jsonRoot.put("parameters", req.parameters);
          jsonRoot.put("body", jsonBody);
          jsonRoot.put("method", req.method);
          return gson.toJson(jsonRoot);
        }
```

![Thing Channels](screenshots/custom-webhook/2_4_Thing_channels.png)

---

## 3. Create a Rule with JavaScript

Create a [Rule](https://www.openhab.org/docs/concepts/rules.html) that triggers on webhook and runs this JavaScript:

```javascript
var request = JSON.parse(event.event);

var action = request.parameters.action?.[0] ?? null;
var itemName = request.parameters.itemName?.[0] ?? null;
var command = request.parameters.command?.[0] ?? null;

if (action === "sendCommand") {
  if (itemName && command) {
    items.getItem(itemName).sendCommand(command);
  } else {
    console.warn(`Webhook: sendCommand missing parameters (itemName='${itemName}', command='${command}')`);
  }
} else if (action === "toggle") {
  if (itemName) {
    var item = items.getItem(itemName);
    item.sendCommand(item.state === "ON" ? "OFF" : "ON");
  } else {
    console.warn(`Webhook: toggle missing itemName`);
  }
} else {
  console.warn(`Webhook: invalid or missing action '${action}'`);
}
```

| Parameter | Description |
|-----------|-------------|
| `action`  | `"sendCommand"` or `"toggle"` |
| `itemName` | Name of the item to control |
| `command`  | Command to send (for `sendCommand`) |

---

## 4. Test & Connect

You can test the webhook by visiting:

```
https://yourserver:yourport/webhook/d1097152a4?action=toggle&itemName=LightBedroom
```

Then enter the Webhook ID (`d1097152a4`) in the app settings:

![App Settings](screenshots/app-settings/app-settings-webhook.png)

---