//
//  MainMenuScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit
import UIKit


class HighscoreScene: SKScene, UITableViewDelegate, UITableViewDataSource {
    
    let title = SKSpriteNode(imageNamed: "HighscoresTitle")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let resetButton = SKSpriteNode(imageNamed: "ResetButton")
    let score = SKLabelNode(fontNamed: "Arial")
    var NumLevelsUnlocked = 2
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    //****************
    let cloud1 = SKSpriteNode(imageNamed: "Penguin")
    let cloud2 = SKSpriteNode(imageNamed: "Penguin")
    var scenes:[SKSpriteNode] = []
    let table = UITableView()
    let highScoreBannerView = UIImageView()
    
    var refreshControl: UIRefreshControl!
    
    //for displaying correct table
    var story = true
    var endless = false
    
    let endlessButton = UIButton()
    let storyButton = UIButton()
    
    let PURPLE   = UIColor(red: 122/255, green: 113/255, blue: 254/255, alpha: 1)
    let SKY_BLUE = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        cloud1.anchorPoint = CGPointZero
        cloud1.position = CGPointMake(size.width * 0.6, size.height * 0.65)
        self.addChild(cloud1)
        
        cloud2.anchorPoint = CGPointZero
        cloud2.position = CGPointMake(0, size.height * 0.62)
        self.addChild(cloud2)
        scenes.append(cloud1)
        scenes.append(cloud2)
        
        table.frame  = CGRectMake(size.width * 0.2, size.height * 0.1, size.width * 0.6, size.height)
        table.backgroundColor = UIColor.clearColor()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        
        
        highScoreBannerView.frame = CGRectMake(size.width * 0.2, 0, size.width * 0.6, size.height * 0.1)
        highScoreBannerView.image = UIImage(named: "HighscoresTitle")
        self.view?.addSubview(highScoreBannerView)
        
        table.tableFooterView = UIView(frame: CGRectZero)
        table.dataSource = self
        table.delegate   = self
        table.allowsSelection = false
        self.view?.addSubview(table)
        
        let buttonHeader = UIView(frame: CGRectMake(0, 0, table.bounds.width, table.bounds.height * 0.1))
        //story set up
        storyButton.frame = CGRectMake(0, 0, buttonHeader.bounds.width/2, buttonHeader.bounds.height)
        //set colors
        storyButton.backgroundColor = SKY_BLUE
        storyButton.setTitleColor(PURPLE, forState: UIControlState.Normal)
        
        storyButton.addTarget(self, action: "storyTouched", forControlEvents: UIControlEvents.TouchUpInside)
        storyButton.setTitle("Story", forState: UIControlState.Normal)
        buttonHeader.addSubview(storyButton)
        
        
        //endless button set up
        endlessButton.frame = CGRectMake(buttonHeader.bounds.width/2, 0, buttonHeader.bounds.width/2, buttonHeader.bounds.height)
        endlessButton.backgroundColor = PURPLE
        endlessButton.setTitleColor(SKY_BLUE, forState: UIControlState.Normal)
        endlessButton.setTitle("Endless", forState: UIControlState.Normal)
        endlessButton.addTarget(self, action: "endlessTouched", forControlEvents: UIControlEvents.TouchUpInside)
        buttonHeader.addSubview(endlessButton)
        
        table.tableHeaderView = buttonHeader
        
