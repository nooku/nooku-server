class nginx {
  include nginx::install
  include nginx::config
  include nginx::service
}