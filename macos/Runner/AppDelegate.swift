import Cocoa
import FlutterMacOS
import WidgetKit

private let appGroupId = "group.dmytrowidget"
private let widgetKind = "NewsWidgets"

@main
class AppDelegate: FlutterAppDelegate {
    private var lastWidgetReloadAt: Date?
    private var channelsConfigured = false
    private var channelSetupAttempts = 0

    override func applicationDidFinishLaunching(_ notification: Notification) {
        scheduleMethodChannelSetup()
    }

    private func scheduleMethodChannelSetup() {
        guard !channelsConfigured else {
            return
        }

        if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
            setupWidgetMethodChannel(controller: controller)
            setupSharedContainerMethodChannel(controller: controller)
            channelsConfigured = true
            return
        }

        channelSetupAttempts += 1
        if channelSetupAttempts > 30 {
            assertionFailure("FlutterViewController is not available on mainFlutterWindow")
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scheduleMethodChannelSetup()
        }
    }

    private func setupWidgetMethodChannel(controller: FlutterViewController) {
        let widgetChannel = FlutterMethodChannel(
            name: "com.newsglance.home_widget",
            binaryMessenger: controller.engine.binaryMessenger
        )

        widgetChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "saveWidgetData":
                self.saveWidgetData(call: call, result: result)
            case "updateWidget":
                self.updateWidget(call: call, result: result)
            case "setAppGroupId":
                self.setAppGroupId(call: call, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func setupSharedContainerMethodChannel(controller: FlutterViewController) {
        let sharedContainerChannel = FlutterMethodChannel(
            name: "com.turskyi.weather_fit/shared_container",
            binaryMessenger: controller.engine.binaryMessenger
        )

        sharedContainerChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "getSharedContainerPath" {
                if let url = FileManager.default.containerURL(
                    forSecurityApplicationGroupIdentifier: appGroupId) {
                    result(url.path)
                } else {
                    result(
                        FlutterError(
                            code: "UNAVAILABLE",
                            message: "Shared container for \(appGroupId) not found",
                            details: nil
                        )
                    )
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func setAppGroupId(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // For macOS, app group ID is configured at build time via entitlements
        // This is a no-op for macOS but kept for API consistency
        result(nil)
    }

    private func saveWidgetData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let key = args["key"] as? String,
              let appGroupId = args["appGroupId"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing key or appGroupId", details: nil))
            return
        }

        let value = args["value"]
        guard let defaults = UserDefaults(suiteName: appGroupId) else {
            result(
                FlutterError(
                    code: "USERDEFAULTS_ERROR", message: "Failed to access UserDefaults with app group",
                    details: nil))
            return
        }

        if let stringValue = value as? String {
            defaults.set(stringValue, forKey: key)
        } else if let intValue = value as? Int {
            defaults.set(intValue, forKey: key)
        } else if let doubleValue = value as? Double {
            defaults.set(doubleValue, forKey: key)
        } else if let boolValue = value as? Bool {
            defaults.set(boolValue, forKey: key)
        } else if value is NSNull {
            defaults.removeObject(forKey: key)
        } else {
            result(
                FlutterError(code: "UNSUPPORTED_TYPE", message: "Value type is not supported", details: nil)
            )
            return
        }

        defaults.synchronize()
        result(true)
    }

    private func updateWidget(call: FlutterMethodCall, result: @escaping FlutterResult) {
        #if DEBUG
        // Keep debug runs stable on macOS; WidgetCenter calls can be noisy on some systems.
        result(true)
        return
        #else
        // Avoid over-triggering WidgetKit daemon calls when Flutter asks for frequent updates.
        let minimumReloadInterval: TimeInterval = 60
        let now = Date()
        if let lastReload = lastWidgetReloadAt,
           now.timeIntervalSince(lastReload) < minimumReloadInterval {
            result(true)
            return
        }

        lastWidgetReloadAt = now
        WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
        result(true)
        #endif
    }

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
