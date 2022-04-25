//
//  TruckFeedViewController.swift
//  Food Track
//
//  Created by Hernan Hernandez on 4/25/22.
//

import UIKit
import Parse
import AlamofireImage

class TruckFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var truckTableView: UITableView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        truckTableView.rowHeight = 250
        truckTableView.delegate = self
        truckTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Trucks")
        query.includeKeys(["Name", "Description.owner"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.truckTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = truckTableView.dequeueReusableCell(withIdentifier: "truckPostCell") as! truckPostCell
        let post = posts[indexPath.row]
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        // let truckName = post["Name"]
        cell.truckNameLabel.text = post["Name"] as? String
        cell.descriptionLabel.text = post["Description"] as? String
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
