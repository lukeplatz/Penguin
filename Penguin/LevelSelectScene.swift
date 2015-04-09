//
//  MainMenuScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit


class LevelSelectScene: SKScene, UITableViewDelegate, UITableViewDataSource  {
    
    let title = SKSpriteNode(imageNamed: "LevelSelectTitle")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let level1Button = SKSpriteNode(imageNamed: "Level1")
    let table = UITableView()
    var NumLevelsUnlocked = 5
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        
        self.title.anchorPoint = CGPointMake(0.5, 0.5)
        self.title.xScale = (300/self.title.size.width)
        self.title.yScale = (100/self.title.size.height)
        self.title.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMaxY(self.frame) - 120)
        
        self.backButton.anchorPoint = CGPointMake(0.5, 0.5)
        self.backButton.xScale = (50/self.backButton.size.width)
        self.backButton.yScale = (50/self.backButton.size.height)
        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.backButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - statusbarHeight)
        
        //self.level1Button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 40 )
        
        table.frame  = CGRectMake(size.width * 0.2, size.height * 0.3, size.width * 0.6, size.height - (size.height * 0.3))
        table.backgroundColor = UIColor.clearColor()
        
        table.tableFooterView = UIView(frame: CGRectZero)
        table.dataSource = self
        table.delegate   = self
        table.allowsSelection = true
        self.view?.addSubview(table)
        
        self.addChild(title)
        self.addChild(backButton)
        //self.addChild(level1Button)
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backButton{
                var modeSelectionScene = ModeSelectionScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                modeSelectionScene.scaleMode = .ResizeFill
                modeSelectionScene.size = skView.bounds.size
                skView.presentScene(modeSelectionScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
                table.removeFromSuperview()
            }else{
                println("LevelSelectScene Background Pressed")
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel?.text = "Level \(indexPath.row + 1)"
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.font = UIFont(name: "Arial", size: 25)
        cell.textLabel?.textColor = UIColor.orangeColor()
        
        cell.backgroundColor = UIColor.clearColor()
        
        if (indexPath.row + 1 > NumLevelsUnlocked){
            cell.userInteractionEnabled = false
            cell.textLabel?.enabled = false
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("Level: \(indexPath.row + 1)!")
        
        switch (indexPath.row + 1){
        case (1):
            var levelC = LevelCScene.unarchiveFromFile("LevelC")! as LevelCScene
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            levelC.scaleMode = .ResizeFill
            skView.presentScene(levelC, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            table.removeFromSuperview()
        case (2):
            var levelD = LevelDScene.unarchiveFromFile("LevelD")! as LevelDScene
            levelD.scaleMode = .ResizeFill
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            skView.presentScene(levelD, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            table.removeFromSuperview()
        case (3):
            var levelE = LevelEScene.unarchiveFromFile("LevelE")! as LevelEScene
            levelE.scaleMode = .ResizeFill
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            skView.presentScene(levelE, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            table.removeFromSuperview()
        case (4):
            var levelB = LevelBScene.unarchiveFromFile("LevelB")! as LevelBScene
            levelB.scaleMode = .ResizeFill
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            skView.presentScene(levelB, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            table.removeFromSuperview()
        case (5):
            var levelA = LevelAScene.unarchiveFromFile("LevelA")! as LevelAScene
            levelA.scaleMode = .ResizeFill
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            skView.presentScene(levelA, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            table.removeFromSuperview()
        default:
            println("Level Not Unlocked!")
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
