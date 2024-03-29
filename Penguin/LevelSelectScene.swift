//
//  MainMenuScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit


class LevelSelectScene: SKScene, UITableViewDelegate, UITableViewDataSource  {
    
    let title = SKSpriteNode(imageNamed: "selectLevel")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let level1Button = SKSpriteNode(imageNamed: "Level1")
    let table = UITableView()
    var NumLevelsUnlocked = 1
    var backStuff = SKNode.unarchiveFromFile("HillsBackground")! as SKNode
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
   
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        
        var i = 1
        while NSUserDefaults.standardUserDefaults().integerForKey("levelWon\(i)") == 1 {
            NumLevelsUnlocked++
            i++
        }

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
        self.addChild(backStuff)
        self.addChild(title)
        self.addChild(backButton)
        //self.addChild(level1Button)
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backButton{
                var ModeSelectScene = ModeSelectionScene.unarchiveFromFile("ModeSelection")! as ModeSelectionScene
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                ModeSelectScene.scaleMode = .ResizeFill
                skView.presentScene(ModeSelectScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
                table.removeFromSuperview()
            }else{
                println("LevelSelectScene Background Pressed")
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
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
        
        var levelXXX = PlayScene()
        
        switch (indexPath.row + 1){
        case (1):
            levelXXX = LevelCScene.unarchiveFromFile("LevelC")! as LevelCScene
        case (2):
            levelXXX = LevelKScene.unarchiveFromFile("LevelK")! as LevelKScene
        case (3):
            levelXXX = LevelJScene.unarchiveFromFile("LevelJ")! as LevelJScene
        case (4):
            levelXXX = LevelDScene.unarchiveFromFile("LevelD")! as LevelDScene
        case (5):
            levelXXX = LevelEScene.unarchiveFromFile("LevelE")! as LevelEScene
        case (6):
            levelXXX = LevelFScene.unarchiveFromFile("LevelF")! as LevelFScene
        case (7):
            levelXXX = LevelIScene.unarchiveFromFile("LevelI")! as LevelIScene
        case (8):
            levelXXX = LevelLScene.unarchiveFromFile("LevelL")! as LevelLScene
        case (9):
            levelXXX = LevelGScene.unarchiveFromFile("LevelG")! as LevelGScene
        case (10):
            levelXXX = LevelNScene.unarchiveFromFile("LevelN")! as LevelNScene
        case (11):
            levelXXX = LevelBScene.unarchiveFromFile("LevelB")! as LevelBScene
        case (12):
            levelXXX = LevelAScene.unarchiveFromFile("LevelA")! as LevelAScene
        case (13):
            levelXXX = LevelHScene.unarchiveFromFile("LevelH")! as LevelHScene
        case (14):
            levelXXX = LevelMScene.unarchiveFromFile("LevelM")! as LevelMScene
        case (15):
            levelXXX = LevelOScene.unarchiveFromFile("LevelO")! as LevelOScene
        default:
            println("Level Not Unlocked!")
        }
        
        levelXXX.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelXXX, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
        table.removeFromSuperview()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
