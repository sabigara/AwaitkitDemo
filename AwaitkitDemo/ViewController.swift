import UIKit
import AwaitKit
import os


class ViewController: UIViewController, UITableViewDataSource {
    var posts: [[String: String]] = [[:]]
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func getPostsOfUser() {
        async {
            var users: [AnyObject] = []
            do {
                users = try await(httpClient.getAllUsers())
            } catch {
                print(error)
            }
            
            guard let firstUser = users[0] as? [String: Any],
                let firstUserId = firstUser["id"] as? Int else {
                return
            }
            
            var postsAnyObject: [AnyObject] = []
            do {
                postsAnyObject = try await(httpClient.getPostsOfUser(userId: firstUserId))
            } catch {
                print(error)
            }
            
            self.posts = postsAnyObject.map { post -> [String: String] in
                var titleAndBody: [String: String] = [:]
                if let postTitle = post["title"] as? String,
                    let postBody = post["body"] as? String {
                    titleAndBody["title"] = postTitle
                    titleAndBody["body"] = postBody
                    return titleAndBody
                } else {
                    return [:]
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostCell")! as! PostTableViewCell
        
        guard let title = posts[indexPath.row]["title"],
            let body = posts[indexPath.row]["body"] else {
            return cell
        }
        
        cell.titleLabel.text = "Title: \(title)\n"
        cell.bodyLabel.text = "Body: \(body)"
        
        return cell
    }

}

