import SwiftUI

struct AvatarSelectionView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    let avatars = [
        Avatar(name: "Male Explorer", imageName: "male_avatar"),
        Avatar(name: "Female Explorer", imageName: "female_avatar"),
        Avatar(name: "Robot Explorer", imageName: "robot_avatar")
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
                            Image(avatar.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(selectedAvatar == avatar ? Color.blue : Color.clear, lineWidth: 4)
                                )
                            
                            Text(avatar.name)
                                .font(.caption)
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