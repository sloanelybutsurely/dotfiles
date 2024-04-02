function vitally-reset-database
  set -l current_directory $(pwd)

  cd ~/code/Vitallyio/vitally/master/

  # destroy and recreate docker containers
  docker-compose down -v
  docker-compose up -d

  # setup the databases
  PGPASSWORD=password dev/setup_dev_dbs.sh -h localhost -U postgres -p 5432 -w

  cd $current_directory

  # seed the empty environment
  yarn migrate
  yarn seed:plans 
  yarn seed --subdomain dev --organizations 15 --accounts 60
end
