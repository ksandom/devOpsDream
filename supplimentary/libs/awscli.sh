# Libraries for the AWS CLI

function getAWSCLIProfiles
{
	# TODO Add support for a global config if such a thing exists.
	echo default
	grep '\[profile' ~/.aws/config | sed 's/^\[profile //g; s/].*//g'
}
