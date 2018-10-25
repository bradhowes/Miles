//: ## [Previous](@previous)
import UIKit
import PlaygroundSupport
import AVFoundation
import Miles

let names = ["Kick", "Snare", "Hat", "Ride", "Bass", "Piano"]

class ViewController : UIViewController {
    
    var list: UITableView!
    var play: UIButton!
    var activeIndex: Int = -1

    override func loadView() {
        let main = UIView()
        main.backgroundColor = .white

        let play = UIButton(type: .system)
        play.setTitle("Play", for: .normal)
        play.isEnabled = false
        main.addSubview(play)

        play.addTarget(self, action: #selector(doPlay), for: .touchDown)
        
        let list = UITableView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), style: .plain)
        list.dataSource = self
        list.delegate = self
        main.addSubview(list)

        play.translatesAutoresizingMaskIntoConstraints = false
        list.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            list.topAnchor.constraint(equalTo: main.topAnchor, constant: 20),
            list.leadingAnchor.constraint(equalTo: main.leadingAnchor),
            list.trailingAnchor.constraint(equalTo: main.trailingAnchor),
            list.bottomAnchor.constraint(equalTo: play.topAnchor),

            play.leadingAnchor.constraint(equalTo: main.leadingAnchor),
            play.trailingAnchor.constraint(equalTo: main.trailingAnchor),
            play.heightAnchor.constraint(equalToConstant: 80),
            play.bottomAnchor.constraint(equalTo: main.bottomAnchor)
            ])

        self.view = main
        self.play = play
    }
    
    @objc func doPlay(_ sender: UIButton) {
        print("do play \(self.activeIndex)")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int { return names.count }
    func tableView(_ tableView: UITableView, cellForRowAt: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = names[cellForRowAt.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.play.isEnabled = true
        self.activeIndex = indexPath.row
    }
}

PlaygroundPage.current.liveView = ViewController()

//let notificationsVC = UITableViewController()
//
//class NotificationsDataSource: NSObject, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int { return items.count }
//    func tableView(_ tableView: UITableView, cellForRowAt: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = items[cellForRowAt.row]
//        return cell
//    }
//}
//
//class NotificationsTableDelegate: NSObject, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
//}
//
//let dataSource = NotificationsDataSource()
//let tableDelegate = NotificationsTableDelegate()
//
//notificationsVC.tableView.dataSource = dataSource
//notificationsVC.tableView.delegate = tableDelegate
//
//let viewVC = UIViewController()
//viewVC.view.addSubview(notificationsVC.view)
//
//PlaygroundPage.current.needsIndefiniteExecution = true
//PlaygroundPage.current.liveView = viewVC

//: ## [Previous](@previous)
