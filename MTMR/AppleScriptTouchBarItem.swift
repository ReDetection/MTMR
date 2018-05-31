import Foundation

class AppleScriptTouchBarItem: CustomButtonTouchBarItem {
    private let xpc = NSXPCConnection(serviceName: "Toxblh.MTMR.XPC-AppleScript")
    private let remoteExecutor: XPC_AppleScriptProtocol
    private let interval: TimeInterval
    private var forceHideConstraint: NSLayoutConstraint!
    private let source: String!
    
    init?(identifier: NSTouchBarItem.Identifier, source: SourceProtocol, interval: TimeInterval) {
        self.interval = interval
        self.xpc.remoteObjectInterface = NSXPCInterface(with: XPC_AppleScriptProtocol.self)
        self.xpc.interruptionHandler = {
            print("interrupted")
        }
        self.xpc.invalidationHandler = {
            print("invalidated")
        }
        self.xpc.resume()
//        self.xpc.
        self.remoteExecutor = xpc.remoteObjectProxy as! XPC_AppleScriptProtocol
        self.source = source.string
        super.init(identifier: identifier, title: "⏳")
        self.forceHideConstraint = self.view.widthAnchor.constraint(equalToConstant: 0)
        guard self.source != nil else {
            self.title = "no script"
            return
        }
        self.isBordered = false
        self.refreshAndSchedule()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.xpc.invalidate()
    }
    
    func refreshAndSchedule() {
        #if DEBUG
            print("refresh happened (interval \(self.interval)), self \(self.identifier.rawValue))")
        #endif
        remoteExecutor.runAppleScript(self.source) { [weak self] (scriptResult) in
            guard let selfie = self else {return}
            DispatchQueue.main.async {
                guard let selfie = self else {return}
                let newTitle = scriptResult ?? "error"
                selfie.title = newTitle
                selfie.forceHideConstraint.isActive = newTitle == ""
                #if DEBUG
                print("did set new script result title \(newTitle) (interval \(selfie.interval))")
                #endif
            }
            DispatchQueue.appleScriptQueue.asyncAfter(deadline: .now() + selfie.interval) { [weak self] in
                self?.refreshAndSchedule()
            }
        }
    }
    
}

extension SourceProtocol {
    var appleScript: NSAppleScript? {
        guard let source = self.string else { return nil }
        return NSAppleScript(source: source)
    }
}

extension DispatchQueue {
    static let appleScriptQueue = DispatchQueue(label: "mtmr.applescript")
}
