node "app" {
  include apache2
  include massiveapp
  include mysql
  include passenger
}
