
import Foundation

struct UserViewData{
    
    let name: String
    let age: String
}

protocol UserViewProtocol: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setUsers(_ users: [UserViewData])
    func setEmptyUsers()
}

class UserPresenter {
    fileprivate let userService:UserService
    weak fileprivate var userViewDelagate : UserViewProtocol?
    
    init(userService:UserService){
        self.userService = userService
    }
    
    func attachViewProtocol(_ view:UserViewProtocol){
        userViewDelagate = view
    }
    
    func detachView() {
        userViewDelagate = nil
    }
    
    func getUsers(){
        
        // 1
        self.userViewDelagate?.startLoading()
        
        userService.getUsers{ [weak self] users in
            
            // 2
            self?.userViewDelagate?.finishLoading()
            
            if(users.count == 0){
                // 3
                self?.userViewDelagate?.setEmptyUsers()
            }else{
                let mappedUsers = users.map{
                    return UserViewData(name: "\($0.firstName) \($0.lastName)", age: "\($0.age) years")
                }
                
                // 4
                self?.userViewDelagate?.setUsers(mappedUsers)
            }
            
        }
    }
}
