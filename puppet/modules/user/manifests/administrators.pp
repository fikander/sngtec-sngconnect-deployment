class user::administrators {

  include user::virtual

  realize( User::Virtual::Ssh_user["msiedlarek"] )

}
