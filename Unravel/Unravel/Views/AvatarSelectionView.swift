import SwiftUI

struct AvatarSelectionView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    let avatars = [
        Avatar(name: "Explorer", imageName: "explorer_avatar"),
        Avatar(name: "Scientist", imageName: "scientist_avatar"),
        Avatar(name: "Detective", imageName: "detective_avatar")
    ]
    
    @State private var selectedAvatar: Avatar?

    var body: some View {
        VStack {
            Text("Choose Your Avatar")
                .font(.largeTitle)
                .padding()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(avatars) { avatar in
                        VStack {
                            // Placeholder for avatar image
                            Circle()
                                .frame(width: 100, height: 100)
                                .foregroundColor(selectedAvatar == avatar ? .blue : .gray)
                            
                            Text(avatar.name)
                        }
                        .onTapGesture {
                            selectedAvatar = avatar
                        }
                    }
                }
                .padding()
            }

            Button("Start Game") {
                if let selectedAvatar = selectedAvatar {
                    gameViewModel.selectedAvatar = selectedAvatar
                    gameViewModel.gameStarted = true
                }
            }
            .padding()
            .background(selectedAvatar != nil ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(selectedAvatar == nil)
        }
    }
}

struct AvatarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarSelectionView()
            .environmentObject(GameViewModel())
    }
} 