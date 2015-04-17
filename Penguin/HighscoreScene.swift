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
    
    let title = SKSpriteNode(imageNamed: "highScoresTitle")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let score = SKLabelNode(fontNamed: "Arial")
    var NumLevelsUnlocked = 6
    var backStuff = SKNode.unarchiveFromFile("HillsBackgroundNOPENGY")! as SKNode
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
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

        table.frame  = CGRectMake(size.width * 0.2, size.height * 0.2, size.width * 0.6, size.height)
        table.backgroundColor = UIColor.clearColor()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        
        
        highScoreBannerView.frame = CGRectMake(size.width * 0.2, size.height * 0.1, size.width * 0.6, size.height * 0.1)
        highScoreBannerView.image = UIImage(named: "highScoresTitle")
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
        backButton.zPosition = 100
        self.addChild(backButton)
        self.addChild(backStuff)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        let location = touches.anyObject()?.locationInNode(self)
        
        let touchedNode = self.nodeAtPoint(location!)
        
        if (touchedNode.name == "back") {
            var mainMenuScene = MainMenuScene.unarchiveFromFile("MainMenu") as MainMenuScene
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            mainMenuScene.scaleMode = .ResizeFill
            skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
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
                cell.detailTextLabel?.text = "\(score)"
            }else{
                cell.textLabel?.text = "Level \(indexPath.row + 1):"
                cell.detailTextLabel?.text = "0"
            }
        }
        else {
            //Endless Mode
            var EndlessScore = NSUserDefaults.standardUserDefaults().integerForKey("highscoreEndless")
            cell.textLabel?.text = "Score: "
            cell.detailTextLabel?.text = "\(EndlessScore)"
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
}
