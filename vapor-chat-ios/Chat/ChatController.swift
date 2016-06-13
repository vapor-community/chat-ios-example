import UIKit

class VaporChatController: ChatController {

    // MARK: Model -- interacts w/ vapor server
    
    private lazy var model: ChatModel = ChatModel(self)

    // MARK: LifeCycle

    override func viewDidAppear(animated: Bool) {
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

    override func chatInput(chatInput: ChatInput, didSendMessage message: String) {
        super.chatInput(chatInput, didSendMessage: message)
        model.send(message)
    }

    // MARK: Interaction

    private func askForName() {
        let new = UIAlertController(title: "What's your GitHub name?", message: nil, preferredStyle: .Alert)
        new.addTextFieldWithConfigurationHandler { _ in }
        let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default) { [weak self] action in
            self?.model.username = new.textFields?.first?.text
            self?.model.start()
        }
        new.addAction(action)
        presentViewController(new, animated: true, completion: nil)
    }

    internal func showDisconnect() {
        let new = UIAlertController(title: "Disconnected", message: nil, preferredStyle: .Alert)
        let kill = UIAlertAction(title: "Kill", style: UIAlertActionStyle.Default) { action in
            fatalError()
        }
        let tryAgain = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default) { [weak self] action in
            if self?.model.username == "null" {
                self?.askForName()
            } else {
                self?.model.start()
            }
        }
        new.addAction(kill)
        new.addAction(tryAgain)
        presentViewController(new, animated: true, completion: nil)
    }
}
