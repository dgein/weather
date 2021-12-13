

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {

    @IBOutlet var cityTableView: UITableView!
    
    var cityName = ""
    struct Citys {
        var  cityNames = ""
        var  cityTemp = ""
    }
    
    var cityTempArray: [Citys] = []
    
    
    func currentWhaether(sity: String){
        let url = "http://api.weatherapi.com/v1/current.json?key=7a4e32ed26e341f894370054212309&q=\(sity)"
        AF.request(url, method: .get).validate().responseJSON{response in
            switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let name = json["location"]["name"].stringValue
                    let temp = json["current"]["temp_c"].stringValue
                self.cityTempArray.append(Citys(cityNames: name, cityTemp: temp))
                    self.cityTableView.reloadData()
                case .failure(let error):
                    print(error)
                
            }
            
        }
    }
    @IBAction func addCitybtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Добавить", message: "Введите название города", preferredStyle: .alert)
        alert.addTextField {
            (textField) in textField.placeholder = "Moscow"
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let newCityAction = UIAlertAction(title: "Добавить", style: .default){(action) in
            let name = alert.textFields![0].text
            self.currentWhaether(sity: name!)
        }
        alert.addAction(cancelAction)
        alert.addAction(newCityAction)
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTableView.delegate = self
        cityTableView.dataSource = self
    }

    // MARK: - Table view data source

    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityTempArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resuseIndefifier", for: indexPath) as! City_Name
        cell.cityName.text = cityTempArray[indexPath.row].cityNames
        cell.cityTemp.text = String(cityTempArray[indexPath.row].cityTemp ) + " C"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        cityName = cityTempArray[indexPath.row].cityNames
        performSegue(withIdentifier: "cell", sender: self)
    }
   


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? detailMVC {
            vc.cityName = cityName
        }
    }
    

}
