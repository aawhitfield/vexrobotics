//
//  AddTeamTableViewController.swift
//  VEX Robotics
//
//  Created by Aaron Whitfield on 11/30/14.
//  Copyright (c) 2014 Aaron Whitfield. All rights reserved.
//

import UIKit
import CoreData

var editingMode = false



class AddTeamTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate  {

    //var picker:UIImagePickerController? = UIImagePickerController()
    
    // IBOutlets
    @IBOutlet var teamNumber: UITextField!
    @IBOutlet var schoolName: UITextField!
    @IBOutlet var teamImage: UIButton!
    @IBOutlet var teamImageView: UIImageView!
    @IBOutlet var favoriteHeart: UIButton!
    @IBOutlet var pushBotImg: UIImageView!
    @IBOutlet var skyriseImg: UIImageView!
    @IBOutlet var cubeImg: UIImageView!
    @IBOutlet var bothImg: UIImageView!
    @IBOutlet var numSkyriseLabel: UILabel!
    @IBOutlet var skyriseSlider: UISlider!
    @IBOutlet var postSlider: UISlider!
    @IBOutlet var postLabel: UILabel!
    @IBOutlet var cubeOnSkyriseSlider: UISlider!
    @IBOutlet var cubesOnSkyriseLabel: UILabel!
    @IBOutlet var liftSpeedSlider: UISlider!
    @IBOutlet var liftReliabilityField: UITextField!
    @IBOutlet var driveSpeedSlider: UISlider!
    @IBOutlet var driveTypeField: UITextField!
    @IBOutlet var autoloaderPointsField: UITextField!
    @IBOutlet var autoloaderConsistencyField: UITextField!
    @IBOutlet var postPointsField: UITextField!
    @IBOutlet var postConsistencyField: UITextField!
    @IBOutlet var overallSlider: UISlider!
    @IBOutlet var overallSliderLabel: UILabel!
    @IBOutlet var notesField: UITextView!
    
    
    
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    
    // local variables
    var favorite = 0
    var teamImageFile = UIImage(named: "placeholder2.png")
    var functionType: String = "0"
    var numSkyriseSections: Int = 0
    var postType = 0
    var numCubesOnSkyrise = 0
    var liftSpeed = 0.0
    var liftReliability = ""
    var driveSpeed = 0.0
    var driveType = ""
    var autoloaderPoints = ""
    var autoloaderConsistency = ""
    var postPoints = ""
    var postConsistency = ""
    var averageAutonomous = 0.0
    var averageConsistency = 0.0
    var overallScore = 0.0
    var notes = ""
    
    
    
    
    
    
    
    
    
    
    
    //IBActions
    
    @IBAction func toggleFavorite(sender: AnyObject)
    {
        favorite++;
        favorite = favorite % 2
        if (favorite == 1)
        {
            favoriteHeart.setImage(UIImage(named: "heart-outline-32-red.png"), forState: .Normal)
        }
        
        else
        {
            favoriteHeart.setImage(UIImage(named: "heart-outline-32.png"), forState: .Normal)
        }
    }
    
