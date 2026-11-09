import QtQuick
import Quickshell
import Quickshell.Io

// Launcher plugin: search Firefox history.
// places.py dumps the entries as JSON; they are cached here and filtered per keystroke.
// The cache is refreshed in the background when a search runs and it is older than refreshMs.
QtObject {
    id: root

    property var pluginService: null
    property string pluginId: "firefoxHistory"
    property string trigger: "ff"

    // Optional settings (plugin_settings.json → "firefoxHistory")
    property string profilePath: ""   // empty = default profile from installs.ini/profiles.ini
    property int indexLimit: 5000
    property int minQueryLength: 2

    readonly property int refreshMs: 120000
    readonly property string scriptPath: Qt.resolvedUrl("places.py").toString().replace(/^file:\/\//, "")

    property var entries: []
    property double lastRefresh: 0

    signal itemsChanged

    property Process indexer: Process {
        command: ["python3", "-I", root.scriptPath, root.profilePath, String(root.indexLimit)]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    root.entries = data.map(e => ({
                                url: e.u,
                                title: e.t,
                                haystack: (e.t + " " + e.u).toLowerCase()
                            }));
                    root.lastRefresh = Date.now();
                    console.info("[FirefoxHistory] Indexed", root.entries.length, "entries");
                    root.itemsChanged();
                    if (root.pluginService && typeof root.pluginService.requestLauncherUpdate === "function")
                        root.pluginService.requestLauncherUpdate(root.pluginId);
                } catch (err) {
                    console.warn("[FirefoxHistory] Failed to parse index:", err);
                }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0)
                    console.warn("[FirefoxHistory]", text.trim());
            }
        }
    }

    onPluginServiceChanged: {
        if (!pluginService)
            return;
        trigger = pluginService.loadPluginData(pluginId, "trigger", "ff");
        profilePath = pluginService.loadPluginData(pluginId, "profilePath", "");
        indexLimit = parseInt(pluginService.loadPluginData(pluginId, "indexLimit", 5000)) || 5000;
        minQueryLength = parseInt(pluginService.loadPluginData(pluginId, "minQueryLength", 2)) || 2;
        refresh();
    }

    function refresh() {
        if (!indexer.running)
            indexer.running = true;
    }

    function displayUrl(url) {
        return url.replace(/^https?:\/\/(www\.)?/, "").replace(/\/$/, "");
    }

    function getItems(query) {
        if (Date.now() - lastRefresh > refreshMs)
            refresh();

        const q = (query || "").trim().toLowerCase();
        if (q.length < minQueryLength)
            return [];

        const tokens = q.split(/\s+/);
        const titleHits = [];
        const urlHits = [];
        for (let i = 0; i < entries.length; i++) {
            const e = entries[i];
            if (!tokens.every(t => e.haystack.indexOf(t) !== -1))
                continue;
            // Entries are pre-sorted by frecency; title matches go before URL-only matches.
            (e.title.toLowerCase().indexOf(tokens[0]) !== -1 ? titleHits : urlHits).push(e);
            if (titleHits.length >= 20)
                break;
        }

        return titleHits.concat(urlHits).slice(0, 20).map(e => ({
                    name: e.title,
                    icon: "material:history",
                    comment: displayUrl(e.url),
                    action: "open:" + e.url,
                    categories: ["Firefox"]
                }));
    }

    function executeItem(item) {
        if (!item?.action || !item.action.startsWith("open:"))
            return;
        Quickshell.execDetached(["xdg-open", item.action.substring(5)]);
    }
}
