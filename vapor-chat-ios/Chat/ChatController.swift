import UIKit

class VaporChatController: ChatController {

    // MARK: Model -- interacts w/ vapor server
    
    fileprivate lazy var model: ChatModel = ChatModel(self)

    // MARK: LifeCycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        askForName()
    }

    // MARK: Initial Setup

    internal override func setup() {
        super.setup()
        self.tableView.backgroundColor = nil
        self.view.backgroundColor = nil
    }

    // MARK: Chat Input -- From User

    override func chatInput(_ chatInput: ChatInput, didSendMessage message: String) {
        super.chatInput(chatInput, didSendMessage: message)
        model.send(message)
    }

    // MARK: Interaction

    fileprivate func askForName() {
        let new = UIAlertController(title: "What's your GitHub name?", message: nil, preferredStyle: .alert)
        new.addTextField { _ in }
        let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { [weak self] action in
            self?.model.username = new.textFields?.first?.text
            self?.model.start()
        }
        new.addAction(action)
        present(new, animated: true, completion: nil)
    }

    internal func showDisconnect() {
        let new = UIAlertController(title: "Disconnected", message: nil, preferredStyle: .alert)
        let kill = UIAlertAction(title: "Kill", style: UIAlertActionStyle.default) { action in
            fatalError()
        }
        let tryAgain = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default) { [weak self] action in
            if self?.model.username == "null" {
                self?.askForName()
            } else {
                self?.model.start()
            }
        }
        new.addAction(kill)
        new.addAction(tryAgain)
        present(new, animated: true, completion: nil)
    }
}
