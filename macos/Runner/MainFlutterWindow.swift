import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // iPhone 16 Pro portrait ratio (402×874), scaled for desktop default window.
    let phoneWidth: CGFloat = 480
    let phoneHeight: CGFloat = (phoneWidth * 874) / 402
    let screenFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1280, height: 800)
    let originX = screenFrame.midX - phoneWidth / 2
    let originY = screenFrame.midY - phoneHeight / 2
    let windowFrame = NSRect(x: originX, y: originY, width: phoneWidth, height: phoneHeight)
    self.setFrame(windowFrame, display: true)
    self.minSize = NSSize(width: 402, height: 874)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
