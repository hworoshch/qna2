server "79.143.31.55", user: "deployer", roles: %w{app db web}, primary: true
set :rails_env, :production

 set :ssh_options, {
   keys: %w(/home/zr4k/.ssh/id_rsa),
   forward_agent: true,
   auth_methods: %w(pubickey password),
   port: 2222
 }
