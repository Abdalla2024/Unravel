import SpriteKit

class GameScene: SKScene {
    private var gameViewModel: GameViewModel?
    private var player: SKSpriteNode?
    
    private var stickPosition: CGPoint = .zero
    private let moveSpeed: CGFloat = 2.0

    override func didMove(to view: SKView) {
        // Set up scene physics
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        sceneBody.friction = 0
        self.physicsBody = sceneBody

        // Access the view model
        if let userData = userData, let gameViewModel = userData["gameViewModel"] as? GameViewModel {
            self.gameViewModel = gameViewModel
            setupScene(with: gameViewModel)
        }
    }

    private func setupScene(with viewModel: GameViewModel) {
        // Set up the background
        let background = SKSpriteNode(imageNamed: viewModel.currentRoom.backgroundImage)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = frame.size
        background.zPosition = -1 // Behind other nodes
        addChild(background)

        // Set up the player
        if let avatar = viewModel.selectedAvatar {
            let playerNode = SKSpriteNode(imageNamed: avatar.imageName)
            playerNode.position = CGPoint(x: frame.midX, y: frame.midY)
            playerNode.size = CGSize(width: 50, height: 50) // Adjust size as needed
            playerNode.name = "player"
            
            // Add physics body to player
            playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
            playerNode.physicsBody?.affectedByGravity = false
            playerNode.physicsBody?.allowsRotation = false
            
            self.player = playerNode
            addChild(playerNode)
        }
    }

    func updateStickPosition(_ newPosition: CGPoint) {
        self.stickPosition = newPosition
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        guard let player = player else { return }
        
        let normalizedPosition = CGPoint(x: stickPosition.x / 50.0, y: stickPosition.y / 50.0)
        
        let newX = player.position.x + (normalizedPosition.x * moveSpeed)
        let newY = player.position.y - (normalizedPosition.y * moveSpeed) // Inverted Y-axis for SpriteKit
        
        player.position = CGPoint(x: newX, y: newY)
    }
}