    @IBAction func cancelButton(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addTeam(sender: AnyObject)
    {
        var newTeam = Team()
        
        //check to make sure there are no duplicates
        
        var isUnique = true
        
        for team in teamList
        {
            if team.name == teamNumber.text
            {
                isUnique = false
            }
        }
        
        // check to make sure that the team number field is not blank
        if teamNumber.text == ""
        {
            // add alert prompting user to enter a team number
            var alert = UIAlertController(title: "Error", message: "Please enter a team number.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                //self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)

        }
            
        else if isUnique == false
        {
            // update team instead
            
                // find the duplicate record
            for var i = 0; i < teamList.count; i++
                {
                    if teamList[i].name == teamNumber.text
                    {
                        let teamToBeUpdated = updateTeam()
                        teamList[i] = teamToBeUpdated           // update the local copy
                        
                        findAndDeleteOnline(teamToBeUpdated.name)
                        
                        addOnline(teamToBeUpdated)
                        
                    }
                }
            
            dismissViewControllerAnimated(true, completion: nil)
        }
            
        else if (liftReliabilityField.text.toInt() == nil && liftReliabilityField.text != "")
        {
            displayAlert("Invalid format", error: "Please enter a number for Lift Reliability")
        }
            
        else if autoloaderPointsField.text.toInt() == nil && autoloaderPointsField.text != ""
        {
            displayAlert("Invalid format", error: "Please enter a number for Autoloader Side Points")
        }
        
        else if autoloaderConsistencyField.text.toInt() == nil && autoloaderConsistencyField.text != ""
        {
            displayAlert("Invalid format", error: "Please enter a number for Autoloader side Consistency")
        }
        
        else if postPointsField.text.toInt() == nil && postPointsField.text != ""
        {
            displayAlert("Invalid format", error: "Please enter a number for Post Side Points")
        }
        
        else if postConsistencyField.text.toInt() == nil && postConsistencyField.text != ""
        {
            displayAlert("Invalid format", error: "Please enter a number for Post Side Consistency")
        }
            
        else // error free
        {
        
            // display busy signal
//            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
//            
//            activityIndicator.center = self.view.center
//            activityIndicator.hidesWhenStopped = true
//            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//            view.addSubview(activityIndicator)
//            activityIndicator.startAnimating()
//            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            self.pause(teamList)
            
            
            // add new team to the list
            newTeam = updateTeam()
            teamList.append(newTeam)
            
            // add online
            addOnline(newTeam)
            
            //close the view
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            dismissViewControllerAnimated(true, completion: nil)
        } // end else
    } // end viewDidLoad
    
    func updateTeam() -> Team
    {
        var newTeam = Team()
        
        newTeam.name = teamNumber.text
        newTeam.schoolName = schoolName.text
        newTeam.image = teamImageFile!
        newTeam.favorite = favorite
        newTeam.functionType = functionType
        newTeam.numSkyrise = numSkyriseSections
        newTeam.postType = postType
        newTeam.numCubesOnSkyrise = numCubesOnSkyrise
        newTeam.liftSpeed = liftSpeed
        newTeam.liftReliability = liftReliabilityField.text
        newTeam.driveSpeed = driveSpeed
        newTeam.driveType = driveTypeField.text
        newTeam.autoloaderPoints = autoloaderPointsField.text
        newTeam.autoloaderConsistency = autoloaderConsistencyField.text
        newTeam.postPoints = postPointsField.text
        newTeam.postConsistency = postConsistencyField.text
        newTeam.overallScore = overallScore
        newTeam.notes = notesField.text
        
        return newTeam
    }
    
    func addOnline(newTeam: Team) -> Void
    {
        var onlineTeam = PFObject(className: "Team")
        
        //convert the image file
        let imageData = UIImagePNGRepresentation(teamImageFile)
        let imageFile = PFFile(name: "image", data: imageData)
        
        onlineTeam["name"] = newTeam.name
        onlineTeam["fromUser"] = PFUser.currentUser()
        onlineTeam["schoolName"] = newTeam.schoolName
        onlineTeam["image"] = imageFile
        onlineTeam["favorite"] = newTeam.favorite
        onlineTeam["functionType"] = newTeam.functionType
        onlineTeam["numSkyrise"] = newTeam.numSkyrise
        onlineTeam["postType"] = newTeam.postType
        onlineTeam["numCubesOnSkyrise"] = newTeam.numCubesOnSkyrise
        onlineTeam["liftSpeed"] = newTeam.liftSpeed
        onlineTeam["liftReliability"] = newTeam.liftReliability
        onlineTeam["driveSpeed"] = newTeam.driveSpeed
        onlineTeam["driveType"] = newTeam.driveType
        onlineTeam["autoloaderPoints"] = newTeam.autoloaderPoints
        onlineTeam["autoloaderConsistency"] = newTeam.autoloaderConsistency
        onlineTeam["postPoints"] = newTeam.postPoints
        onlineTeam["postConsistency"] = newTeam.postConsistency
        onlineTeam["overallScore"] = newTeam.overallScore
        onlineTeam["notes"] = newTeam.notes
        onlineTeam.save()

        return
    }
    
    func findAndDeleteOnline(teamToDelete: String) -> Void
    {
        var query = PFQuery(className:"Team")
        query.whereKey("fromUser", equalTo: PFUser.currentUser())
        query.whereKey("name", equalTo: teamToDelete)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                
                // Do something with the found objects
                for object in objects {
                    NSLog("%@", object.objectId)
                    
                    object.delete()
                }
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }

        }
        return
    }
    
    
    
