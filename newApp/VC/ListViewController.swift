//
//  ListViewController.swift
//  newApp
//
//  Created by Mac on 2024/6/16.
//

import UIKit

class ListViewController: UIViewController {
    
    var urlStrings = [ "https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/1%E7%B4%9A.json",
                       "https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/2%E7%B4%9A.json",
                       "https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/3%E7%B4%9A.json",
                       "https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/4%E7%B4%9A.json",
                       "https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/5%E7%B4%9A.json",
                       "https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/6%E7%B4%9A.json"]
    var urlString = "https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/1%E7%B4%9A.json"
    
    var model = [Vocabulary]()
    var viewModel = ListViewControllerViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchVocabulary()
    }
    
    func fetchVocabulary() {
        guard let url = URL(string: urlString) else { return }
        //            //設置 API 的 url
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
        //            //透過 URLSession 送出 urlRequest
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }
            //＊decode func 有備註 throw，故需使用 do-try-catch 的格式來撰寫。
            do {
                //提前建立好 [Vocabulary] struct，將 API JSON 資料解碼後存在自己設定的變數 vocabulary 中
                self.model = try JSONDecoder().decode([Vocabulary].self, from: data)
                //在 main thread 中刷新資料
                DispatchQueue.main.async {
                    self.setVC(viewModel: self.viewModel) // Ensure to set viewModel after fetching data
                    self.tableView.reloadData()
                }
                //如果失敗則印出 error
            } catch {
                print("Error decoding JSON: \(error)")
            }
            //開始執行
        }.resume()
    }
    
    
    func setVC(viewModel: ListViewControllerViewModel) {
        viewModel.setViewModel(response: model)
    }
    
    @IBAction func selectLevel(_ sender: UISegmentedControl) {
        self.urlString = urlStrings[sender.selectedSegmentIndex]
        fetchVocabulary()
        print(urlString)
    }
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.setCell(viewModel: viewModel.listTableCellViewModels[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundView = UIView()
        cell?.backgroundColor = .clear
        presentViewController()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ListViewController: ListTableViewCellDelegate {
    func presentViewController() {
        guard let vc = getVC(st: "Main", vc: "ListDescribtionViewController") as? ListDescribtionViewController else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedViewModel = viewModel.listDescribtionViewModels[indexPath.row]
            vc.setVC(viewModel: selectedViewModel)
            self.present(vc, animated: true)
        }
    }
}

extension ListViewController {
    func getVC(st: String, vc: String) -> UIViewController {
        let storyboard = UIStoryboard(name: st, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: vc)
        return viewController
    }
}