        self.backButton.name = "back"
        self.backButton.anchorPoint = CGPointMake(0.5, 0.5)
        self.backButton.xScale = (50/self.backButton.size.width)
        self.backButton.yScale = (50/self.backButton.size.height)
        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.backButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - statusbarHeight)

        self.addChild(backButton)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        let location = touches.anyObject()?.locationInNode(self)
        
        let touchedNode = self.nodeAtPoint(location!)
        
        if (touchedNode.name == "back") {
            let transition = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5)
            transition.pausesIncomingScene = true
            
            let mainScene = MainMenuScene(size:self.size)
            mainScene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(mainScene, transition: transition)
            table.removeFromSuperview()
            highScoreBannerView.removeFromSuperview()
            
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        for cloud in scenes {
            cloud.position.x -= 2
            if (cloud.position.x <= -cloud.size.width) {
                cloud.position.x =  size.width
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(story){
            return NumLevelsUnlocked
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var score = NSUserDefaults.standardUserDefaults().integerForKey("highscore\(indexPath.row + 1)")
        
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)

        if (story) {
            if (score != 0) {
                cell.textLabel?.text = "Level \(indexPath.row + 1):"
                cell.detailTextLabel?.text = String(score)
            }
            cell.textLabel?.text = "Level \(indexPath.row + 1):"
            cell.detailTextLabel?.text = "0"
        }
        else {
            //Endless Mode
            cell.textLabel?.text = "No Highscores"
            cell.detailTextLabel?.text = ":("
        }
        cell.textLabel?.font = UIFont(name: "Arial", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 20)
        cell.detailTextLabel?.textColor = UIColor.orangeColor()
        cell.textLabel?.textColor = UIColor.orangeColor()
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func refreshFeed(sender: AnyObject) {
        println("Refresh")
        self.table.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func endlessTouched() {
        if (story) {
            self.refreshControl.addTarget(self, action: "refreshFeed:", forControlEvents: UIControlEvents.ValueChanged)
            self.table.addSubview(refreshControl)
        }
        endless = true
        story = false
        table.reloadData()
        endlessButton.backgroundColor = SKY_BLUE
        endlessButton.setTitleColor(PURPLE, forState: UIControlState.Normal)
        
        storyButton.backgroundColor = PURPLE
        storyButton.setTitleColor(SKY_BLUE, forState: UIControlState.Normal)
        
    }
    
    func storyTouched() {
        if (endless) {
            self.refreshControl.removeTarget(self, action: "refreshFeed:", forControlEvents: nil)
            self.refreshControl.removeFromSuperview()
        }
        endless = false
        story = true
        table.reloadData()
        endlessButton.backgroundColor = PURPLE
        endlessButton.setTitleColor(SKY_BLUE, forState: UIControlState.Normal)
        
        storyButton.backgroundColor = SKY_BLUE
        storyButton.setTitleColor(PURPLE, forState: UIControlState.Normal)
    }
    //****************
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    override func didMoveToView(view: SKView) {
//        
//        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
//        
//        self.title.anchorPoint = CGPointMake(0.5, 0.5)
//        self.title.xScale = (300/self.title.size.width)
//        self.title.yScale = (100/self.title.size.height)
//        self.title.position = CGPointMake(CGRectGetMidX(self.frame),
//            CGRectGetMaxY(self.frame) - 120)
//        
//        self.backButton.anchorPoint = CGPointMake(0.5, 0.5)
//        self.backButton.xScale = (50/self.backButton.size.width)
//        self.backButton.yScale = (50/self.backButton.size.height)
//        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.backButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - statusbarHeight)
//
//        PlayerScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
//        self.score.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
//        self.score.text = "Score: \(PlayerScore)"
//        
//        self.resetButton.anchorPoint = CGPointMake(0.5, 0.5)
//        self.resetButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + statusbarHeight)
//        
//        
//        self.addChild(score)
//        self.addChild(title)
//        self.addChild(backButton)
//        self.addChild(resetButton)
//        
//    }
//    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        /* Called when a touch begins */
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            if self.nodeAtPoint(location) == self.backButton{
//                var mainMenuScene = MainMenuScene(size: self.size)
//                let skView = self.view! as SKView
//                skView.ignoresSiblingOrder = true
//                mainMenuScene.scaleMode = .ResizeFill
//                mainMenuScene.size = skView.bounds.size
//                skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
//                
//            }else if self.nodeAtPoint(location) == self.resetButton{
//                PlayerScore = 0
//                NSUserDefaults.standardUserDefaults().setInteger(PlayerScore, forKey: "highscore")
//                NSUserDefaults.standardUserDefaults().synchronize()
//                
//                self.score.text = "Score: \(PlayerScore)"
//                println("reset")
//            }else{
//                println("HighscoreScene Background Pressed")
//            }
//        }
//    }
//    
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//        
//    }
}
