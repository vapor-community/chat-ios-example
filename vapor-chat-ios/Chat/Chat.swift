import Starscream

internal class ChatModel {

    let webSocket: WebSocket
    lazy var username: String! = "null"
    private let chatURL = URL(string: "wss://vapor-chat.herokuapp.com/chat")!
    
    // Probably not best to store here, but just trying to get something up quickly
    weak var controller: VaporChatController?

    init(_ controller: VaporChatController) {
        self.controller = controller
        self.webSocket = WebSocket(request: URLRequest(url: chatURL))
        webSocket.delegate = self
    }

    func start() {
        webSocket.connect()
    }

    func send(_ msg: String) {
        let json = "{\"message\":\"\(msg)\"}"
        webSocket.write(string: json)
    }
    
    private func onConnect(webSocket: WebSocket) {
        guard let username = self.username else { return }
        webSocket.write(string: "{\"username\":\"\(username)\"}")
    }

    private func onText(text: String) {
        guard let data = text.data(using: .utf8) else { return }

        do {
            guard let js = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else { return }
            guard
                let username = js["username"] as? String,
                let content = js["message"] as? String
                else { return }
            let message = ChatMessage(sentBy: .opponent, content: "\(username): \(content)", timeStamp: nil, imageUrl: nil)
            self.controller?.addNewMessage(message)
        }
        catch {
            print(error)
        }
    }
    
    private func onDisconnect() {
        self.controller?.showDisconnect()
    }
}


extension ChatModel: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected:
            onConnect(webSocket: client)
        case .disconnected:
            onDisconnect()
        case .text(let text):
            onText(text: text)
        default:
            return
        }
    }
}