    func displayAlert(title:String, error:String)
    {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    @IBAction func pushBotButton(sender: AnyObject)
    {
        pushBotImg.image = UIImage(named: "snowplowSelected.gif")
        skyriseImg.image = UIImage(named: "skyrise sections gray.png")
        cubeImg.image = UIImage(named: "skyrise cube gray.png")
        bothImg.image = UIImage(named: "skyriseBothGray.png")
        functionType = "0"
        updateOverallScore(self)
    }
    
    
    @IBAction func skyriseButton(sender: AnyObject)
    {
        pushBotImg.image = UIImage(named: "snowplowGray.png")
        skyriseImg.image = UIImage(named: "skyrise sections transparent.png")
        cubeImg.image = UIImage(named: "skyrise cube gray.png")
        bothImg.image = UIImage(named: "skyriseBothGray.png")
        functionType = "1"
        updateOverallScore(self)
    }
    
    @IBAction func cubeButton(sender: AnyObject)
    {
        pushBotImg.image = UIImage(named: "snowplowGray.png")
        skyriseImg.image = UIImage(named: "skyrise sections gray.png")
        cubeImg.image = UIImage(named: "skyrise-cube-transparent.png")
        bothImg.image = UIImage(named: "skyriseBothGray.png")
        functionType = "2"
        updateOverallScore(self)
    }

    @IBAction func bothButton(sender: AnyObject)
    {
        pushBotImg.image = UIImage(named: "snowplowGray.png")
        skyriseImg.image = UIImage(named: "skyrise sections gray.png")
        cubeImg.image = UIImage(named: "skyrise cube gray.png")
        bothImg.image = UIImage(named: "skyriseBoth.png")
        functionType = "3"
        updateOverallScore(self)
    }
    
    @IBAction func skyriseSliderChanged(sender: AnyObject)
    {
        numSkyriseSections = Int(round(skyriseSlider.value))
        numSkyriseLabel.text = "\(numSkyriseSections)"
        
        updateRobotFunction()
    }
    
    @IBAction func postSliderChanged(sender: AnyObject)
    {
        postType = Int(round(postSlider.value))
        
        switch (postType)
        {
            case 0:
                postLabel.text = "Push" + "\n" + "Bot"
                break
            case 1:
                postLabel.text = "Small" + "\n" + "Post"
                break
            case 2:
                postLabel.text = "Medium" + "\n" + "Post"
                break
            case 3:
                postLabel.text = "Large" + "\n" + "Post"
                break
            default:
                postLabel.text = "Error"
        }
        
        updateRobotFunction()
    }
    
    @IBAction func cubesOnSkyriseChanged(sender: AnyObject)
    {
        numCubesOnSkyrise = Int(round(cubeOnSkyriseSlider.value))
        cubesOnSkyriseLabel.text = "\(numCubesOnSkyrise)"
        
        updateRobotFunction()
    }
    
    @IBAction func liftSpeedSliderChanged(sender: AnyObject)
    {
        liftSpeed = round(Double(liftSpeedSlider.value) * 100) / 100
        updateOverallScore(self)
    }
    
    
    @IBAction func driveSpeedSliderChanged(sender: AnyObject)
    {
        driveSpeed = round(Double(driveSpeedSlider.value) * 100) / 100
        updateOverallScore(self)
    }
    
    
    @IBAction func overallSliderChanged(sender: AnyObject)
    {
        //overallScore = overallSlider.value
        overallSliderLabel.text = "\(overallScore)"
    }
    
    
    @IBAction func updateOverallScore(sender: AnyObject)
    {
        //points based on function type
        switch (functionType)
        {
        case "0":
            overallScore = 0
            break
        case "1":
            overallScore = 1
            break
        case "2":
            overallScore = 2
            break
        case "3":
            overallScore = 3
            break
        default:
            println("Errror displaying robot function. No information stored in selectedTeam")
            //pushBotImg.image = UIImage(named: "snowplowSelected.gif")
            //selectedTeam.functionType = "1"
            
        }
        
        // 0.25 for each Skyrise section
        overallScore += Double(numSkyriseSections) * 0.25

        // 0.25 for each cube on a Skyrise section
        overallScore += Double(numCubesOnSkyrise) * 0.25
        
        // 0.33 for each additional type of post it can score on
        overallScore += round(Double(postType) * 1 / 3 * 100) / 100
        
        // up to 0.5 points for lift speed
        overallScore += liftSpeed
        
        // up to 0.5 points for drive speed
        overallScore += driveSpeed
        
        
        
        // up to 0.5 points for lift reliability 
        if (liftReliabilityField.text.toInt() == nil)
        {
            if liftReliabilityField.text == ""
            {
                overallScore += 0
            }
            
            else
            {
                displayAlert("Invalid format", error: "Please enter a number for Lift Reliability")
            }
        }
        
        else
        {
            overallScore += Double(liftReliabilityField.text.toInt()!) / 100 * 0.5
        }
        
        
        
        
        
        
        // average points of autonomous out of 6 points
        
        if (autoloaderPointsField.text.toInt() == nil && postPointsField.text.toInt() == nil)
        {
            
            overallScore += 0
        }
        
        else
        {
            if (autoloaderPointsField.text.toInt() == nil)
            {
                if autoloaderPointsField.text == ""
                {
                    averageAutonomous = Double(0 + postPointsField.text.toInt()!) / 2
                    overallScore += min(averageAutonomous / 6 * 0.5, 0.5)
                }
                    
                else
                {
                    displayAlert("Invalid format", error: "Please enter a number for Autoloader Side Points")
                }
            }
                
            if (postPointsField.text.toInt() == nil)
            {
                if postPointsField.text == ""
                {
                    averageAutonomous = Double(autoloaderPointsField.text.toInt()! + 0) / 2
                    overallScore += min(averageAutonomous / 6 * 0.5, 0.5)
                }
                    
                else
                {
                    displayAlert("Invalid format", error: "Please enter a number for Post Side Points")
                }
            }
        }
        
        if (autoloaderPointsField.text.toInt() != nil && postPointsField.text.toInt() != nil)
        {
            averageAutonomous = Double(autoloaderPointsField.text.toInt()! + postPointsField.text.toInt()!) / 2
            overallScore += min(averageAutonomous / 6 * 0.5, 0.5)
        }

        
        
        
        
        
        
        
        // average autonomous consistency percentage out of 0.5 points
        
        if (autoloaderConsistencyField.text.toInt() == nil && postConsistencyField.text.toInt() == nil)
        {
            
            overallScore += 0
        }
            
        else
        {
            if (autoloaderConsistencyField.text.toInt() == nil)
            {
                if autoloaderConsistencyField.text == ""
                {
                    averageConsistency = Double(0 + postConsistencyField.text.toInt()!) / 2
                    overallScore += min(averageConsistency / 100 * 0.5, 0.5)
                }
                    
                else
                {
                    displayAlert("Invalid format", error: "Please enter a number for Autoloader Side Consistency")
                }
            }
            
            if (postConsistencyField.text.toInt() == nil)
            {
                if postConsistencyField.text == ""
                {
                    averageConsistency = Double(autoloaderConsistencyField.text.toInt()! + 0) / 2
                    overallScore += min(averageConsistency / 100 * 0.5, 0.5)
                }
                    
                else
                {
                    displayAlert("Invalid format", error: "Please enter a number for Post Side Consistency")
                }
            }
        }
        
        if (autoloaderConsistencyField.text.toInt() != nil && postConsistencyField.text.toInt() != nil)
        {
            averageConsistency = Double(autoloaderConsistencyField.text.toInt()! + postConsistencyField.text.toInt()!) / 2
            overallScore += min(averageConsistency / 100 * 0.5, 0.5)
        }

        
        
        
        
        
        
        
        
        
        
        if (((overallScore * 10) % 10) == 0)
        {
            let overallScoreInt:Int = Int(overallScore)
            overallSliderLabel.text = "\(overallScoreInt)"
        }
        else
        {
            overallSliderLabel.text = "\(round(overallScore * 100) / 100)"
        }
    }
    
    
    
    // TableViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if (editingMode)
        {
            self.title = "Edit Team"
            
            // save all values
            teamNumber.text = "\(selectedTeam.name)"
            schoolName.text = "\(selectedTeam.schoolName)"
            teamImageView.image = selectedTeam.image
            teamImageFile = selectedTeam.image
            favorite = selectedTeam.favorite
            if (favorite == 1)
            {
                favoriteHeart.setImage(UIImage(named: "heart-outline-32-red.png"), forState: .Normal)
            }
                
            else
            {
                favoriteHeart.setImage(UIImage(named: "heart-outline-32.png"), forState: .Normal)
            }

            
            switch (selectedTeam.functionType)
            {
                case "0":
                    pushBotImg.image = UIImage(named: "snowplowSelected.gif")
                    break
                case "1":
                    skyriseImg.image = UIImage(named: "skyrise sections transparent.png")
                    break
                case "2":
                    cubeImg.image = UIImage(named: "skyrise-cube-transparent.png")
                    break
                case "3":
                    bothImg.image = UIImage(named: "skyriseBoth.png")
                    break
                default:
                    println("Errror displaying robot function. No information stored in selectedTeam")
                    //pushBotImg.image = UIImage(named: "snowplowSelected.gif")
                    //selectedTeam.functionType = "1"
                    
            }
           
            functionType = selectedTeam.functionType
            let numSkyriseFloat: Float = Float(selectedTeam.numSkyrise)
            skyriseSlider.value = numSkyriseFloat
            numSkyriseSections = selectedTeam.numSkyrise
            numSkyriseLabel.text = "\(selectedTeam.numSkyrise)"
            postSlider.value = Float(selectedTeam.postType)
            postSliderChanged(selectedTeam)
            let numCubesSkyriseFloat: Float = Float(selectedTeam.numSkyrise)
            cubeOnSkyriseSlider.value = numCubesSkyriseFloat
            numCubesOnSkyrise = selectedTeam.numCubesOnSkyrise
            cubesOnSkyriseLabel.text = "\(selectedTeam.numCubesOnSkyrise)"
           
            liftSpeedSlider.value = Float(selectedTeam.liftSpeed)
            liftSpeed = selectedTeam.liftSpeed
            liftReliabilityField.text = selectedTeam.liftReliability
            driveSpeedSlider.value = Float(selectedTeam.driveSpeed)
            driveSpeed = selectedTeam.driveSpeed
            driveTypeField.text = selectedTeam.driveType
           
            autoloaderPointsField.text = selectedTeam.autoloaderPoints
            autoloaderConsistencyField.text = selectedTeam.autoloaderConsistency
            postPointsField.text = selectedTeam.postPoints
            postConsistencyField.text = selectedTeam.postConsistency
            
            //overallSlider.value = Float(selectedTeam.overallScore)
            overallScore = selectedTeam.overallScore
            overallSliderLabel.text = "\(selectedTeam.overallScore)"
            notesField.text = selectedTeam.notes
            
            editingMode = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
*/
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
        updateOverallScore(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        updateOverallScore(self)
        return true;
    }
    

    @IBAction func pickImage(sender: AnyObject)
    {
        var image = UIImagePickerController()
        image.delegate = self
        
        
        var alert:UIAlertController = UIAlertController(title: "Add Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        var cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera(image)
        }
        
        var galleryAction = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallery(image)
        }
       
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)


        /*
        alert.delegate = self
        alert.message = "Choose Image Source"
        alert.addButtonWithTitle("Camera")
        alert.addButtonWithTitle("Photo Library")
        alert.show()
        */
        
        //image.sourceType = UIImagePickerControllerSourceType.Camera
        //image.allowsEditing = false
        
        //self.presentViewController(image, animated: true, completion: nil)

    }
    
    func openCamera(img: UIImagePickerController)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            img.sourceType = UIImagePickerControllerSourceType.Camera
            img.allowsEditing = true
            self.presentViewController(img, animated: true, completion: nil)
            
        }
        
        else
        {
            openGallery(img)
        }
    }
    
    func openGallery(img: UIImagePickerController)
    {
        img.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        img.allowsEditing = true
        self.presentViewController(img, animated: true, completion: nil)
    }
  
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        println("Image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        teamImageView.image = image
        teamImageFile = image
        
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        println("picker cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pause(sender: AnyObject)
    {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func updateRobotFunction()
    {
        if skyriseSlider.value >= 1 && (postSlider.value < 1 && cubeOnSkyriseSlider.value < 1)
        {
            skyriseButton(self)
        }
            
        else if skyriseSlider.value >= 1 && (postSlider.value >= 1 || cubeOnSkyriseSlider.value >= 1)
        {
            bothButton(self)
        }
            
        else if skyriseSlider.value < 1 && (postSlider.value >= 1 || cubeOnSkyriseSlider.value >= 1)
        {
            cubeButton(self)
        }
            
        else
        {
            pushBotButton(self)
        }

    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
