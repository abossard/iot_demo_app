import UIKit
import SnapKit

class MainView: UIViewController {

    var headerView: UIView!
    var backendSelector: UIView!
    var currentBackend: Backend?
    
    private func createHeader(title: String) -> UIView {
        let result = UILabel()
        result.text = title
        result.backgroundColor = .red
        result.textAlignment = .center
        return result
    }
    
    private func createBackendSelector() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle(currentBackend?.description ?? "<select backend>", for: .normal)
        button.addTarget(self, action: #selector(MainView.switchToBackendSelection(_:)), for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "IoT Demo App"
        headerView = createHeader(title: currentBackend?.host ?? "<select backend>")
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
        self.navigationController?.pushViewController(BackendViewController(), animated: true)
    }
    

}

