//
//  TeamListTableViewController.swift
//  VEX Robotics
//
//  Created by Aaron Whitfield on 11/30/14.
//  Copyright (c) 2014 Aaron Whitfield. All rights reserved.
//

import UIKit
import CoreData

var teamList = [Team]()
var selectedTeam:Team = Team()




class TeamListTableViewController: UITableViewController {
    
    @IBOutlet var teamTable:UITableView!
    @IBOutlet var testImageView: UIImageView!
    @IBOutlet var pic: UIImageView!
 

    override func viewDidLoad() {
        super.viewDidLoad()
        var bgImg = UIImage(named: "grayAbstract.jpg")
        var bgImgVw = UIImageView(image: bgImg)
        bgImgVw.alpha = 1.0
        
        self.tableView.backgroundView = bgImgVw
        
        
        self.tableView.rowHeight = 84
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        var editButton = self.editButtonItem()
        var sortButton:UIBarButtonItem = UIBarButtonItem(title: "Sort", style: UIBarButtonItemStyle.Plain, target: self, action: "sortButtonPressed:")
        var leftButtons = [editButton, sortButton]
        
        self.navigationItem.leftBarButtonItems = leftButtons
        
        
    }


    
    
    
    
    
    // IBActions
    
    @IBAction func sortButtonPressed(sender: AnyObject)
    {
        
        var alert:UIAlertController = UIAlertController(title: "Sort By", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        var byFavorite = UIAlertAction(title: "Favorites", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.sortByFavorites()
        }
        
        
        var bySchoolName = UIAlertAction(title: "School Name", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.sortBySchoolName()
        }
        
        var teamNumberSort = UIAlertAction(title: "Team Number", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.sortByTeamNumber()
        }
        
        var scoreSort = UIAlertAction(title: "Overall Score", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.sortByOverallScore()
            }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
        }
        
        alert.addAction(byFavorite)
        alert.addAction(bySchoolName)
        alert.addAction(teamNumberSort)
        alert.addAction(scoreSort)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    // class functions
    
    func sortByFavorites() -> Void     // bubble sort
    {
        
        var tempTeam:Team = Team()
        var swapped = true              // flag
        var leftName = 0
        var rightName = 0
        
        while(swapped)
        {
            swapped = false
            for (var i = 0; (i + 1) < teamList.count; i++)
            {
                
                leftName = teamList[i].favorite
                rightName = teamList[i+1].favorite
                
                if leftName < rightName
                {
                    tempTeam = teamList[i]
                    teamList[i] = teamList[i+1]
                    teamList[i+1] = tempTeam
                    swapped = true
                }
                
                
            }
        }
        
        self.tableView.reloadData()
        return
    }
    
    
    func sortByTeamNumber() -> Void     // bubble sort
    {
     
        var tempTeam:Team = Team()
        var swapped = true              // flag
        var leftName = ""
        var rightName = ""
        
        while(swapped)
        {
            swapped = false
            for (var i = 0; (i + 1) < teamList.count; i++)
            {
               
                leftName = teamList[i].name
                rightName = teamList[i+1].name
                
                if leftName > rightName
                {
                    tempTeam = teamList[i]
                    teamList[i] = teamList[i+1]
                    teamList[i+1] = tempTeam
                    swapped = true
                }
               
                
            }
        }

        self.tableView.reloadData()
        return
    }
    
    
    
    func sortBySchoolName() -> Void
    {
        
        var tempTeam:Team = Team()
        var swapped = true
        var leftName = ""
        var rightName = ""
        
        while(swapped)
        {
            swapped = false
            for (var i = 0; (i + 1) < teamList.count; i++)
            {
                
                leftName = teamList[i].schoolName
                rightName = teamList[i+1].schoolName
                
                if leftName > rightName
                {
                    tempTeam = teamList[i]
                    teamList[i] = teamList[i+1]
                    teamList[i+1] = tempTeam
                    swapped = true
                }
                
                
            }
        }
        
        self.tableView.reloadData()
        return
    }
    
    
    
    
    
    func sortByOverallScore() -> Void
    {
        
        var tempTeam:Team = Team()
        var swapped = true
        var leftName = 0.0
        var rightName = 0.0
        
        
        while(swapped)
        {
            swapped = false
            for (var i = 0; (i + 1) < teamList.count; i++)
            {
                
                leftName = teamList[i].overallScore
                rightName = teamList[i+1].overallScore
                
                if leftName < rightName
                {
                    tempTeam = teamList[i]
                    teamList[i] = teamList[i+1]
                    teamList[i+1] = tempTeam
                    swapped = true
                }
                
                
            }
        }
        
        self.tableView.reloadData()
        return
    }

    
    
    
    // Delegate functions
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return teamList.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as CustomCell

        // Configure the cell...
        /*cell.textLabel?.text = teamList[indexPath.row].name
        cell.detailTextLabel?.text = teamList[indexPath.row].schoolName
        let photoSize = CGSizeMake(0, 0)
        cell.imageView?.frame.size = photoSize
        cell.imageView?.contentMode = .ScaleAspectFill
        cell.imageView?.image = teamList[indexPath.row].image
        
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        */
        
        cell.picture.image = teamList[indexPath.row].image
        cell.title.text = teamList[indexPath.row].name
        cell.subtitle.text = teamList[indexPath.row].schoolName
        
        cell.title.textColor = UIColor.whiteColor()
        cell.subtitle.textColor = UIColor.whiteColor()
        
        if teamList[indexPath.row].favorite == 0
        {
            cell.heart.alpha = 0
        }
        
        else
        {
            cell.heart.alpha = 1
        }
        cell.backgroundColor = UIColor.clearColor()
        
        if (((teamList[indexPath.row].overallScore * 10) % 10) == 0)
        {
            let overallScoreInt:Int = Int(teamList[indexPath.row].overallScore)
            cell.overallScoreLabel.text = "Score: " + "\(overallScoreInt)"
        }
        else
        {
            cell.overallScoreLabel.text = "Score: " + "\(round(teamList[indexPath.row].overallScore * 100) / 100)"
        }

        
        
        cell.overallScoreLabel.textColor = UIColor.whiteColor()
        
        
        // abilityIcon
        switch (teamList[indexPath.row].functionType)
        {
        case "0":
            cell.abilityIcon.image = UIImage(named: "snowplowSelected.gif")
            break
        case "1":
            cell.abilityIcon.image = UIImage(named: "skyrise sections transparent.png")
            break
        case "2":
            cell.abilityIcon.image = UIImage(named: "skyrise-cube-transparent.png")
            break
        case "3":
            cell.abilityIcon.image = UIImage(named: "skyriseBoth.png")
            break
        default:
            println("Errror displaying robot function. No information stored in selectedTeam")
            cell.abilityIcon.alpha = 0
        }

        
        
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool)
    {
        teamList = []
        
        var query = PFQuery(className:"Team")
        query.whereKey("fromUser", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil
            {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                for object in objects {
                    //NSLog("%@", object.objectId)
            
                    var newTeam = Team()
                    
                    
                    //set image
                    let robotImageFile = object["image"] as PFFile
                    robotImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData!, error:NSError!) -> Void in
                        if error == nil
                        {
                            newTeam.image = UIImage(data: imageData)!
                            
                            newTeam.name = object["name"] as String
                            newTeam.schoolName = object["schoolName"] as String
                            newTeam.favorite = object["favorite"] as Int
                            newTeam.functionType = object["functionType"] as String
                            newTeam.numSkyrise = object["numSkyrise"] as Int
                            newTeam.postType = object["postType"] as Int
                            newTeam.numCubesOnSkyrise = object["numCubesOnSkyrise"] as Int
                            newTeam.liftSpeed = object["liftSpeed"] as Double
                            newTeam.liftReliability = object["liftReliability"] as String
                            newTeam.driveSpeed = object["driveSpeed"] as Double
                            newTeam.driveType = object["driveType"] as String
                            newTeam.autoloaderPoints = object["autoloaderPoints"] as String
                            newTeam.autoloaderConsistency = object["autoloaderConsistency"] as String
                            newTeam.postPoints = object["postPoints"] as String
                            newTeam.postConsistency = object["postConsistency"] as String
                            newTeam.overallScore = object["overallScore"] as Double
                            newTeam.notes = object["notes"] as String
                            
                            teamList.append(newTeam)
                            self.tableView.reloadData()
                        }
                    }
                    
                   
                    
                   
                        
                    
                    

                    
                    
                    
                    
                    
                }
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }

        

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedTeam = teamList[indexPath.row]
        editingMode = true
        self.performSegueWithIdentifier("seeDetails", sender: indexPath)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            var nameToDelete:String = teamList[indexPath.row].name as String
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            
            var query = PFQuery(className:"Team")
            query.whereKey("fromUser", equalTo: PFUser.currentUser())
            query.whereKey("name", equalTo: nameToDelete)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    
                    // Do something with the found objects
                    for object in objects {
                        NSLog("%@", object.objectId)
                        
                        object.delete()
                        self.viewWillAppear(true)
                    
                        
                       
                        
                    }
                } else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
                
                
                

        } //else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
