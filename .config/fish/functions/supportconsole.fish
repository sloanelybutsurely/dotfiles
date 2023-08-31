set -g vitally_aws_profile "Developers-194594848450"

function log_into_vitally_aws
  aws sts get-caller-identity --profile $vitally_aws_profile --no-cli-pager > /dev/null
  if test $status -ne 0
    aws sso login --profile $vitally_aws_profile
  end
end

function get_vitally_prod_region
  if test "$argv" = "eu"
    echo "eu-north-1"
  else
    echo "us-east-1"
  end
end

function supportconsole
  log_into_aws

  set region (get_vitally_prod_region "$argv")
  set target (aws ec2 describe-instances --profile $vitally_aws_profile --region $region --filter Name=instance-state-name,Values=running Name=tag:Class,Values=support-bastion-host Name=tag:Environment,Values=production --query "Reservations[0].Instances[0].InstanceId" --output text)

  echo "connecting to $region production console"
  aws ssm start-session --profile $vitally_aws_profile --region $region --target $target
end
