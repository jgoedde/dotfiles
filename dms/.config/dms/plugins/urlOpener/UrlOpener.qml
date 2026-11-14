import QtQuick
import Quickshell

// Launcher plugin: if the query looks like a URL or domain (fast.com, https://x.org/a,
// localhost:3000, 192.168.0.1), offer a single item that opens it in the default browser.
// Runs before webSearch/firefoxHistory via launcherPluginOrder in settings.json.
QtObject {
    id: root

    property var pluginService: null
    property string trigger: ""

    signal itemsChanged

    // scheme://anything
    readonly property var schemeRe: /^[a-z][a-z0-9+.-]*:\/\/\S+$/i
    // host[:port][/path|?query|#fragment]; host = domain with alphabetic TLD, localhost or IPv4
    readonly property var hostRe: /^(?:(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]{2,24}|localhost|\d{1,3}(?:\.\d{1,3}){3})(?::\d{1,5})?(?:[\/?#]\S*)?$/i

    function toUrl(query) {
        const q = (query || "").trim();
        if (q.length === 0 || /\s/.test(q))
            return "";
        if (schemeRe.test(q))
            return q;
        if (hostRe.test(q)) {
            const local = /^(localhost|\d{1,3}(\.\d{1,3}){3})(:|\/|$)/i.test(q);
            return (local ? "http://" : "https://") + q;
        }
        return "";
    }

    function getItems(query) {
        const url = toUrl(query);
        if (!url)
            return [];
        return [
            {
                name: "Open " + query.trim(),
                icon: "material:open_in_browser",
                comment: url,
                action: "open:" + url,
                categories: ["Open URL"]
            }
        ];
    }

    function executeItem(item) {
        if (!item?.action || !item.action.startsWith("open:"))
            return;
        Quickshell.execDetached(["xdg-open", item.action.substring(5)]);
    }
}
