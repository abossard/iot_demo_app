import UIKit
import SnapKit

//struct Section {
//    var title:String
//    var cells: [UITableViewCell]
//}

class MainView: UIViewController, BackendViewControllerDelegate {

    var headerView: UILabel!
    var backendSelector: UIButton!

    var backendViewController: BackendViewController!
    //var sectionData = [Section(title: "Connection", cells: <#T##[UITableViewCell]##[UIKit.UITableViewCell]#>)]

    private func createHeader(title: String) -> UILabel {
        let result = UILabel()
        result.text = title
        result.backgroundColor = .red
        result.textAlignment = .center
        return result
    }
    
    private func createBackendSelector() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Choose a backend", for: .normal)
        button.addTarget(self, action: #selector(MainView.switchToBackendSelection(_:)), for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.backendViewController = BackendViewController()
        self.backendViewController.delegate = self
        self.title = "IoT Demo App"
        headerView = createHeader(title: "<select backend>")
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {(make) -> Void in
            make.top.equalToSuperview().offset(80)
            make.width.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        backendSelector = createBackendSelector()
        self.view.addSubview(backendSelector)
        backendSelector.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerView.snp.bottom)
            make.width.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true;
    }
    
    @objc
    func switchToBackendSelection(_ sender: UIButton!) {
        print("Button pressed")
        self.navigationController?.pushViewController(self.backendViewController, animated: true)
    }

    func backendViewController(_ backendViewController: BackendViewController, selectConnectionString: String) {
        self.headerView.text = selectConnectionString
    }
}

